# Modules

NixOS subsystem definitions, hardware abstraction layers, and declarative option contracts.

## 1. Principles

1. **Shared Baseline (`modules/base.nix`)**: Imported by every host configuration. Enforces common invariants: locales, nix daemon settings, basic CLI packages, user definitions, and session variables.
2. **Domain Separation**: Configuration is split across 11 directories by role. Each subsystem exposes toggles under the `my.*` namespace.
3. **No Upstream Leaks**: Modules do not import from `hosts/` or hardcode hostnames. Hosts compose functionality by enabling or disabling `my.*` flags.
4. **No Global Overlays**: Package modifications are either passed as inputs or resolved locally to prevent rebuilding the entire world on every flake update.

```text
modules/
├── base.nix          # Global baseline imported across all systems
├── appearance/       # Fonts, GTK themes, and GDK Pixbuf loaders
├── boot/             # Lanzaboote Secure Boot UKIs, GRUB, and Plymouth
├── core/             # Nix daemon, binary compatibility, locale, and options
├── desktop/          # Niri, KDE Plasma 6, dux-shell, and SDDM
├── hardware/         # Intel Iris Xe and Ivy Bridge drivers, HDD tuning
├── installer/        # Automated installation ISO configuration
├── packages/         # CLI tools, development runtimes, browsers, media
├── services/         # spectraNET, NextDNS, virtualization, printing, Podman
├── shell/            # Fish shell with Starship and Nu shell
├── system-tuning/    # eBPF scheduler, memory, tmpfs, swap, cgroups
└── users/            # Primary user and secondary profile definitions
```

## 2. Subsystem Notes

### Desktop Environments & Theming (`desktop/`, `appearance/`)

- **Niri (`minimal` profile)**: Dynamic scrolling Wayland compositor configured with `dux-shell` and `wallust` dynamic color schemes.
  - PAM integration for `dankshell` authentication.
  - File management via Nautilus with `ffmpegthumbnailer` and GNOME Sushi previews.
  - Core utilities: `foot` terminal, `nomacs` image viewer, and `xwayland-satellite`.
- **KDE Plasma 6 (`fluid` profile)**: Full-featured Plasma 6 desktop running on Wayland.
- **Display Manager**: `silentSDDM` themed with Catppuccin Mocha.
- **GTK Configuration**: Shared `dconf` defaults, SVG (`librsvg`) and WebP loaders, and standard base icon sets.

### Boot & System Integrity (`boot/`)

- **Lanzaboote Secure Boot**: Active on physical workstations (`my.security.secureboot.enable = true`).
  - Assembles signed Unified Kernel Images (UKIs) for systemd-boot.
  - Monitored and enrolled through `sbctl`.
- **GRUB (Fallback)**: Catppuccin Mocha themed bootloader used when Secure Boot is disabled.
- **Plymouth**: Silent UEFI ACPI BGRT boot splash screen with flicker-free transition into SDDM.

### Performance & Storage Tuning (`system-tuning/`, `hardware/`)

- **Kernel & CPU Scheduling**:
  - Mainline Linux kernel with `sched-ext` userland scheduler support.
  - Default CPU scheduling handled by `scx_loader` running `scx_bpfland`.
  - Kernel scheduler autogrouping enabled to protect interactive desktop sessions from compile starvation.
- **Memory & Swap**:
  - 7.5 GiB physical RAM backed by 7.5 GiB zRAM swap running `zstd` with `vm.swappiness = 180`.
  - Multi-Gen LRU (MGLRU) enabled with 1000ms minimum time-to-live to prevent page thrashing.
  - EarlyOOM configured to kill runaway background processes while protecting desktop compositors and audio streams.
- **Disk Endurance & Builds**:
  - `/tmp` is mounted on `tmpfs` with `boot.tmp.tmpfsSize = "100%"`. Intermediate compiler objects and unpack files stay in memory and compress into zRAM instead of writing to NVMe NAND cells.
  - `systemd.services.nix-daemon.environment.TMPDIR` points to `/tmp`, routing builds to RAM by default. For massive packages requiring >10 GB of scratch space, `--option build-dir /var/tmp` redirects builds back to SSD storage.
  - Kyber I/O scheduler configured for NVMe with a 2ms read latency target.
  - Systemd journal throttled to a 50MB runtime memory limit with burst rate limits to stop idle disk churn.

### Security Hardening (`system-tuning/`, `services/`)

- **Firewall**: Native `nftables` backend with default-drop incoming policy and bridge isolation for virtual networks (`virbr0`, `waydroid0`).
- **Network Privacy**: Full 48-bit MAC address randomization on every connection via `iwd`.
- **System Isolation**: Kernel Self Protection (KSPP memory sanitization), default `077` umask, `0700` home directories, and blacklisted legacy protocols.
- **Authentication**: Gaze on-device facial authentication daemon (`services.gaze`) integrated with PAM for `sudo`, Polkit, and login.
- **Secrets Management**: GNOME Keyring with PAM session unlocking on login and SDDM.

### Binary Compatibility (`core/compat.nix`)

- **Standard Linux Binaries (`programs.nix-ld`)**: Runs unpatched dynamically linked Linux executables with standard glibc and graphics libraries.
- **AppImages (`programs.appimage`)**: Kernel `binfmt_misc` registration routes AppImages directly to `appimage-run`.
- **FHS Chroots**: `steam-run` available for foreign applications with complex directory assumptions.

### Shell, Packages & Telemetry (`shell/`, `packages/`, `services/`)

- **Fish Shell**: Two-line `starship` prompt with terminal palette integration. Custom aliases: `rfluid`, `rminimal`, `nfmt`, `ncheck`, `nclean`, `nlog`.
- **System Monitoring**: Rockbottom (`rb` anomaly analyzer), `btop`, `htop`, `fastfetch`, and `powertop`.
- **Network Telemetry**: spectraNET eBPF real-time monitor (`snetd`) tracking per-socket traffic and IP reputation, paired with `snet` CLI and GUI.
- **Desktop Applications**: ArtCraft suite, Zed, Antigravity IDE, Helium Browser, Mullvad Browser, Metrolist KMP, OpenTubeX, mpv, and Foliate.

## 3. Options Reference

Primary user switches declared in `modules/core/options.nix`:

| Option                                      | Type      | Default                | Description                                                  |
| :------------------------------------------ | :-------- | :--------------------- | :----------------------------------------------------------- |
| `my.user.name`                              | `string`  | _required_             | Primary system username.                                     |
| `my.user.shell`                             | `package` | `pkgs.fish`            | Default user shell.                                          |
| `my.desktop.environment`                    | `enum`    | `"none"`               | Desktop session (`"niri"`, `"kde"`, `"gnome"`, or `"none"`). |
| `my.packages.minimal`                       | `bool`    | `false`                | Omits heavy IDEs, browsers, media apps, and ArtCraft.        |
| `my.packages.artcraft.enable`               | `bool`    | `!my.packages.minimal` | ArtCraft office and creative suite.                          |
| `my.packages.gaming.enable`                 | `bool`    | `false`                | Kryoto Desktop, GameMode, Gamescope, and MangoHud.           |
| `my.security.secureboot.enable`             | `bool`    | `false`                | Lanzaboote UEFI Secure Boot with signed UKIs.                |
| `my.hardware.intelGpu.enable`               | `bool`    | `false`                | Intel Iris Xe graphics, early KMS, and compute runtimes.     |
| `my.hardware.ivyBridgeGpu.enable`           | `bool`    | `false`                | Intel Ivy Bridge Gen7 HD 2500 VA-API and Mesa drivers.       |
| `my.hardware.rotationalHdd.enable`          | `bool`    | `false`                | Mechanical HDD wear tuning: BFQ, no APM parking, zRAM swap.  |
| `my.hardware.powerManagement.enable`        | `bool`    | `false`                | Laptop power profiles and SATA link power policies.          |
| `my.services.sunshine.enable`               | `bool`    | `false`                | Sunshine game and desktop streaming server.                  |
| `my.services.avahi.enable`                  | `bool`    | `false`                | Avahi mDNS service daemon for local network discovery.       |
| `my.services.secrets.enable`                | `bool`    | `true`                 | System secrets and Keyring provider.                         |
| `my.services.nextdns.enable`                | `bool`    | `false`                | Encrypted NextDNS resolver with telemetry filtering.         |
| `my.services.gaze.enable`                   | `bool`    | `false`                | Gaze biometric facial authentication daemon and UI.          |
| `my.services.spectranet.enable`             | `bool`    | `false`                | spectraNET eBPF network monitor, CLI, and GUI.               |
| `my.services.printing.enable`               | `bool`    | `false`                | CUPS print daemon and Avahi printer discovery.               |
| `my.services.android.enable`                | `bool`    | `false`                | Waydroid container runtime and Android tools.                |
| `my.services.virtualisation.enable`         | `bool`    | `false`                | Libvirt/KVM virtualization stack with QEMU and SWTPM.        |
| `my.services.virtualisation.windows.enable` | `bool`    | `false`                | Windows guest VM configuration and VirtIO drivers.           |
| `my.users.nini.enable`                      | `bool`    | `false`                | Secondary user profile `nini`.                               |

## 4. Code Quality & Testing

```bash
# Format codebase (nixfmt, statix, deadnix, shfmt)
nix fmt

# Evaluate and check all flake outputs
nix flake check

# Run automated architectural verification suite
bash scripts/verify.sh
```
