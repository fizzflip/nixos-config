<div align="center">

# NixOS

_My NixOS daily driver._  
_Mess? Kinda. Cleaning? Working on that._

<br/>

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?logo=nixos&logoColor=white&color=5277C3)](https://nixos.org)
[![Secure Boot](https://img.shields.io/badge/Secure%20Boot-Lanzaboote%20UKI-brightgreen.svg?logo=linux&color=2E7D32)](modules/README.md#boot--system-integrity)
[![Shell](https://img.shields.io/badge/Shell-Fish-brightgreen.svg?logo=fish-shell&logoColor=white&color=42A5F5)](https://fishshell.com)
[![Desktop](https://img.shields.io/badge/Desktop-KDE%20%2F%20Niri-blueviolet.svg?logo=niri&color=8A2BE2)](modules/README.md#desktop-environments--theming)

<br/>

[![Dux on Niri](image.png)](image.png)

<sub><a href="https://wallhaven.cc/w/6lqvql">Wallpaper</a> • <a href="https://wallhaven.cc/user/Trashbuff">Creator: Trashbuff</a></sub>

</div>

---

### Documentation

<table>
<tr>
<td width="50%" valign="top">

#### [`hosts/`](hosts/README.md)

Machine targets, hardware abstractions, and deployment workflows.

- **`laptop`**: Primary workstation (`fluid` KDE Plasma 6 / `minimal` Niri with `dux-shell`).
- **`machine`**: Ivy Bridge Pentium desktop with rotational HDD wear protections.
- **`preview`**: Isolated local QEMU VM sandbox for testing configurations.
- **`installer`**: Automated unattended installation media (`installer-iso`).
- **Specialisations**: Runtime switching for `lab`, `windows`, and `gaming`.

</td>

<td width="50%" valign="top">

#### [`modules/`](modules/README.md)

Modular subsystem contracts, tuning deep-dives, and declarative options.

- **Subsystem Domains**: 11 isolated domains with universal `base.nix`.
- **System Tuning**: Mainline kernel, `scx_bpfland` eBPF scheduling, Kyber NVMe I/O.
- **Security & Secrets**: Lanzaboote UKI Secure Boot, `nftables`, Rust `oo7` secrets.
- **Binary Compatibility**: `programs.nix-ld`, AppImage `binfmt_misc`, and `steam-run`.
- **Declarative Options**: Complete reference table for the `my.*` namespace.

</td>
</tr>
</table>

---

### Quick Commands

```bash
# Rebuild and switch profiles
sudo nixos-rebuild switch --flake .#minimal    # Niri profile (alias: rminimal)
sudo nixos-rebuild switch --flake .#fluid      # KDE Plasma 6 (alias: rfluid)

# Codebase validation
nix fmt                                        # treefmt-nix pipeline (alias: nfmt)
nix flake check                                # Multi-host flake check (alias: ncheck)
```
