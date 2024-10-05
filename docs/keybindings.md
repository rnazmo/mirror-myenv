---
mymetag_version:
id: "ea94048c-eb4a-40d0-acdf-6c28fb774803"
type: Cheatsheet
status: ["visibility::public", "workflow::draft"]
drafted_at: 2024-10-05T18:04
created_at: 2024-10-05T18:04
last_updated_at:
last_reviewed_at:
categories: ["myenv-v3"]
tags: ["keybinding"]
keywords:
title: "myenv-v3: My keybindings"
aliases:
---

## zsh

- basic (emacs mode ?):
    - `Ctrl-a`: Move cursor to start of line
    - `Ctrl-e`: Move cursor to end of line
    - `Ctrl-k`: Delete from cursor to end of line
    - `Ctrl-u`: Delete entire line
    - `Ctrl-w`: Delete word before cursor
    - ~~`Ctrl-r`: Reverse history search~~
    - `Ctrl-l`: Clear screen
- fzf:
    - *`Ctrl-r`: Fuzzy find command in history, and print selected to STDOUT*
    - `Ctrl-t`: Fuzzy find path in cwd, and print selected to STDOUT
    - *`Alt-c`: Fuzzy find path in cwd, and cd into selected*
- ghq:
    - `Ctrl-q`: Fuzzy find a repo in your ghq root, and cd into selected
- fzf-git:
    - TODO:

## tmux

### basic

- `prefix` = `Ctrl-g`
- `<prefix> :`: Enter command mode

### session management

- `<prefix> s`: Switch session from tree ("s"ession)

- `t`: Create new session
- `ts`: Create new session with name
- `:kill-session`: kill current session
- `:kill-server`: Kill all sessions

### tab management

NOTE: "tab" is "window" officiay.

- `<prefix> n`: Switch to next window ("n"ext)
- `<prefix> p`: Switch to previous window ("p"revious)

- `<prefix> c`: Create new tab ("c"reate)
- `<prefix> k`: Kill current tab ("k"ill)
- `<prefix> u`: Create new popup tab (pop"u"p)

### pane management

- `<prefix> <↑↓←→>`: Switch pane to direction
- `<prefix> o`: Switch to next pane (r"o"tate)
- `<prefix> q <0...9>`: Switch pane by number

- `<prefix> '`: Create new pane virtucally
- `<prefix> "`: Create new pane horizontally
- `<prefix> x`: Kill current pane (e"x"it)

- `<prefix> Ctrl<↑↓←→>`: Resize pane by 5
- `<prefix> m`: Toggle pane maximize/minimize ("M"aximize)
- `<prefix> !`: Break pane to new tab (break"!")
- `<prefix> Ctrl-o`: Rotate through panes (r"o"tate)

### plugin management (tpm)

- `<prefix> I`: `tmux.conf` に書いたプラグインリストにあるプラグインをインストールする ("i"nstall)
- `<prefix> u`: 全てのプラグインをアップデートする ("u"pdate)
- `<prefix> Alt-u`: `tmux.conf` に書いたプラグインリストに無いプラグインをアンインストールする ("u"nstall)

### help

- `<prefix> ?`: List key bindings

## neovim

### tab management

NOTE: "tab" is "window" officiay.

### pane management

### edit

#### indentation

While Normal Mode:

- `>>`: Increase indentation of current line
- `<<`: Decrease indentation of current line

While selecting rows in view mode:

- `>`: Increase indentation of selected lines
- `<`: Decrease indentation of selected lines
- `5>`: Increase indentation 5 times of selected lines

## lazygit

TODO:

