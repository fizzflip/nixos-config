<table>
<tr>
<td width="50%" valign="top">

<div align="center">

#### [`hosts/`](hosts/README.md)

Machine profiles and deployment targets.

</div>

- **`laptop`**: Tiger Lake i5 with Iris Xe. Runs `minimal` (Niri + `dux-shell`) or `fluid` (KDE Plasma 6).
- **`machine`**: Ivy Bridge Pentium server with ext4 and rotational HDD wear protections.
- **`preview`**: Local QEMU VM targets (`preview`, `preview-full`) for testing changes before hardware rebuilds.
- **`installer`**: Generates a bootable unattended installation ISO (`installer-iso`).
- **Specialisations**: On-the-fly switching for `lab` (VMs/Waydroid), `windows` (direct NVMe passthrough), and `gaming` (CachyOS BORE kernel).

</td>

<td width="50%" valign="top">

<div align="center">

#### [`modules/`](modules/README.md)

Subsystem implementation and options.

</div>

- **Subsystem Domains**: 11 domain folders tied together by `base.nix`.
- **System Tuning**: Mainline Linux kernel, `scx_bpfland` eBPF scheduling, Kyber NVMe I/O, and tmpfs RAM builds with zRAM.
- **Security & Secrets**: Lanzaboote UKI Secure Boot, strict `nftables` rules, and PAM-unlocked secrets.
- **Binary Compatibility**: `programs.nix-ld`, AppImage `binfmt_misc`, and `steam-run`.
- **Declarative Options**: Reference table for every toggle in the `my.*` namespace.

</td>
</tr>
</table>
