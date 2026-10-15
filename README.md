# nixiety

[![check](https://github.com/jeanres/nixiety/actions/workflows/check.yml/badge.svg)](https://github.com/jeanres/nixiety/actions/workflows/check.yml)

macOS setup for `Jeanres-MacBook-Pro`, managed with [nix-darwin](https://github.com/nix-darwin/nix-darwin), [Home Manager](https://github.com/nix-community/home-manager) and [Lix](https://lix.systems).

## Getting started

On a fresh Mac:

```sh
git clone https://github.com/jeanres/nixiety.git ~/.nixiety
cd ~/.nixiety
make install
```

`make install` skips anything already present and:

1. Installs the Xcode Command Line Tools (then stops; run `make install` again once they finish)
2. Installs Lix
3. Installs Homebrew (nix-darwin manages casks but doesn't install Homebrew itself)
4. Runs the first `darwin-rebuild switch`

After that, sign in to the App Store so Mac App Store apps can install.

## Day to day

| Command        | What it does                                   |
| -------------- | ---------------------------------------------- |
| `make switch`  | Build and activate the config                  |
| `make build`   | Build without activating                       |
| `make update`  | Update flake inputs, then switch               |
| `make check`   | Run `nix flake check`                          |
| `make gc`      | Delete generations older than 30 days          |
| `nix fmt`      | Format every `.nix` file with nixfmt           |
| `nh darwin switch` | Same as `make switch`, from any directory  |
| `make`         | List targets                                   |

`make build` and `make switch` use [nh](https://github.com/nix-community/nh), which shows build progress and a diff of changed packages; before nh is installed they fall back to `darwin-rebuild`.

CI (`.github/workflows/check.yml`) runs on every push and PR to `main`: `nix fmt -- --ci`, `nix flake check`, and a full build of the system on an Apple Silicon runner. Run `nix fmt` before pushing.

## Layout

```
flake.nix             entry point: inputs and the darwin configuration
Makefile              install / switch / update shortcuts
hosts/
└── macbook-pro/      Nix (Lix), GC, store optimisation, caps lock to escape
modules/
├── homebrew/         Homebrew casks and Mac App Store apps
└── macos/            macOS settings (Dock, Spaces, keyboard, Finder, ...)
home/                 Home Manager, laid out like its own modules
├── default.nix       imports the three folders below
├── programs/         programs.* (one file per program)
│                     ├── default.nix        imports every program
│                     ├── aerospace.nix      tiling window manager, workspaces, keybindings
│                     ├── kitty.nix          terminal
│                     ├── zsh.nix            shell, plugins, Homebrew on PATH
│                     ├── starship.nix       prompt
│                     ├── tmux.nix           multiplexer (plugins via TPM)
│                     ├── neovim/            editor: default.nix + lua/config/*.lua
│                     ├── nh.nix             nicer darwin-rebuild (used by make)
│                     ├── posting.nix        TUI for HTTP APIs
│                     ├── git.nix            identity, defaults, signing, global ignore
│                     ├── delta.nix          git diff pager
│                     ├── lazygit.nix        git TUI
│                     ├── eza.nix            ls replacement
│                     ├── bat.nix            cat with highlighting
│                     ├── fd.nix             find replacement
│                     ├── ripgrep.nix        grep replacement
│                     ├── fzf.nix            fuzzy finder
│                     ├── jq.nix             JSON tool
│                     ├── zoxide.nix         cd replacement
│                     ├── direnv.nix         per-directory environments (nix-direnv)
│                     └── claude-code.nix    Claude Code
├── services/         services.*
│                     └── jankyborders.nix   window borders
└── targets/darwin/   macOS-only: desktop stacks, screenshots folder
scripts/              helper scripts used by the config
└── safari-tab.applescript   go to an open Safari tab or open a new one
```

To add a program: create `home/programs/<name>.nix` and add it to `home/programs/default.nix` (a background service goes in `home/services/` the same way).

To add a GUI app: add its cask to `modules/homebrew/default.nix` (or its App Store ID to `masApps`).

## Shell

- `ls`, `ll`, `la`, `lla`, `lt` → eza
- `cd` → zoxide (`cd proj` jumps to a frequently used dir, `cdi` picks interactively)
- zsh has autosuggestions (→ to accept) and syntax highlighting
- Homebrew is on `PATH` via `~/.zprofile`
- direnv uses nix-direnv, so `use flake` environments are cached
- `posting` is a TUI for HTTP APIs (`alt-shift-a`); `posting --collection <dir>` opens a project's saved requests

## kitty

| Action | How |
| --- | --- |
| Copy | select with the mouse (copies automatically), or `Cmd C` |
| Paste | right click, or `Cmd V` |
| Select inside tmux/Neovim | hold `Shift` while dragging |
| Copy a URL, path or hash | `Cmd Shift Space`, then type its letter label |
| Keyboard selection | tmux copy mode (`prefix [`) |
| Open a link | `Cmd` click |

Font: Atkinson Hyperlegible Mono, Medium, 15pt (designed for low vision; icons come from kitty's built-in Nerd Font symbols).

Cursor: a peach block that fades in and out and leaves a trail when it jumps; lavender selection; slightly taller lines; padding around the edges.

## tmux

Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm), not Nix. On the first start tmux clones TPM into `~/.config/tmux/plugins/` and installs the plugins (Catppuccin Mocha). Add a plugin with `set -g @plugin '...'` in `home/programs/tmux.nix`, run `make switch`, then press `prefix I` in tmux.

| Key | Action |
| --- | --- |
| `C-b` | prefix |
| `prefix \|` / `prefix -` | split side by side / top and bottom (current dir) |
| `prefix h/j/k/l` | move between panes |
| `prefix c` | new window (current dir) |
| `prefix [` | copy mode: `v` select, `C-v` block, `y` copy to the macOS clipboard |
| `prefix p` | paste |
| `prefix r` | reload config |
| `prefix I` / `prefix U` | install / update plugins |

Windows start at 1, the mouse works, copy mode uses vi keys, and Esc has no delay.

## Neovim

Config lives in `home/programs/neovim/` (`lua/config/*.lua`); plugins and language servers come from Nix. Tools a project provides through direnv (node, eslint, prettier, biome) take precedence over the Nix fallbacks. Files are formatted on save: biome if the project has a `biome.json`, otherwise prettierd; nixfmt for Nix, stylua for Lua.

The cursor is always a block (blinking in insert mode). The current line and its number are highlighted.

nixd reads this repo's flake, so editing it completes nix-darwin and Home Manager options as well as packages.

Leader is `space`.

| Key                          | Action                                   |
| ---------------------------- | ---------------------------------------- |
| **Find**                     |                                          |
| `<leader><space>`            | Find files                               |
| `<leader>/`                  | Search project (live grep)               |
| `<leader>ff` / `<leader>fg`  | Files / grep                             |
| `<leader>fw`                 | Grep word under cursor                   |
| `<leader>fb`                 | Buffers                                  |
| `<leader>fr`                 | Recent files                             |
| `<leader>fs`                 | Symbols in file                          |
| `<leader>fd`                 | Diagnostics                              |
| `<leader>fh`                 | Help                                     |
| `-`                          | Open parent directory (oil)              |
| **Code** (when an LSP is attached) |                                    |
| `gd` / `gD` / `gy`           | Definition / declaration / type definition |
| `K`                          | Hover docs                               |
| `grr` / `gri`                | References / implementation (built in)   |
| `<leader>fR`                 | References in Telescope                  |
| `<leader>ca` (or `gra`)      | Code action                              |
| `<leader>cr` (or `grn`)      | Rename                                   |
| `<leader>cf`                 | Format                                   |
| `<leader>ce`                 | ESLint fix all                           |
| `<leader>cd`                 | Line diagnostics                         |
| `]d` / `[d`                  | Next / previous diagnostic (built in)    |
| **Completion**               |                                          |
| `<C-space>`                  | Open menu                                |
| `<C-n>` / `<C-p>`            | Next / previous item                     |
| `<C-y>`                      | Accept                                   |
| **Git**                      |                                          |
| `<leader>gg`                 | Lazygit                                  |
| `]h` / `[h`                  | Next / previous hunk                     |
| `<leader>gp`                 | Preview hunk                             |
| `<leader>gr`                 | Reset hunk                               |
| `<leader>gb`                 | Blame line                               |
| **Diagnostics panel** (trouble) |                                       |
| `<leader>xx`                 | Project diagnostics                      |
| `<leader>xb`                 | Buffer diagnostics                       |
| `<leader>xs`                 | Symbols                                  |
| `<leader>xr`                 | LSP references / definitions             |
| `<leader>xq`                 | Quickfix list                            |
| **Sessions** (saved per directory on exit) |                            |
| `<leader>ss`                 | Restore session for this directory       |
| `<leader>sl`                 | Restore last session                     |
| `<leader>sd`                 | Don't save this session                  |
| **Editing**                  |                                          |
| `sa` / `sd` / `sr`           | Add / delete / replace surrounding       |
| `J` / `K` (visual)           | Move selection down / up                 |
| **Windows and buffers**      |                                          |
| `<C-h/j/k/l>`                | Move between splits                      |
| `<S-h>` / `<S-l>`            | Previous / next buffer                   |
| `<leader>bd`                 | Delete buffer                            |
| `<leader>w` / `<leader>q`    | Save / quit                              |
| `<Esc>`                      | Clear search highlight                   |

## Git

Set in `home/programs/git.nix`.

- Commits and tags are signed with `~/.ssh/id_rsa.pub`. Add that key on GitHub as a **Signing key** (Settings → SSH and GPG keys) so commits show as Verified; `git log --show-signature` checks them locally.
- Defaults: `main` branch, `pull --rebase`, auto-stash on rebase, `push` sets upstream automatically, prune on fetch, `rerere`, histogram diffs, zdiff3 conflicts, branches sorted by recent commit
- Aliases: `st`, `co`, `sw`, `br`, `ci`, `amend`, `undo` (soft reset last commit), `lg` (graph), `last`
- Global ignore: `.DS_Store`, `.direnv/`, `*.swp`, `*~`
- Diffs go through delta; `lazygit` (or `<leader>gg` in Neovim) for a TUI

## macOS settings

Set in `modules/macos` (nix-darwin writes them one key at a time, so nothing else in those domains is touched). Some need a log out and back in.

- Spaces: "Displays have separate Spaces" off, and Mission Control groups windows by app (both recommended by AeroSpace)
- Dock auto-hides
- Fast key repeat; holding a key repeats it instead of showing the accent popup
- Tap to click
- Finder shows hidden files, all extensions and the path bar
- Screenshots go to `~/Pictures/Screenshots`
- Desktop uses Stacks (set from `home/targets/darwin`)

Avoid Home Manager's `targets.darwin.defaults` for these: it imports a whole domain at once, which wipes any keys you didn't list (e.g. pinned Dock apps).

## Theme

Catppuccin Mocha, set by hand per app:

- kitty: built-in `Catppuccin-Mocha` theme, no title bar, no tab bar
- tmux: `catppuccin/tmux` plugin (mocha, rounded windows) via TPM
- JankyBorders: mauve (`0xffcba6f7`) active, surface1 (`0xff45475a`) inactive

## AeroSpace

Windows tile top to bottom by default (set for the LG DualUp). Each workspace holds one kind of app; apps are moved there automatically when their window opens.

| #   | Workspace        | Apps                                          |
| --- | ---------------- | --------------------------------------------- |
| 1   | Terminal / code  | kitty, Terminal                               |
| 2   | Browser          | Safari                                        |
| 3   | Chat             | Slack, Messages, FaceTime                     |
| 4   | Mail & calendar  | Mail, Calendar, Reminders, Contacts           |
| 5   | Notes & docs     | Notes, Freeform, TextEdit, Preview            |
| 6   | Media            | Music, Podcasts, TV, Photos, QuickTime        |
| 7   | Maker            | Bambu Studio, Raspberry Pi Imager             |
| 8   | System           | System Settings, App Store, Passwords         |
| 9   | Spare            | —                                             |

Calculator and Finder float.

### Keys

| Key                         | Action                                         |
| --------------------------- | ---------------------------------------------- |
| `alt-1…9`                   | Go to workspace                                |
| `alt-shift-1…9`             | Move window to workspace                       |
| `alt-h/j/k/l`               | Focus left/down/up/right                       |
| `alt-shift-h/j/k/l`         | Move window                                    |
| `alt-ctrl-h/j/k/l`          | Join with neighbour (nest in a container)      |
| `alt-/`                     | Toggle tiles horizontal/vertical               |
| `alt-,`                     | Toggle accordion                               |
| `alt-f`                     | Fullscreen                                     |
| `alt-t`                     | Toggle floating/tiling                         |
| `alt-shift-r`               | Flatten workspace layout                       |
| `alt-minus` / `alt-equal`   | Shrink / grow                                  |
| `alt-tab`                   | Previous workspace                             |
| `alt-shift-tab`             | Move workspace to next monitor                 |
| `alt-shift-;`               | Service mode (`esc` reload, `r` flatten, `f` float, `backspace` close others) |

One window on top, two side by side below: focus the bottom window and press `alt-ctrl-k`.

### Launchers

Apps open, or focus (jumping to their workspace) if already running.

| Key                 | Opens                       |
| ------------------- | --------------------------- |
| `alt-enter`         | New kitty window            |
| `alt-shift-n`       | Neovim in kitty             |
| `alt-shift-a`       | Posting (HTTP API TUI)      |
| `alt-shift-x`       | x.com (existing tab or new) |
| `alt-shift-y`       | YouTube                     |
| `alt-shift-i`       | GitHub                      |
| `alt-shift-b`       | Safari                      |
| `alt-shift-s`       | Slack                       |
| `alt-shift-g`       | Messages                    |
| `alt-shift-e`       | Mail                        |
| `alt-shift-c`       | Calendar                    |
| `alt-shift-o`       | Notes                       |
| `alt-shift-m`       | Music                       |
| `alt-shift-p`       | Bambu Studio                |
| `alt-shift-,`       | System Settings             |
| `alt-shift-/`       | Passwords                   |
| `alt-shift-f`       | Finder (home)               |

## Troubleshooting

- **Borders didn't update after a switch:** `launchctl kickstart -k gui/$(id -u)/org.nix-community.home.jankyborders`
- **New AeroSpace keys not working:** `alt-shift-;` then `esc` to reload
- **Caps lock not escape on an external keyboard:** connect it and run `make switch`
- **`flake.lock` permission denied:** it was created by a `sudo` switch; `sudo chown $USER flake.lock`
- **App Store app fails to install:** get it once in the App Store (or `mas get <id>`) so it's in your purchase history
