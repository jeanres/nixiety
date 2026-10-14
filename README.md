# nixiety

macOS setup for `Jeanres-MacBook-Pro`, managed with [nix-darwin](https://github.com/nix-darwin/nix-darwin), [Home Manager](https://github.com/nix-community/home-manager) and [Lix](https://lix.systems).

## Getting started

On a fresh Mac:

```sh
git clone <this repo> ~/.nixiety
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
| `make`         | List targets                                   |

## Layout

```
flake.nix                 entry point
Makefile
systems/development/      nix-darwin system settings (Nix/Lix, GC, caps lock → escape)
modules/homebrew/         Homebrew casks and Mac App Store apps
home/                     Home Manager, one folder per program
  default.nix             imports every program below
  aerospace/              tiling window manager
  jankyborders/           window borders
  macos/                  macOS defaults (desktop stacks)
  wezterm/  zsh/  starship/  neovim/
  git/  delta/  lazygit/
  eza/  bat/  fd/  ripgrep/  fzf/  jq/  zoxide/  direnv/
  claude-code/
```

To add a program: create `home/<name>/default.nix` and add `./<name>` to `home/default.nix`.

To add a GUI app: add its cask to `modules/homebrew/default.nix` (or its App Store ID to `masApps`).

## Shell

- `ls`, `ll`, `la`, `lla`, `lt` → eza
- `cd` → zoxide (`cd proj` jumps to a frequently used dir, `cdi` picks interactively)
- git diffs go through delta
- zsh has autosuggestions (→ to accept) and syntax highlighting
- Homebrew is on `PATH` via `~/.zprofile`

## Theme

Catppuccin Mocha, set by hand per app:

- WezTerm: built-in `Catppuccin Mocha` scheme, no title bar, no tab bar
- JankyBorders: mauve (`0xffcba6f7`) active, surface1 (`0xff45475a`) inactive

## AeroSpace

Windows tile top to bottom by default (set for the LG DualUp). Each workspace holds one kind of app; apps are moved there automatically when their window opens.

| #   | Workspace        | Apps                                          |
| --- | ---------------- | --------------------------------------------- |
| 1   | Terminal / code  | WezTerm, Terminal                             |
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
| `alt-enter`         | New WezTerm window          |
| `alt-shift-n`       | Neovim in WezTerm           |
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
| `alt-shift-a`       | claude.ai                   |
| `alt-shift-y`       | YouTube                     |
| `alt-shift-x`       | x.com                       |

## Troubleshooting

- **Borders didn't update after a switch:** `launchctl kickstart -k gui/$(id -u)/org.nix-community.home.jankyborders`
- **New AeroSpace keys not working:** `alt-shift-;` then `esc` to reload
- **Caps lock not escape on an external keyboard:** connect it and run `make switch`
- **`flake.lock` permission denied:** it was created by a `sudo` switch; `sudo chown $USER flake.lock`
- **App Store app fails to install:** get it once in the App Store (or `mas get <id>`) so it's in your purchase history
