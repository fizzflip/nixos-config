# Automated Unattended Installer ISO for Ivy Bridge Desktop (Headless NixOS)
{
  inputs,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # 1. ISO format & bootability
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
  isoImage.squashfsCompression = "zstd -Xcompression-level 1";

  # Cache complete machine closure in installer ISO for offline unattended installation
  isoImage.storeContents = [
    inputs.self.nixosConfigurations.machine.config.system.build.toplevel
  ];

  # 2. Console autologin & power management
  services.getty.autologinUser = lib.mkForce "root";

  # 3. Embed this NixOS configuration repository directly into the live installer
  environment.etc."nixos-installer-config".source = inputs.self;

  # 4. Essential partitioning & installation utilities
  environment.systemPackages = with pkgs; [
    coreutils
    gawk
    gnugrep
    gnused
    findutils
    parted
    dosfstools
    e2fsprogs
    util-linux
    git
    rsync
  ];

  # 5. Automated unattended installation oneshot service
  systemd.services.automated-install = {
    description = "Automated Unattended NixOS Installation Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = with pkgs; [
      coreutils
      gawk
      gnugrep
      gnused
      findutils
      git
      rsync
      parted
      dosfstools
      e2fsprogs
      util-linux
      nix
      nixos-install-tools
      systemd
    ];
    serviceConfig = {
      Type = "oneshot";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
    script = ''
      set -euo pipefail
      echo "=========================================================="
      echo "  Starting Unattended Headless NixOS Installation"
      echo "=========================================================="

      # 0. Deactivate any existing swap devices to prevent partition busy errors
      echo "--> Deactivating all existing swap spaces..."
      swapoff -a 2>/dev/null || true

      echo "--> Discovering installation target disk..."

      # 1. Detect active live ISO boot media to exclude it
      BOOT_DEV=$(lsblk -no PKNAME $(findmnt -no SOURCE /iso 2>/dev/null) 2>/dev/null || true)
      if [ -z "$BOOT_DEV" ]; then
        BOOT_DEV=$(lsblk -no PKNAME $(findmnt -no SOURCE / 2>/dev/null) 2>/dev/null || true)
      fi
      if [ -z "$BOOT_DEV" ]; then
        ISO_SRC=$(findmnt -no SOURCE /iso 2>/dev/null || findmnt -no SOURCE / 2>/dev/null || true)
        if [ -n "$ISO_SRC" ]; then
          BOOT_DEV=$(lsblk -no PKNAME "$ISO_SRC" 2>/dev/null || true)
          [ -z "$BOOT_DEV" ] && BOOT_DEV=$(basename "$ISO_SRC")
        fi
      fi
      echo "Live installer medium detected: ''${BOOT_DEV:-none}"

      TARGET_DISK=""

      # Priority 1: Check for known internal Seagate Enterprise 1TB HDD
      for dev in /dev/disk/by-id/ata-ST1000NM0033*; do
        if [ -b "$dev" ] && [[ ! "$dev" =~ -part[0-9]+$ ]]; then
          CANDIDATE=$(readlink -f "$dev")
          if [ -b "$CANDIDATE" ] && [ "$(basename "$CANDIDATE")" != "$BOOT_DEV" ]; then
            TARGET_DISK="$CANDIDATE"
            echo "Selected target disk via model match (ST1000NM0033): $TARGET_DISK"
            break
          fi
        fi
      done

      # Priority 2: Fall back to first non-removable internal SATA/NVMe disk >= 50GB
      if [ -z "$TARGET_DISK" ]; then
        while read -r d type _; do
          [ "$type" = "disk" ] || continue
          case "$d" in
            loop*|zram*|sr*|dm-*) continue ;;
          esac
          if [ -n "$BOOT_DEV" ] && [ "$d" = "$BOOT_DEV" ]; then
            continue
          fi
          TRAN=$(lsblk -d -n -o TRAN "/dev/$d" 2>/dev/null || true)
          RM=$(cat "/sys/block/$d/removable" 2>/dev/null || echo "1")
          if [ "$TRAN" = "usb" ] || [ "$RM" = "1" ]; then
            echo "Skipping USB/removable device /dev/$d (TRAN=$TRAN, RM=$RM)"
            continue
          fi
          SIZE_BYTES=$(lsblk -b -d -n -o SIZE "/dev/$d" 2>/dev/null || echo "0")
          if [ "$SIZE_BYTES" -lt 50000000000 ]; then
            echo "Skipping disk /dev/$d due to small size ($SIZE_BYTES bytes)"
            continue
          fi
          TARGET_DISK="/dev/$d"
          echo "Selected target disk via device heuristic: $TARGET_DISK"
          break
        done < <(lsblk -d -n -o NAME,TYPE)
      fi

      # Validate selected target disk
      if [ -z "$TARGET_DISK" ] || [ ! -b "$TARGET_DISK" ]; then
        echo "ERROR: No suitable internal target disk found!" >&2
        echo "Detected block devices:" >&2
        lsblk -o NAME,SIZE,TYPE,TRAN,RM,MODEL >&2
        exit 1
      fi

      # Preemptively unmount any lingering partitions or stale /mnt mounts
      echo "--> Preemptively unmounting any target partitions or mounts..."
      umount -R "$TARGET_DISK"* 2>/dev/null || true
      umount -R /mnt 2>/dev/null || true

      # Safety: ensure target disk is not currently mounted in live system
      if findmnt -n -o SOURCE | grep -q "^$TARGET_DISK"; then
        echo "ERROR: Target disk $TARGET_DISK has active mounts in live system! Aborting." >&2
        findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS >&2
        exit 1
      fi

      # Determine partition device naming (e.g. /dev/sdb1 vs /dev/nvme0n1p1)
      if [[ "$TARGET_DISK" =~ [0-9]$ ]]; then
        BOOT_PART="''${TARGET_DISK}p1"
        ROOT_PART="''${TARGET_DISK}p2"
      else
        BOOT_PART="''${TARGET_DISK}1"
        ROOT_PART="''${TARGET_DISK}2"
      fi

      echo "--> Target disk verified: $TARGET_DISK (ESP: $BOOT_PART, Root: $ROOT_PART)"

      echo "--> 1. Wiping filesystem signatures and creating GPT partition table on $TARGET_DISK..."
      wipefs -a "$TARGET_DISK" 2>/dev/null || true
      parted -s "$TARGET_DISK" -- mklabel gpt
      parted -s "$TARGET_DISK" -- mkpart ESP fat32 1MiB 513MiB
      parted -s "$TARGET_DISK" -- set 1 esp on
      parted -s "$TARGET_DISK" -- mkpart primary ext4 513MiB 100%
      udevadm settle
      partprobe "$TARGET_DISK" 2>/dev/null || true
      udevadm settle

      echo "--> 2. Formatting EFI System Partition (BOOT)..."
      mkfs.fat -F 32 -n BOOT "$BOOT_PART"

      echo "--> 3. Formatting Root Linux Partition (nixos)..."
      mkfs.ext4 -F -L nixos -m 1 "$ROOT_PART"
      udevadm settle

      echo "--> 4. Mounting target filesystems with direct node fallback..."
      mount -o noatime,commit=60 /dev/disk/by-label/nixos /mnt 2>/dev/null || mount -o noatime,commit=60 "$ROOT_PART" /mnt
      mkdir -p /mnt/boot
      mount /dev/disk/by-label/BOOT /mnt/boot 2>/dev/null || mount "$BOOT_PART" /mnt/boot

      echo "--> 5. Deploying configuration repository from ISO..."
      mkdir -p /mnt/etc/nixos
      cp -a /etc/nixos-installer-config/. /mnt/etc/nixos/
      mkdir -p /mnt/home/mrbot/nixos-config
      cp -a /etc/nixos-installer-config/. /mnt/home/mrbot/nixos-config/

      # Ensure copied configurations are user-writable
      chmod -R u+w /mnt/etc/nixos /mnt/home/mrbot/nixos-config 2>/dev/null || true

      # Initialize local git repository for mrbot
      if [ -d /mnt/home/mrbot/nixos-config ]; then
        echo "--> Initializing git repository for mrbot..."
        git -C /mnt/home/mrbot/nixos-config init -b main 2>/dev/null || true
        git -C /mnt/home/mrbot/nixos-config config user.name "mrbot" 2>/dev/null || true
        git -C /mnt/home/mrbot/nixos-config config user.email "mrbot@localhost" 2>/dev/null || true
        git -C /mnt/home/mrbot/nixos-config add . 2>/dev/null || true
        git -C /mnt/home/mrbot/nixos-config commit -m "chore: initial nixos configuration" 2>/dev/null || true
        chown -R 1000:100 /mnt/home/mrbot/nixos-config 2>/dev/null || true
      fi

      echo "--> 6. Executing nixos-install (headless profile)..."
      nixos-install --no-root-password --flake /mnt/etc/nixos#machine

      echo "--> 7. Finalizing ownership and permissions..."
      if [ -d /mnt/home/mrbot/nixos-config ]; then
        chown -R 1000:100 /mnt/home/mrbot/nixos-config 2>/dev/null || true
      fi

      echo "--> 8. Synchronizing disks and unmounting..."
      sync
      umount -R /mnt || true

      echo "=========================================================="
      echo "  NixOS Installation Complete!"
      echo "  PLEASE REMOVE THE USB INSTALLATION DRIVE NOW!"
      echo "  Rebooting in 10 seconds... "
      echo "=========================================================="
      sleep 10
      reboot
    '';
  };
}
