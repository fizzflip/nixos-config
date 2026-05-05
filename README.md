# NixOS

My NixOS daily driver. \
Mess? Kinda. Cleaning? Working on that.

## Features

This repository is structured into easily toggleable modules. Out of the box, it supports:

- **Desktop Environments**: Pre-configured profiles for **KDE Plasma** (`fluid` profile) and **Niri** (`minimal` profile). Additional modules are available for GNOME and Hyprland.
- **Performance Optimized**: Uses `nixos-unstable` and integrates `nix-cachyos-kernel` for improved system responsiveness and hardware support.
- **Custom Boot & Login**: Clean boot experience using `systemd-boot` with Plymouth, and a customized Silent SDDM (using Helium themes).
- **Shell Environments**: Modules for both **Zsh** and **Nushell** (`nu`).
- **Software Management**:
  - Declarative Flatpaks managed directly through Nix via the `nix-flatpak` module.
  - FHS environments (`fhs-env.nix`) for running unpatched pre-compiled binaries seamlessly.
- **Services & Capabilities**:
  - Virtualization (KVM/QEMU) and Android development environments.
  - Local LLM integrations.
  - DNS ad-blocking and privacy via NextDNS and AdGuard Home.
- **ISO Generation**: Capable of building a custom live bootable ISO directly from the flake.

---

## Installation Guide

> [!WARNING]
> **For First-Time Installers:** This repository is tailored for a specific user and hardware setup. You **must** adapt it to your system before installation to avoid permission issues and boot failures.

### 1. Prepare Partitions

Create and mount your partitions according to your preferred filesystem layout:

- **Root (`/`)**: Mount at `/mnt` (e.g., ext4, btrfs)
- **Boot (`/boot`)**: Mount at `/mnt/boot` (e.g., fat32)
- **Home (`/home`)**: _(Optional)_ Mount at `/mnt/home` (e.g., ext4, zfs)

### 2. Generate Hardware Configuration

You need to generate a hardware profile specific to your machine.

> [!CAUTION]
> **Do not generate this in the root directory.** The flake expects the hardware configuration to be located inside your specific host directory (e.g., `hosts/laptop/`). If you use `--dir .`, you will need to manually move `hardware-configuration.nix` and delete the generated `configuration.nix`.

```bash
nixos-generate-config --show-hardware-config --root /mnt > hosts/laptop/hardware-configuration.nix
```

_Ensure you overwrite the existing `hardware-configuration.nix` in that folder._

### 3. Personalize User Configuration

This setup currently hardcodes the `mrbot` user in several places and expects password hashes to be stored in external files rather than directly in the Nix code. Follow these steps to set up your own:

1. **Create your user profile:**
   Copy the existing user profile or create a new one based on the template below.

   ```bash
   cp users/mrbot.nix users/<your_username>.nix
   ```

2. **Configure your settings (`users/<your_username>.nix`):**
   - Update `users.users.<your_username>`.
   - Update `hashedPasswordFile` to point to `/etc/nixos/passwords/<your_username>`.
   - Customize your packages and preferred shell.

3. **Generate and Store Your Password:**
   Instead of storing the password directly in the nix file, this configuration relies on an external file. Create this file on your mounted system:

   ```bash
   mkdir -p /mnt/etc/nixos/passwords
   mkpasswd -m sha-512 > /mnt/etc/nixos/passwords/<your_username>
   ```

4. **Update Flake References:**
   Open `flake.nix` and update the base modules list to point to your new user file instead of `./users/mrbot.nix`.

   > [!NOTE]
   > If you decide to rename the `laptop` host directory to something else (e.g., `desktop`), you must also update all paths referencing `hosts/laptop/...` in your `flake.nix`.

5. **Replace Hardcoded Usernames:**
   You must replace `"mrbot"` with your `<your_username>` across the codebase. Specifically check:
   - `hosts/laptop/configuration.nix` (under `nix.settings.trusted-users`)
   - `modules/appearance/desktop-environment/hyprland.nix` (under `greetd` user)
   - `modules/services/virtualisation.nix` (under `libvirtd.members`)

   > [!WARNING]
   > If you skip this step, your new user will lack permissions to run Nix commands, and features like virtualization or the Hyprland greeter will fail to start.

<details>
<summary>Click here to view a clean User Template</summary>

```nix
{ pkgs, ... }:
{
  users.users.<username> = {
    isNormalUser = true;
    hashedPasswordFile = "/etc/nixos/passwords/<username>";
    extraGroups = [
        "wheel" "kvm" "video" "audio"
    ];
    shell = pkgs.zsh; # change to your preferred shell
    packages = with pkgs; [
      # your packages
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

## Maintenance

To update or apply changes to your system:

```bash
nixos-rebuild switch --flake .#minimal --verbose --show-trace --upgrade
```

## Documentation

- [NixOS Search](https://search.nixos.org)
- [MyNixOS](https://mynixos.com)
- [NixOS Manual](https://nixos.org/manual/nixos)
- [NixOS Wiki](https://nixos.wiki)
