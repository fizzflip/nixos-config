# Hosts

Host definitions, hardware configurations, runtime specialisations, and deployment commands for the machines in this flake.

## 1. Machine Targets

| Target                                    | Role                  | Desktop            | Hardware Profile                                         |
| :---------------------------------------- | :-------------------- | :----------------- | :------------------------------------------------------- |
| **`nixosConfigurations.minimal`**         | Primary Workstation   | Niri + `dux-shell` | Intel Tiger Lake (Iris Xe), NVMe, Lanzaboote Secure Boot |
| **`nixosConfigurations.fluid`**           | Workstation Alternate | KDE Plasma 6       | Same machine as `minimal`, running Plasma 6 Wayland      |
| **`nixosConfigurations.machine`**         | Home Server           | Headless           | Intel Pentium G2020 (Ivy Bridge), ext4 on mechanical HDD |
| **`nixosConfigurations.machine-desktop`** | Auxiliary Desktop     | KDE Plasma 6       | Same server hardware with local display enabled          |
| **`nixosConfigurations.preview`**         | Fast VM Test          | Niri               | Minimal QEMU guest for checking config changes           |
| **`nixosConfigurations.preview-full`**    | Full VM Test          | Niri               | QEMU guest with the complete package suite               |
| **`nixosConfigurations.installer`**       | Installer Media       | Unattended ISO     | Generates an automated installer image (`installer-iso`) |

## 2. Layout

```text
hosts/
├── laptop/
│   ├── configuration.nix          # Laptop host baseline and specialisation overrides
│   └── hardware-configuration.nix  # Btrfs subvolumes, swap, and hardware scan
├── machine/
│   ├── configuration.nix          # Headless server services, HDD rules, and access
│   └── hardware-configuration.nix  # Ext4 mounts, commit intervals, and legacy driver scan
└── preview/
    └── configuration.nix          # Portable QEMU test target with dummy hardware
```

## 3. Workstation Specialisations (`laptop`)

The laptop configuration defines three runtime specialisations. You can switch between them on the running system without a reboot:

### Lab (`specialisation.lab`)

For development workflows that would clutter the base daily driver:

- **Podman**: Rootless container engine with local bridge networking.
- **Waydroid**: Android runtime with hardware rendering.
- **Libvirt / KVM**: Full hypervisor setup with QEMU, `virt-manager`, and software TPM 2.0 (`swtpm`).

### Windows (`specialisation.windows`)

Runs a Windows 11 guest directly off an NVMe block partition:

- **Direct Partition Mapping**: Bypasses Btrfs CoW and file-backed virtual disks by passing the physical `/dev/disk/by-partlabel/win-vm-disk` partition into QEMU.
- **Firmware**: OVMF UEFI with emulated TPM 2.0.
- **Drivers & Client**: VirtIO guest storage/network drivers with a pre-configured FreeRDP connection script.

### Gaming (`specialisation.gaming`)

Lowers latency and strips desktop background tasks:

- **Kernel**: Switches to `linux-cachyos-bore-lto` built for `x86_64-v4`.
- **Schedulers**: Disables `scx_loader` and `bpftune` to prevent BPF scheduler preemption against game threads. Autogrouping is set to 0.
- **Stack**: Kryoto Desktop, Feral GameMode, Gamescope (integer scaling and framerate limits), and MangoHud overlay.
- **Driver**: Switches the Intel GPU driver to `xe` for gaming performance.

## 4. Hardware Details

### Intel Tiger Lake Workstation (`hosts/laptop/`)

- **GPU**: Iris Xe (Gen 12) on `i915` with GuC/HuC firmware (`i915.enable_guc=3`), framebuffer compression, and panel self-refresh.
- **Video & Compute**: Intel Media Driver (`iHD`), Compute Runtime (OpenCL), and Intel VPL.
- **Storage**: Btrfs with `compress=zstd:1`, `noatime`, `discard=async`, and Kyber I/O scheduler targeting 2ms read latency.
- **RAM Builds**: `/tmp` and `nix-daemon` scratch space both live in `tmpfs` (100% RAM limit, backing into 7.5 GiB zRAM swap with `zstd`). This keeps intermediate compilation artifacts out of the NVMe drive's NAND flash.

### Intel Ivy Bridge Pentium Desktop (`hosts/machine/`)

- **GPU**: Intel HD Graphics 2500 (Gen 7) using `vaapiIntel` and Mesa Gallium.
- **Mechanical HDD Lifespan Rules**:
  - **BFQ Scheduler**: Prevents random mechanical seeks from freezing interactive shells.
  - **No Head Parking**: Enforces `hdparm -B 254 -S 0` to stop aggressive drive spindown cycles.
  - **Memory Limits**: Caps background writeback dirty memory at 50MB (`vm.dirty_background_bytes = 52428800`) to avoid periodic multi-second I/O stalls during large file writes.
  - **zRAM Swap**: All paging stays in RAM to avoid swap thrashing on slow magnetic disks.

## 5. Operations

### First-Time Installation

1. **Partition and mount storage**:

   ```bash
   mount /dev/disk/by-label/nixos /mnt
   mkdir -p /mnt/boot
   mount /dev/disk/by-label/BOOT /mnt/boot
   ```

2. **Clone repo**:

   ```bash
   git clone https://github.com/fizzflip/.nixos-config.git /mnt/etc/nixos/config
   cd /mnt/etc/nixos/config
   ```

3. **Generate hardware scan**:

   ```bash
   nixos-generate-config --show-hardware-config --root /mnt > hosts/laptop/hardware-configuration.nix
   ```

4. **Install**:
   ```bash
   git add .
   nixos-install --flake .#minimal --root /mnt
   ```

### Routine Maintenance

#### Switch desktop environments

```bash
sudo nixos-rebuild switch --flake .#minimal    # Niri (alias: rminimal)
sudo nixos-rebuild switch --flake .#fluid      # KDE Plasma 6 (alias: rfluid)
```

#### Switch specialisations live

```bash
# Activate specialisations without rebooting
sudo /run/current-system/specialisation/lab/bin/switch
sudo /run/current-system/specialisation/windows/bin/switch
sudo /run/current-system/specialisation/gaming/bin/switch

# Return to base system
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```

#### Check Secure Boot

```bash
sudo sbctl status
sudo sbctl verify
```

#### Run test VMs

```bash
nix run .#preview         # Fast minimal VM
nix run .#preview-full    # Complete desktop VM
```

#### Deploy server or build installer

```bash
sudo nixos-rebuild switch --flake .#machine
nix build .#installer-iso
```
