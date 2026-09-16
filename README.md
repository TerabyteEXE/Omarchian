# Omarchian

**Core:** Debian

## Why?

Debian is probably the easiest Linux distro for beginners to learn, but it's also so plain-looking that a lot of people skip straight to something like Arch for the customizability. It's only recently that we've seen people choosing a distro for its visual design and feel, since most Linux users in the pre-mainstream days were power users who already knew how to configure exactly what they wanted. Now, with a wave of new Linux users who want something that looks great out of the box — without spending hours configuring it just to get it working — we're seeing feature-rich distros like Omarchy surge in popularity compared to the older, plainer, slower distros we used to rely on.

As amazing as the project is, Omarchy lacks the simplicity that a lot of users are looking for if they want more than just a preconfigured system. Most users won't mind that, but a fair number will want something familiar and comfortable to work in. Customizing Arch is a bit like performing brain surgery — it's easy to break something, mess it up, or get it wrong, and it takes a long time to learn. Debian and other distros like Fedora make this much easier: even though they're plain, most users won't brick their system trying to configure things the way they like.

That's the gap I think **Omarchian** fills. The name is a mix of "Omarchy" and "Debian." It's a Debian-based distro that isn't meant to chase bleeding-edge releases — it's meant to be old and dependable. Sometimes we need a break from AI and agentic workflows, and realistically, most people aren't going to be paying premium prices for tools like Claude Code.

Omarchy is, visually, the best-looking Linux distro out there — no argument there. Hyprland is genuinely great too. But that's also where a lot of users get lost: even though Omarchy is described as "opinionated," what people actually like is the GUI, not the preloaded apps and libraries that most of them will never use. Omarchy is really built for developers and programmers, and even if you don't need all its features, you end up with a lot of bloat you have to strip out.

So why not just start with a lightweight, beautiful-looking OS instead? Omarchian aims to bring the visuals and keyboard-driven workflow of Omarchy to Debian — without dragging along all the Arch-specific setup and preinstalled software nobody asked for. Forget layering AI on top of everything; let's just make the underlying problem simpler to begin with.

Omarchy is a great choice for a lot of people, but others would honestly rather stick with something like Ubuntu. Before Omarchy, there was **Omakub** — a single command script that would configure a fresh Ubuntu install to look great and come with a solid set of apps. As DHH has said, it was the original idea and inspiration behind Omarchy. Since then, the project has been archived, though a few forks have kept it updated. But why stop at Ubuntu? Why not go further back the chain to Ubuntu's own base — Debian?

Debian is honestly one of the best distros out there for the average user. Why do Linux Mint and Ubuntu stay popular despite looking plain and dated? Because they offer the simplicity and steadiness that most users are already used to. Most people are coming from Windows or macOS, where the mouse is central to how they work. I'm not a big fan of using a mouse myself, but realistically, most people don't need to *learn* how to use a Linux distro from scratch. Something like Hyprland could genuinely boost productivity, but it's not realistic for most people — and sadly, we're not going to see Omarchy show up in most software repositories any time soon. Linux Mint, though, or something equally approachable, we might.

So: **Omarchian** is a single configuration script — from good old GitHub, by TerabyteEXE — that turns a fresh Debian install into a visually striking, keyboard-driven system. Want to use your mouse? That's fine. But the keyboard is your main driver. It's all about keeping the user comfortable while making them feel like they're actually in control of their system.

That's why I think Omarchian is worth using.

## How?

Simple: copy and paste one terminal command to install it — just like Omakub did for Ubuntu. Hopefully, we end up with something people can use the way they use Omarchy, except this time it's Omarchian.

### Install

On a fresh **Debian 13 (trixie)** install (sid/forky also work):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/TerabyteEXE/Omarchian/main/boot.sh)
```

Or, cloning it yourself:

```bash
git clone https://github.com/TerabyteEXE/Omarchian.git ~/.local/share/omarchian
cd ~/.local/share/omarchian
./install.sh
```

The installer is read-only about your system except where it needs to act:
it enables `trixie-backports` (that's where Hyprland lives on Debian 13),
installs the Hyprland/Wayland stack, symlinks this repo's `config/` into
`~/.config`, and backs up anything already there rather than overwriting it.
Log out and pick **Hyprland** at your login manager when it's done.

### Repo layout

```
omarchian/
├── install.sh              # entry point — sources each stage below
├── boot.sh                 # one-line curl bootstrapper
├── install/
│   ├── helpers/all.sh      # logging, package-install, symlink helpers
│   ├── preflight/all.sh    # OS check, backports, sudo
│   ├── packaging/all.sh    # apt package list
│   ├── config/all.sh       # symlinks config/ into ~/.config
│   └── post-install/all.sh # services, session file, wrap-up
├── config/                 # the actual dotfiles, symlinked at install
│   ├── hypr/hyprland.conf
│   ├── waybar/
│   ├── fuzzel/              # launcher (Debian's answer to Omarchy's walker)
│   ├── mako/
│   └── alacritty/
└── themes/
    └── omarchian-dark/      # default palette; add more the same way
```

Everything under `install/` is a small, single-purpose script — the idea
is you can read the whole install top to bottom in a couple of minutes,
the same way you can with Omarchy's.

### Status

This is a v0.1 starting point, not a finished distro. What's real right now:

- Working `install.sh` that installs Hyprland + a full Wayland session from Debian's own repos (trixie-backports), no AUR or source builds
- Keybindings, Waybar, launcher (`fuzzel`), notifications (`mako`), and terminal theme all wired up and symlinked from the repo
- One default theme (`omarchian-dark`)

What's not built yet:

- `omarchy-theme-set`-style theme switching (right now it's a manual symlink)
- A TUI/menu like Omarchy's `omarchy-menu`
- NVIDIA-specific handling
- Testing beyond a handful of manual runs — expect rough edges on real hardware

Worth knowing: a similar idea already exists — [ohmydebn](https://github.com/dougburks/ohmydebn) takes Debian + Cinnamon in an Omarchy-inspired direction. Different desktop (Cinnamon vs. Hyprland here), so no overlap, but worth a look for prior art.

## Roadmap

The main goal right now is getting the GUI looking good. Eventually, I want to get it fully free and build a solid, sustainable system for keeping it up to date for the long haul. After that, I'd like to polish everything so it feels genuinely well-made and complete — cooked to perfection, not just functional.

If the project goes well beyond that point, I'll look into turning it into a full, standalone distro and getting that properly mastered. At that stage, hopefully other maintainers can help take it even further — a distro that grew out of Omarchy's shadow but stands on its own.
