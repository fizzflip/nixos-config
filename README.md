# NixOS

> *My NixOS daily driver.* \
> *Mess? Kinda. Cleaning? Working on that.*

<p align="center">
  <img src="image.png" alt="Dux on Niri Desktop Setup" width="100%">
</p>

<p align="center">
  <a href="https://wallhaven.cc/w/6lqvql">Wallpaper</a> • <a href="https://wallhaven.cc/user/Trashbuff">Creator: Trashbuff</a>
</p>

<p align="center">
  <a href="https://nixos.org"><img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?logo=nixos&logoColor=white&color=5277C3" alt="NixOS"></a>
  <a href="https://kernel.org"><img src="https://img.shields.io/badge/Kernel-Linux%20Mainline-orange.svg?logo=linux&color=E25D25" alt="Kernel"></a>
  <a href="modules/README.md#boot--system-integrity"><img src="https://img.shields.io/badge/Secure%20Boot-Lanzaboote%20UKI-brightgreen.svg?logo=linux&color=2E7D32" alt="Secure Boot"></a>
  <a href="modules/README.md#code-quality--verification-suite"><img src="https://img.shields.io/badge/Format-treefmt--nix%20(RFC%20166)-blueviolet.svg?logo=nix&color=7B1FA2" alt="Formatter"></a>
  <a href="https://fishshell.com"><img src="https://img.shields.io/badge/Shell-Fish-brightgreen.svg?logo=fish-shell&logoColor=white&color=42A5F5" alt="Shell"></a>
  <a href="modules/README.md#desktop-environments--theming"><img src="https://img.shields.io/badge/Desktop-KDE%20%2F%20Niri-blueviolet.svg?logo=niri&color=8A2BE2" alt="Desktop"></a>
</p>

---

## Documentation

Detailed documentation is organized directory-wise:

| Directory | Scope |
| :--- | :--- |
| **[hosts/](hosts/README.md)** | Machine configurations (`fluid`, `minimal`, `machine`, `preview`), hardware targets, runtime specialisations (`lab`, `windows`, `gaming`), installation, and deployment commands. |
| **[modules/](modules/README.md)** | Modular architecture, subsystem deep-dives (performance, security, boot, desktop), declarative `my.*` options reference, and verification tooling. |

---

## Quick Start

```bash
# Rebuild and switch active profile
sudo nixos-rebuild switch --flake .#minimal    # Niri profile (alias: rminimal)
sudo nixos-rebuild switch --flake .#fluid      # KDE Plasma 6 (alias: rfluid)

# Format and test codebase
nix fmt                                        # Unified treefmt pipeline (alias: nfmt)
nix flake check                                # Flake checks across all hosts (alias: ncheck)
```
