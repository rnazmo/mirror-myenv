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

- `<prefix> ;` (`|'`): create new virtically/horizontally ☆
- `<prefix> q`: close (∵ "q"uit)
- `<prefix> f`: create new floating (popup) (∵ "f"loating)

#### edit

- `<prefix> e`: rename (∵ r"e"name)
- `<prefix> ←` (`|↓|↑|→`): Resize (∵ like neovim)
- `<prefix> m`: toggle maximize (full screen) (∵ "m"aximize)

#### movement

- `<prefix> [` (`|]`): swap current with previous/next

#### special

- `<prefix> s`: sync panes (∵ "s"ync)

### tabpage

("tabpage" is called "window" officially.)

#### movement

- `<prefix> Shift-h` (`|l`): change focus ☆ (or `<prefix> Ctrl-h` (`|l`))

#### create/close

- `<prefix> Shift-c`: create new (∵ "c"reate) ☆
- `<prefix> Shift-q`: close (∵ "q"uit)
- `<prefix> Shift-o`: close other tabpages (∵ "o"ther)

#### edit

- `<prefix> Shift-e`: rename (∵ r"e"name)

#### movement

- `<prefix> {` (`|}`): swap current with previous/next
- `<prefix> Shift-b`: break current pane to new tabpage (∵ "b"reak)
- `<prefix> (` (`|)`): break current pane to previous/next tabpage

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

- `<leader>`: `Space`

### pane

("tab" is "window" officiay.)

- `Ctrl-w h` (`|j|k|l`): change focus ☆
    - or `Ctrl-h` (`|j|k|l`) ☆
    - or `<leader> w h` (`|j|k|l`)
- TODO:??: resize
    - or `Ctrl ←` (`|↓|↑|→`)?? ☆
- TODO:

TODO: Setup my keybindings to manage panes

### buffer

TODO:

TODO: Setup my keybindings to manage buffers?

### tabpage

("tabpage" is officialy term. It's offten called just "tab".)

- `g t` (`g Shift-t`): change focus ☆
    - (or `<leader> Tab [` (`]`)
- TODO:??: create new
    - (or `<leader> Tab Tab`
- TODO:??: close
    - (or `<leader> Tab d`
- TODO:??: close other tabpages
    - (or `<leader> Tab o`

TODO: Setup my keybindings to manage tabpages

### session

TODO: Setup my keybindings to manage sessions

### serevr?

TODO: ?

### search

- `<leader> s`: open "Search" menu (∵ "s"earch)
- `<leader> s g`: search for string in project-root-dir(<-?) (∵ "g"rep)
- `<leader> s r`: open "Search&Repalce" menu (∵ "r"eplace)

### file

- `<leader> f`: open "File/Find" menu (∵ "f"ile/"f"ind)
- `<leader> f f`: search for file in project-root-dir (∵ "f"ind -> "f"ile)
- `<leader> f r`: search for file in recent (∵ "f"ind -> "r"ecent)

### file explorer (neo-tree)

- `<leader> f e`: toggle file explorer in project-root-dir (∵ "f"ile -> "e"xplorer)
- TODO: change focus to file explorer
- TODO:
- in file explorer:
    - `Enter`, `l`: open file
    - `s`: open file in new virtical pane (∵ "s"plit)
    - `S`: open file in new horizontal pane (∵ "s"plit)
    - `t`: open file in new tabpage (∵ "t"abpage)
    - `Shift-p`: toggle preview
    - `a`: add new file with name (∵ "a"dd)
    - `r`: rename file (∵ "r"ename)
    - `d`: delete file (∵ "d"elete)
    - `Shift-h`: toggle display of hidden files
    - `?`: show help

### git (lazygit)

- `<leader> g`: open "Git" menu (∵ "g"it)
- `<leader> g g`: open floating lazygit (∵ "g"it?)

### terminal (toggleterm???)

- `<leader> f t`: open floating termina with project-root-dir (∵ ? -> "t"erminal)
- TODO:

### config

- `<leader> f c`: search for file in your Neovim config file (∵ "f"ile -> "c"onfig)
- TODO:

### edit

TODO:

#### comment

- `g c c`: toggle comment on line
- `g c o`: add new comment line below current line (∵ like vim `o`)
- `g c Shift-o`: add new comment line above current line (∵ like vim `Shift-o`)

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

## Input Method Editor (IME) - Fcitx5

- `LANG2` (= `Hanglhanja`): toggle input method

## CLI - lazygit

TODO:

