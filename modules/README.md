# Modules & Architecture Guide

This directory contains the modular NixOS subsystem definitions, declarative option contracts, hardware abstraction layers, and domain-isolated feature implementations.

---

## 1. Architectural Principles

The module tree follows strict domain separation:
1. **Universal Baseline (`modules/base.nix`)**: Imported across all machines to guarantee standard baseline invariants (nix daemon settings, system init primitives, user accounts, and core CLI utilities).
2. **Strict Domain Isolation**: Functionality is divided into 11 self-contained domain directories. Subsystems declare their own declarative options under the `my.*` namespace.
3. **Zero Inverted Imports**: Modules never reach into `../hosts` or `../users`. Host profiles compose modules purely through declarative options.
4. **Zero Global Overlays**: Package customizations are scoped locally or resolved upstream to prevent flake-wide evaluation cache invalidation.

```text
modules/
├── base.nix          # Global baseline imported across all systems
├── appearance/       # GTK styling, custom fonts, GDK Pixbuf loaders
├── boot/             # Lanzaboote Secure Boot UKIs, GRUB 2, and Plymouth
├── core/             # Options contract, locale, nix daemon, binary compatibility
├── desktop/          # Environments (Niri, KDE, GNOME), SDDM display manager, dux-shell
├── hardware/         # Intel Iris Xe & Ivy Bridge drivers, HDD tuning, peripheral rules
├── installer/        # Unattended automated installation ISO module
├── packages/         # ArtCraft, CLI utilities, development tools, internet, media
├── services/         # Virtualization, NextDNS, spectraNET, Android, printing, Podman
├── shell/            # Fish shell (with dynamic Starship prompt) and Nu
├── system-tuning/    # Performance, cgroups, disks, kernel, power, security, swap
└── users/            # Primary user and secondary profile (nini) definitions
```

---

## 2. Subsystem Deep-Dives

### Desktop Environments & Theming (`desktop/`, `appearance/`)
- **Niri (`minimal` profile)**: Dynamic scrolling Wayland compositor integrated with **`dux-shell`** and `wallust` dynamic theming.
  - PAM integration for `dankshell` authentication.
  - Nautilus file manager with `ffmpegthumbnailer` and GNOME Sushi previews.
  - `foot` terminal, `nomacs` image viewer, and `xwayland-satellite`.
- **KDE Plasma 6 (`fluid` profile)**: Modern, responsive Plasma 6 Wayland desktop session.
- **Display Manager**: `silentSDDM` styled with Catppuccin Mocha.
- **GTK & Theming**: Unified `dconf`, SVG (`librsvg`) and WebP loaders, schema bridging, and base icon themes.

### Boot & System Integrity (`boot/`)
- **Lanzaboote UEFI Secure Boot**: Active on physical workstations (`my.security.secureboot.enable = true`).
  - Generates signed Unified Kernel Images (UKIs) via systemd-boot.
  - TPM2 hardware measurements and boot validation via `sbctl`.
- **GRUB 2 (Fallback)**: Catppuccin Mocha themed bootloader with OS Prober when Secure Boot is disabled.
- **Plymouth**: Silent boot splash screen with flicker-free Fastboot transition.

### Performance & System Tuning (`system-tuning/`, `hardware/`)
- **Kernel & Scheduling**:
  - Upstream Linux Mainline kernel with `sched-ext` support.
  - BPF-based CPU scheduling powered by `scx_loader` with **`scx_bpfland`** as the default scheduler.
  - Kernel scheduler autogroups prioritizing interactive desktop sessions over batch jobs.
- **Responsiveness & Memory**:
  - Hardware-aware I/O scheduling: Kyber latency targeting on NVMe storage to eliminate compositor stutters during heavy compilations.
  - ZRAM compressed swap with Multi-Gen LRU (MGLRU) and EarlyOOM protection shielding user sessions.
  - Periodic SSD TRIM timers.
- **Hardware Acceleration & Power**:
  - Intel Tiger Lake Iris Xe graphics acceleration with early KMS, iHD VA-API, and OpenCL compute runtimes.
  - Non-adaptive `thermald` and PCI runtime power management.

### Security Hardening & Modern Secrets (`system-tuning/`, `services/`)
- **Firewall & Network Isolation**:
  - Native **`nftables`** backend with default drop policies.
  - Guest bridge isolation (`virbr0`, `waydroid0`) blocking access to private LANs.
  - Transparent loop-free NextDNS port 53 interception table.
  - Full 48-bit per-network MAC address randomization via `iwd`.
- **System Hardening**:
  - Active CPU microcode mitigations and Kernel Self Protection (KSPP memory sanitization).
  - Attack surface reduction: blacklisted legacy protocols, unmaintained filesystems, and unneeded peripheral buses.
  - Strict system umask (`077`), private home directories (`0700`), and systemd namespace sandboxing for core daemons.
- **Biometric Authentication**:
  - Gaze on-device facial authentication daemon (`services.gaze`), PAM integration (`sudo`, polkit, login), liveness detection, and GTK4/Libadwaita configuration GUI.
- **Modern Secrets Management (`oo7`)**:
  - Memory-safe Rust Secret Service provider (`services.oo7`) replacing legacy GNOME Keyring.
  - Per-application derived key isolation for Flatpaks and browsers via `oo7-portal` (`org.freedesktop.impl.portal.Secret`).
  - Automatic PAM session unlocking on SilentSDDM and console login via `pam_oo7`.
  - Non-swappable locked memory (`cap_ipc_lock=ep`), CLI tools (`pkgs.oo7`), and visual key management with Key Rack (`pkgs.key-rack`).

### Binary Compatibility & Execution (`core/compat.nix`)
- **Dynamic Binaries (`programs.nix-ld`)**: Seamless execution of unpatched standard Linux binaries with bundled glibc, FUSE 2/3, Wayland, X11, and Mesa libraries.
- **Seamless AppImages (`programs.appimage`)**: Automatic kernel `binfmt_misc` registration running AppImages natively via `appimage-run` without manual extraction or FUSE errors.
- **FUSE Permissions**: `programs.fuse.userAllowOther = true` permitting unprivileged multi-user mounts.
- **FHS Sandbox**: `steam-run` available for running complex foreign desktop software.

### Shell & Productivity (`shell/`, `packages/`)
- **Fish Shell**:
  - Two-line `starship` prompt matched to dynamic ANSI terminal palettes.
  - Plugins: `autopair`, `done`, `fzf-fish`, `grc`, and `foreign-env`.
  - Productivity aliases & abbreviations: `rfluid`, `rminimal`, `nfmt`, `ncheck`, `nclean`, `nlog`.
- **ArtCraft Creative & Office Suite**: Native apps (PdfCraft, WordCraft, DeckCraft, GridCraft, VectorCraft, PhotoCraft) via `github:Devitek/artcraft-nixos`.
- **Development & Tools**: Zed Editor, Antigravity IDE, Typst toolchain, Node.js, Bun, pnpm, Python (`uv`), Git, and GitHub CLI.
- **Browsers & Media**: Helium Browser, Mullvad Browser, Thunderbird, LocalSend, qBittorrent-enhanced, Metrolist KMP, mpv, and Foliate.

### Telemetry & Monitoring Services (`services/`)
- **spectraNET**: Real-time eBPF network telemetry daemon (`snetd`) tracking socket throughput, active processes, and IP reputation lists, paired with `snet` CLI and desktop GUI.
- **NextDNS**: Encrypted DNS-over-HTTPS resolver with local telemetry header sanitization.

---

## 3. Declarative Options Reference

All primary user-configurable switches are declared in the `my.*` option hierarchy:

| Option | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `my.user.name` | `string` | _required_ | Primary system username. |
| `my.user.shell` | `package` | `pkgs.fish` | Default user shell. |
| `my.desktop.environment` | `enum` | `"none"` | Desktop environment (`"niri"`, `"kde"`, `"gnome"`, or `"none"`). |
| `my.packages.minimal` | `bool` | `false` | Omits heavy IDEs, browsers, media apps, and ArtCraft when enabled. |
| `my.packages.artcraft.enable` | `bool` | `!my.packages.minimal` | Enable ArtCraft office and creative suite. |
| `my.packages.gaming.enable` | `bool` | `false` | Enable Kryoto Desktop, GameMode, Gamescope, and MangoHud. |
| `my.security.secureboot.enable` | `bool` | `false` | Enable Lanzaboote UEFI Secure Boot with signed UKIs. |
| `my.hardware.intelGpu.enable` | `bool` | `false` | Enable Intel Iris Xe GPU drivers, early KMS, and compute. |
| `my.hardware.ivyBridgeGpu.enable` | `bool` | `false` | Enable Intel Ivy Bridge Gen7 HD Graphics 2500 VA-API & Mesa tuning. |
| `my.hardware.rotationalHdd.enable` | `bool` | `false` | Tune mechanical HDD: BFQ, disable APM parking, ZRAM swap, dirty limits. |
| `my.hardware.powerManagement.enable` | `bool` | `false` | Enable laptop power management and SATA link power policies. |
| `my.services.sunshine.enable` | `bool` | `false` | Sunshine low-latency game/desktop streaming server. |
| `my.services.avahi.enable` | `bool` | `false` | Avahi mDNS/DNS-SD service daemon for network discovery. |
| `my.services.secrets.enable` | `bool` | `true` | Enable modern memory-safe oo7 Secret Service and Portal provider. |
| `my.services.nextdns.enable` | `bool` | `false` | Enable local NextDNS encrypted DNS resolver. |
| `my.services.gaze.enable` | `bool` | `false` | Enable Gaze facial authentication daemon and configuration GUI. |
| `my.services.spectranet.enable` | `bool` | `false` | Enable spectraNET eBPF real-time network monitor, CLI, and GUI. |
| `my.services.printing.enable` | `bool` | `false` | Enable CUPS printing and Avahi discovery. |
| `my.services.android.enable` | `bool` | `false` | Enable Waydroid and Android development tools. |
| `my.services.virtualisation.enable` | `bool` | `false` | Libvirt/KVM virtualization stack with QEMU and SWTPM. |
| `my.services.virtualisation.windows.enable` | `bool` | `false` | Windows guest VM support and virtio drivers. |
| `my.users.nini.enable` | `bool` | `false` | Enable secondary user profile `nini`. |

---

## 4. Code Quality & Verification Suite

Code quality and configuration safety are enforced through [`treefmt-nix`](file:///home/mrbot/.nixos-config/treefmt.nix) and automated test suites:

- **Formatting Pipeline**:
  - `nixfmt`: Canonical RFC 166 Nix formatting.
  - `statix`: Nix antipattern detection.
  - `deadnix`: Unused variable and dead binding pruning.
  - `shfmt`: Shell script formatting.

```bash
# Format the entire codebase
nix fmt              # or fish alias: nfmt

# Run dead code detection
nix run nixpkgs#deadnix -- .

# Evaluate and check all flake derivations and outputs
nix flake check      # or fish alias: ncheck

# Run full 10-suite automated verification script
bash scripts/verify.sh
```
