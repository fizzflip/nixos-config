# Hosts & Deployment Guide

This directory contains host definitions, hardware configurations, runtime specialisations, and deployment workflows for all machines configured by this flake.

---

## 1. Machine Targets & Profiles

| Host Configuration | Target Environment | Desktop / Shell | Primary Hardware Profile |
| :--- | :--- | :--- | :--- |
| **`nixosConfigurations.fluid`** | Primary Workstation | KDE Plasma 6 (Wayland) | Intel 11th Gen Tiger Lake (Iris Xe Graphics), NVMe, Lanzaboote Secure Boot |
| **`nixosConfigurations.minimal`** | Primary Workstation | Niri (Wayland) + `dux-shell` | Intel 11th Gen Tiger Lake (Iris Xe Graphics), NVMe, Lanzaboote Secure Boot |
| **`nixosConfigurations.machine`** | Home Server | Headless (None) | Intel Pentium G2020 (Ivy Bridge Gen7 HD 2500), Rotational Mechanical HDD |
| **`nixosConfigurations.machine-desktop`**| Auxiliary Desktop | KDE Plasma 6 (Wayland) | Intel Pentium G2020 (Ivy Bridge Gen7 HD 2500), Rotational Mechanical HDD |
| **`nixosConfigurations.preview`** | Local QEMU VM | Niri (Wayland) | Minimal VM testing environment (isolated hardware parameters) |
| **`nixosConfigurations.preview-full`**| Local QEMU VM | Niri (Wayland) | Full VM testing environment with development & virtualization suite |
| **`nixosConfigurations.installer`** | Installation Media | Automated Unattended Installer | Builds bootable installation ISO (`installer-iso`) |

---

## 2. Directory Structure

```text
hosts/
├── laptop/                     # Primary mobile workstation
│   ├── configuration.nix       # Laptop host configuration & specialisation definitions
│   └── hardware-configuration.nix # Disks, Btrfs subvolumes, and generated hardware scan
├── machine/                    # Ivy Bridge Pentium desktop & headless server
│   ├── configuration.nix       # Server daemon toggles, HDD protections, and user access
│   └── hardware-configuration.nix # Ext4 storage and legacy hardware scan
└── preview/                    # QEMU VM testing targets
    └── configuration.nix       # Portability-first VM configuration with dummy hardware
```

---

## 3. Runtime Specialisations (`laptop`)

The primary workstation supports runtime specialisations that can be activated on the fly without a system reboot:

### Lab Specialisation (`specialisation.lab`)
Designed for containerization, Android development, and hypervisor virtualization:
- **Podman**: Rootless Docker-compatible container engine with DNS plugins.
- **Waydroid**: Containerized Android execution environment with hardware acceleration.
- **Libvirt / KVM**: Full hypervisor virtualization stack with QEMU, `virt-manager`, and SWTPM 2.0.

### Windows Virtualization (`specialisation.windows`)
Near-native Windows gaming and productivity VM:
- **Direct Partition Mapping**: Maps physical NVMe partitions (`win-vm-disk`) directly into the VM to eliminate Copy-on-Write (CoW) overhead.
- **UEFI & TPM**: OVMF firmware with TPM 2.0 emulation (`swtpm`) for Windows 11 compatibility.
- **VirtIO & Remote Desktop**: Pre-configured VirtIO guest drivers and FreeRDP client launcher.

### Gaming Specialisation (`specialisation.gaming`)
Low-latency desktop gaming stack:
- **Kryoto Desktop**: Standalone native gaming shell and launcher.
- **Feral GameMode**: Automatically prioritizes game processes, requests high CPU clocks, and optimizes scheduler priorities.
- **Gamescope & MangoHud**: Micro-compositor for integer scaling, HDR, and framerate containment, paired with MangoHud telemetry overlay.
- **spectraNET Toggle**: Option to toggle real-time network telemetry specifically during gaming sessions.

---

## 4. Hardware Profiles

### Intel Tiger Lake Workstation (`hosts/laptop/`)
- **Graphics**: Intel Iris Xe Graphics (Gen 12) with early KMS initrd `i915`, GuC/HuC firmware load (`enable_guc=3`), Framebuffer Compression (`enable_fbc=1`), and Panel Self Refresh (`enable_psr=1`).
- **Media Runtime**: Intel Media Driver (`iHD`), Intel Compute Runtime (OpenCL), and Intel VPL GPU runtime.
- **Storage**: High-performance NVMe running Btrfs with Kyber I/O latency targeting.
- **Power**: Non-adaptive `thermald` policies and runtime PCI power management.

### Intel Ivy Bridge Pentium Desktop (`hosts/machine/`)
- **Graphics**: Legacy Intel HD Graphics 2500 (Gen 7) with `vaapiIntel` hardware acceleration and Mesa Gallium drivers.
- **Rotational HDD Wear Protection**:
  - **BFQ I/O Scheduler**: Replaces modern NVMe schedulers with BFQ (Budget Fair Queueing) to ensure interactive desktop responsiveness under heavy mechanical disk load.
  - **APM Spindown Prevention**: Disables aggressive Advanced Power Management head parking to prevent mechanical drive actuator wear.
  - **ZRAM Compressed Swap**: Prevents swap thrashing on slow mechanical disks by compressing memory in RAM.
  - **Dirty Page Limits**: Strict 50MB background writeback limits (`vm.dirty_background_bytes = 52428800`) to prevent kernel I/O flushes from freezing userland.

---

## 5. Deployment & Operations

### First-Time Installation

1. **Partition & Mount Storage**:
   ```bash
   # Mount root partition to /mnt, EFI to /mnt/boot
   mount /dev/disk/by-label/nixos /mnt
   mkdir -p /mnt/boot
   mount /dev/disk/by-label/BOOT /mnt/boot
   ```

2. **Clone Configuration Repository**:
   ```bash
   git clone https://github.com/fizzflip/.nixos-config.git /mnt/etc/nixos/config
   cd /mnt/etc/nixos/config
   ```

3. **Generate Hardware Configuration**:
   ```bash
   nixos-generate-config --show-hardware-config --root /mnt > hosts/laptop/hardware-configuration.nix
   ```

4. **Install System**:
   ```bash
   git add .
   nixos-install --flake .#minimal --root /mnt
   ```

---

### Daily Operations

#### Rebuild & Switch Profiles
```bash
# Switch to Niri Wayland session (minimal profile)
sudo nixos-rebuild switch --flake .#minimal    # or fish alias: rminimal

# Switch to KDE Plasma 6 Wayland session (fluid profile)
sudo nixos-rebuild switch --flake .#fluid      # or fish alias: rfluid
```

#### Switch Specialisations Without Rebooting
```bash
# Switch to Lab environment (Containers & Android)
sudo /run/current-system/specialisation/lab/bin/switch

# Switch to Windows VM configuration
sudo /run/current-system/specialisation/windows/bin/switch

# Switch to Gaming environment
sudo /run/current-system/specialisation/gaming/bin/switch

# Return to base system configuration
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```

#### Secure Boot Integrity
```bash
# Inspect Secure Boot status
sudo sbctl status

# Verify all kernel, initrd, and UKI signatures
sudo sbctl verify
```

#### Local VM Testing
```bash
# Run lightweight minimal testing VM in QEMU
nix run .#preview

# Run comprehensive full-suite testing VM in QEMU
nix run .#preview-full
```

#### Ivy Bridge Machine & Unattended Installer
```bash
# Build automated unattended installation ISO
nix build .#installer-iso

# Deploy / switch on the remote machine
sudo nixos-rebuild switch --flake .#machine
sudo nixos-rebuild switch --flake .#machine-desktop
```
