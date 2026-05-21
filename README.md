# ❄️ NixOS daily driver

My NixOS daily driver. \
Mess? Kinda. Cleaning? Working on that.

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?logo=nixos&logoColor=white&color=5277C3)](https://nixos.org)
[![Kernel](https://img.shields.io/badge/Kernel-cachyos--lto--x86__64--v4-orange.svg?logo=linux&color=E25D25)](https://github.com/xddxdd/nix-cachyos-kernel)
[![Shell](https://img.shields.io/badge/Shell-Fish-brightgreen.svg?logo=fish-shell&logoColor=white&color=42A5F5)](https://fishshell.com)
[![Desktop](https://img.shields.io/badge/Desktop-KDE%20%2F%20Niri-blueviolet.svg?logo=niri&color=8A2BE2)](#-desktop-environments)

## Features

This repository is structured into easily toggleable modules. Out of the box, it supports:

### Desktop Environments

* **KDE Plasma (`fluid` profile)**: A feature-rich, beautiful, fluid, and complete desktop experience using Plasma 6 with custom SDDM themes.
* **Niri (`minimal` profile)**: A modern, scrollable-tile Wayland compositor integrated with **Dank Material Shell (`dms-shell`)**, offering:
  * Dynamic Material You theming and color palettes via `wallust`.
  * Interactive status bar with real-time system monitoring, clipboard pasting, and audio wavelength visualizers.
  * Fast terminal emulator using `foot`.
* **Modular Extensibility**: Additional pre-configured modules are ready for **Hyprland** (including custom greeters) and **GNOME**.

### Core Performance Tuning & Kernel

* **Linux CachyOS Kernel**: Custom optimized kernel utilizing `nix-cachyos-kernel` compiled with LTO (Link-Time Optimization) and tailored specifically for modern **x86_64-v4** instruction set architectures.
* **BPF Extensible Scheduler (`scx`)**: Utilizes the high-responsiveness `scx_bpfland` user-space scheduler for unparalleled desktop smoothness and latency handling under heavy loads.
* **Network Optimizations**: Employs **TCP BBR** congestion control, network queue management (`fq`), TCP Fast Open, and MTU probing for stable, low-latency connectivity.
* **Dynamic Hardware-Aware I/O Scheduling**:
  * **NVMe SSDs**: Bypasses queue scheduling entirely (`none`) to maximize raw parallel IOPS.
  * **SATA SSDs**: Implements the lightweight `mq-deadline` scheduler.
  * **HDDs**: Uses `bfq` (Budget Fair Queueing) for smooth multitasking and fair queue allocation.
* **Dynamic Interrupt Balancing**: Runs `irqbalance` to distribute hardware interrupts across CPU cores, improving power efficiency and real-time responsiveness.
* **Hardware Control**: Automatically configures the system `i2c` bus for direct display brightness/colour control via `ddcutil`.

### Interactive Shell Environment (Fish)

The configuration has transitioned fully to the **Fish Shell** as the interactive default, heavily polished for maximum CLI developer productivity:

* **Starship Prompt**: Premium, lightning-fast, and informative prompt system-wide.
* **Zoxide**: Smart directory jumping (automatically replacing `cd` with `z` and `zi`).
* **Direnv**: Zero-friction workspace loading that instantly loads `shell.nix` / `flake.nix` environments upon directory entry.
* **Productivity Plugins**:
  * `fishPlugins.autopair`: Automatically closes brackets, parenthesis, and quotes.
  * `fishPlugins.done`: Sends desktop notifications when long-running CLI tasks complete.
  * `fishPlugins.fzf-fish`: Interactive terminal navigation and search powered by `fzf`.
  * `fishPlugins.grc`: Generic colorizer for beautifying system command output.
  * `fishPlugins.foreign-env`: Safely source traditional POSIX/Bash scripts directly inside Fish.
* **Aesthetic Manuals**: Configured with beautifully styled, high-contrast colored manual pages.

### Software Management & CLI Arsenal

* **Modern CLI Suite**: High-efficiency developer utilities including **Yazi** (a blazing-fast terminal file manager), `eza` (modern visually-enhanced `ls` replacement), `bat`, `btop`, `fd`, `ripgrep`, `dust`, `ncdu`, and more.
* **Declarative Flatpaks**: Flatpak applications managed directly through Nix via the `nix-flatpak` module.
* **FHS Environments**: An FHS-compatible environment wrapper (`fhs-env.nix`) for running unpatched, pre-compiled Linux binaries out of the box.

### Services & Security

* **Specialised Virtualization**: Packaged inside a clean, toggleable boot profile/specialisation containing Docker, KVM/QEMU, virtual machine managers (`virt-manager`), Guest NSS, and spice USB redirection.
* **Local AI**: Local LLM model integrations.
* **Privacy-Focused DNS**: DNS-level ad-blocking and privacy utilizing local **AdGuard Home** and **NextDNS** clients.
* **Secure Authentication**: System-wide Polkit graphical authentication agent via `polkit-gnome`.

## Configuration Structure

```text
.nixos-config/
├── flake.nix             # Flake entry point (hosts, inputs, & system-wide builders)
├── flake.lock            # Lockfile managing pin points of nixpkgs & modules
├── LICENSE               # MIT License
├── README.md             # This guide
├── hosts/
│   ├── common.nix        # Common host attributes (Timezone, Locales)
│   └── laptop/
│       ├── configuration.nix      # Host-specific settings & Specialisations
│       ├── hardware-configuration.nix # Generated machine/partition layout
│       └── system-packages.nix    # Target channel settings & global apps
├── modules/
│   ├── base.nix          # Global modules imported on all systems
│   ├── boot/             # bootloader and plymouth splash modules
│   ├── appearance/       # Styling, custom fonts, SDDM, Niri/KDE profiles
│   ├── packages/         # Core groups (CLI tools, Internet, Media, Dev)
│   ├── services/         # AdGuard, NextDNS, virtualization, Flatpak wrappers
│   ├── shell/            # Shell configurations (Fish, Nu, Zsh)
│   └── system-tuning/    # Performance tuning, disks, swap, graphics, kernels
└── users/
    └── mrbot.nix         # User profile definition (groups, shell, password-hashes)
```

## Installation Guide

> [!WARNING]
> **For First-Time Installers:** This repository is tailored for a specific user and hardware setup. You **must** adapt it to your system before installation to avoid permission issues and boot failures.

### 1. Prepare Partitions

Create and mount your partitions according to your preferred filesystem layout:

* **Root (`/`)**: Mount at `/mnt` (e.g., ext4, btrfs, zfs)
* **Boot (`/boot`)**: Mount at `/mnt/boot` (e.g., fat32)
* **Home (`/home`)**: *(Optional)* Mount at `/mnt/home`

### 2. Generate Hardware Configuration

You need to generate a hardware profile specific to your machine.

> [!CAUTION]
> **Do not generate this in the root directory.** The flake expects the hardware configuration to be located inside your specific host directory (e.g., `hosts/laptop/`). If you use `--dir .` in the root of the workspace, you will need to manually move `hardware-configuration.nix` and delete the generated `configuration.nix`.

```bash
nixos-generate-config --show-hardware-config --root /mnt > hosts/laptop/hardware-configuration.nix
```

*Ensure you overwrite the existing `hardware-configuration.nix` in that folder.*

### 3. Personalize User Configuration

This setup currently hardcodes the `mrbot` user in several places and expects password hashes to be stored in external files rather than directly in the Nix code. Follow these steps to set up your own:

1. **Create your user profile:**
    Copy the existing user profile or create a new one based on the template below.

    ```bash
    cp users/mrbot.nix users/<your_username>.nix
    ```

2. **Configure your settings (`users/<your_username>.nix`):**
    * Update `users.users.<your_username>`.
    * Update `hashedPasswordFile` to point to `/etc/nixos/passwords/<your_username>`.
    * Customize your packages and preferred shell.

3. **Generate and Store Your Password:**
    Instead of storing the password directly in the nix file, this configuration relies on an external file. Create this file on your mounted system:

    ```bash
    mkdir -p /mnt/etc/nixos/passwords
    mkpasswd -m sha-512 > /mnt/etc/nixos/passwords/<your_username>
    ```

4. **Update Flake References:**
    Open `flake.nix` and update the base modules list (`baseModules`) to point to your new user file instead of `./users/mrbot.nix`.
    > [!NOTE]
    > If you decide to rename the `laptop` host directory to something else (e.g., `desktop`), you must also update all paths referencing `hosts/laptop/...` in your `flake.nix`.

5. **Replace Hardcoded Usernames:**
    You must replace `"mrbot"` with your `<your_username>` across the codebase. Specifically check:
    * `hosts/laptop/configuration.nix` (under `nix.settings.trusted-users`)
    * `modules/appearance/desktop-environment/hyprland.nix` (under `greetd` user)
    * `modules/services/virtualisation.nix` (under `libvirtd.members`)

    > [!WARNING]
    > If you skip this step, your new user will lack permissions to run Nix commands, and features like virtualization or the Hyprland greeter will fail to start.

<details>
<summary>User Template</summary>

```nix
{ pkgs, ... }:
{
  users.users.<username> = {
    isNormalUser = true;
    hashedPasswordFile = "/etc/nixos/passwords/<username>";
    extraGroups = [
      "wheel" "kvm" "video" "audio" "networkmanager"
    ];
    shell = pkgs.fish; # your preferred shell
    packages = with pkgs; [
      # your custom user packages
    ];
  };
}
```

</details>

### 4. Run the Installer

Choose your desired configuration profile from `flake.nix` (e.g., `minimal` or `fluid`).

> [!IMPORTANT]
> **Nix flakes ignore files that are not tracked by Git!** If you renamed or added new files (like your `<username>.nix` or the hardware config), you must stage them. Otherwise, the installer will throw a missing file error.
>
> ```bash
> git add .
> ```

Execute the installation:

```bash
nixos-install --flake .#minimal --root /mnt --verbose --show-trace
```

---

## Maintenance & System Operations

### Rebuilding and Switching

To update or apply changes to your system:

```bash
# Rebuild & switch using the minimal (Niri) profile
nixos-rebuild switch --flake .#minimal --verbose --show-trace

# Rebuild & switch using the fluid (KDE Plasma) profile
nixos-rebuild switch --flake .#fluid --verbose --show-trace
```

### Toggle Specialisations (Virtualization & Development)

The virtualization configuration is structured under a clean **Specialisation** block. It can be dynamically loaded at boot-time as a separate system entry or switched on the fly without rebooting:

```bash
# Apply and switch to the virtualization profile on the fly
sudo /run/current-system/specialisation/virtualisation/bin/switch
```

---

## Integrated Fish Shell Abbreviations

For maximum operational efficiency, several pre-defined dynamic abbreviations expand automatically as you type:

| Abbreviation | Expanded Command                                                                 | Purpose                                          |
| :----------- | :------------------------------------------------------------------------------- | :----------------------------------------------- |
| `ll`         | `eza -l --icons --git --group-directories-first`                                 | Visual directory listing with details            |
| `la`         | `eza -la --icons --git --group-directories-first`                                | Visual directory listing including hidden files  |
| `lt`         | `eza --tree --level=2 --icons --git ...`                                         | Two-level visual directory tree structure        |
| `edit`       | `sudo -e`                                                                        | Secure system file editing                       |
| `rfluid`     | `sudo nixos-rebuild boot --flake ~/.nixos-config#fluid --verbose --show-trace`   | Stage Fluid (KDE) rebuild for next boot          |
| `rminimal`   | `sudo nixos-rebuild boot --flake ~/.nixos-config#minimal --verbose --show-trace` | Stage Minimal (Niri) rebuild for next boot       |
| `ufluid`     | `sudo nixos-rebuild boot --flake ~/.nixos-config#fluid ... --upgrade`            | Perform system upgrade on Fluid profile          |
| `uminimal`   | `sudo nixos-rebuild boot --flake ~/.nixos-config#minimal ... --upgrade`          | Perform system upgrade on Minimal profile        |
| `nconf`      | `cd ~/.nixos-config`                                                             | Quick jump to NixOS configuration directory      |
| `nclean`     | `sudo nix-collect-garbage -d`                                                    | Clean old system generations and free disk space |
| `nlog`       | `git log --oneline -n 10`                                                        | Show recent Git history of configuration changes |

## Useful Documentation & Resources

* [NixOS Search](https://search.nixos.org) - Look up available Nix packages and configurations options.
* [MyNixOS](https://mynixos.com) - Browse beautifully formatted option structures and details.
* [NixOS Manual](https://nixos.org/manual/nixos) - Official guide to system operations.
* [NixOS Wiki](https://nixos.wiki) - Community wiki for troubleshooting and tips.
