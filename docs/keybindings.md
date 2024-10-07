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

☆ = very important keybinding

## Keyboard - Ergodox EZ

=> [Oryx: The ZSA Keyboard Configurator](https://configure.zsa.io/ergodox-ez/layouts/yo3zJ/latest/0)

## Desktop Environment / Window Manager - Xfce

TODO: i3wm?

## Terminal - Alacritty

The terminal has no keybindings.

## Shell - Zsh

TODO:

<!--

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

-->

## Multiplexer - tmux

- `prefix` = `Ctrl-\`

### pane

#### movement

- `<prefix> h` (`|j|k|l`): change focus(∵ like neovim) ☆
- `<prefix> w`: change focus to next (∵ like neovim)
- `<prefix> a 0` (`|...|9`): change focus by number

#### create/close

- `<prefix> ;` (`|'`): new virtically/horizontally ☆
- `<prefix> q`: close (∵ "q"uit)
- `<prefix> f`: popup new floating (∵ "f"loating)

#### edit

- `<prefix> e`: rename (∵ r"e"name)
- `<prefix> ←` (`|↓|↑|→`): Resize (∵ like neovim)
- `<prefix> m`: toggle maximize (full screen) (∵ "m"aximize)

#### movement

- `<prefix> [` (`|]`): swap current with previous/next

#### special

- `<prefix> s`: sync panes (∵ "s"ync)

### tab

("tab" is "window" officiay.)

#### movement

- `<prefix> Shift-h` (`|l`): change focus ☆ (or `<prefix> Ctrl-h` (`|l`))

#### create/close

- `<prefix> Shift-c`: new (∵ "c"reate) ☆
- `<prefix> Shift-q`: close (∵ "q"uit)
- `<prefix> Shift-o`: close other tabs (∵ "o"ther)

#### edit

- `<prefix> Shift-e`: rename (∵ r"e"name)

#### movement

- `<prefix> {` (`|}`): swap current with previous/next
- `<prefix> Shift-b`: break current pane to new tab (∵ "b"reak)
- `<prefix> (` (`|)`): break current pane to previous/next tab

### session

#### movement

- `<prefix> Alt-t`: choose from tree ("t"ree) (or `:choose-tree -w`)
- `$ tmux attach-session -t <session_name>`: attach to session (or `$ tmux a -t <session_name>`)

#### create/close

- `$ t`: create new (or `$ tmux`, `$ tmux new`)
- `$ ts <session_name>`: create new with name (or `$ tmux new -s <sesion_name>`)
- `<prefix> Alt-q`: close (∵ "q"uit) (or `:kill-session`)

### server

#### create/close

- `<prefix> Alt-Ctrl-q`: close (∵ "q"uit) (or `:kill-server`)
    - (= kill all sessions)

### copy-mode

- `<prefix> Space`: enter copy-mode ☆
- `<prefix> p`: paste buffer ☆

<!--
in copy-mode:

TODO:
- `Ctrl-e` (`y`): one-line down/up
- `Ctrl-d` (`u`): half-page down/up
- `PgDn` (`PgUp`): one-page down/up
-->

### command-mode

- `<prefix> :`: enter command-mode

### config

- `<prefix> !`: reload config file

### help

- `<prefix> ?`: List key bindings

### plugin (tpm)

<!--

Ref: [tpm／docs／managing_plugins_via_cmd_line.md](https://github.com/tmux-plugins/tpm/blob/master/docs/managing_plugins_via_cmd_line.md)

- `<prefix> Alt-Shift-i`: `tmux.conf` に書いたプラグインリストにあるプラグインをインストールする ("i"nstall)
    (or `$ ~/.tmux/plugins/tpm/bin/install_plugins`)
- `<prefix> Alt-Shift-u`: 全てのプラグインをアップデートする ("u"pdate)
    (or `$ ~/.tmux/plugins/tpm/bin/update_plugins all`)
- `<prefix> Alt-Shift-r`: `tmux.conf` に書いたプラグインリストに無いプラグインをアンインストールする ("r"emove)
    (or `$ ~/.tmux/plugins/tpm/bin/clean_plugins`)
-->

## Editor - Neovim (LazyVim)

### pane

TODO:

### tab

("tab" is "window" officiay.)

TODO:

### edit

TODO:

#### indentation

While Normal Mode:

- `>>`: Increase indentation of current line
- `<<`: Decrease indentation of current line

While selecting rows in view mode:

- `>`: Increase indentation of selected lines
- `<`: Decrease indentation of selected lines
- `5>`: Increase indentation 5 times of selected lines

---

↑

main

misc

↓

---

## CLI - lazygit

TODO:

