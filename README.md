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

### Run

    nixos-install --flake .#minimal --root /mnt --verbose --show-trace

## Update

    nixos-rebuild switch --flake .#minimal --verbose --show-trace --upgrade
