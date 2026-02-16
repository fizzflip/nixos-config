# NixOS

My NixOS daily driver.
Mess? Kinda. Cleaning? Working on that.

## Installation

### Create partitions for

- `/` (root) and mount at `/mnt` [ext4/btrfs]
- `/boot` and mount at `/mnt/boot` [fat32]
- (Optional) `/home` and mount at `/mnt/home` [ext4/zfs]

### Obtain `hardware-configuration.nix`

- `nixos-generate-config --show-hardware-config --root /mnt > hardware-configuration.nix`

#### Alternative

- Run: `nixos-generate-config --dir .`
- Delete the generated `configuration.nix`
- Replace the existing `hardware-configuration.nix` to match your hardware.

### Create a `<username>.nix`

#### Template

```nix
{ pkgs, ... }:
{
  users.users.<username> = {
    isNormalUser = true;
    # use mkpasswd to obtain hash
    # remove this after first login
    # to change your password use passwd
    initialHashedPassword = "$6$YZ ... ";
    extraGroups = [
        "<group_name>" # "wheel" "kvm" etc.
    ];
    shell = pkgs.<shell_package_name>;
    packages = [
      pkgs.<package_name_1>
      pkgs.<package_name_2>
      ...
    ];
  };
}
```

**Alternative** \
Remove existing users in `./users` or edit them.

### Run Installer

    nixos-install --flake .#minimal --root /mnt --verbose --show-trace

## Update

    nixos-rebuild switch --flake .#minimal --verbose --show-trace --upgrade

## Documentation

- [search.nixos.org](https://search.nixos.org)
- [mynixos.com](https://mynixos.com)
- [NixOS Manual](https://nixos.org/manual/nixos)
- [NixOS Wiki](https://nixos.wiki)
