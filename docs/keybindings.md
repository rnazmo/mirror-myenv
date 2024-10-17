---
mymetag_version:
id: "ea94048c-eb4a-40d0-acdf-6c28fb774803"
type: Cheatsheet
status: ["visibility::public", "workflow::draft"]
drafted_at: 2024-10-05T18:04
created_at: 2024-10-05T18:04
last_updated_at:
last_reviewed_at:
categories: ["myenv"]
tags: ["keybinding"]
keywords:
title: "myenv: My keybindings"
aliases:
---

☆ = very important keybinding

## Keyboard - Ergodox EZ

=> [Oryx: The ZSA Keyboard Configurator](https://configure.zsa.io/ergodox-ez/layouts/yo3zJ/latest/0)

## Desktop Environment / Window Manager - Xfce

### Workspace

- `Ctrl-Alt ←` (`|→`): Change focus previous/next
- `Ctrl-Alt-Shift ←` (`|→`): Move current window to previous/next workspace

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

- Notes:
    - 今の空きキー→ `wxvyu@#$<>()-+=`
    - 使えない・使うべきでないキー：
        - Warn (SHOULD NOT):
            - `Ctrl-i`: = `Tab`
            - `Ctrl-m`: = `Enter`
            - `Ctrl--`: = `Ctrl-_`
            - `Ctrl-/`: = `Ctrl-^`
        - Don't use (MUST NOT):
            - `Tab` = `Ctrl-i`
            - `Ctrl-@`: = `Ctrl-Space`
            - `Ctrl-[`: = `Escape`
            - `Ctrl-_`: = `Ctrl--`
            - `Ctrl-^`: = `Ctrl-/`
            - `Ctrl-c`: 各種アプリで「キャンセル」として使われていて衝突しやすい
        - Ref:
            - [Modifier Keys · tmux／tmux Wiki](https://github.com/tmux/tmux/wiki/Modifier-Keys)
            - [How to use Ctrl-semicolon for prefix in tmux? - Stack Overflow](https://stackoverflow.com/questions/30680362/how-to-use-ctrl-semicolon-for-prefix-in-tmux)

### prefix

- `prefix` = `Ctrl-\`

### pane

#### navigation

- `<prefix> h` (`|j|k|l`): change focus to left/down/up/right (∵ like neovim) ☆
- `<prefix> n` (`|r`): change focus to next/previous (∵ "n"ext, p"r"evious; "r"everse)
- ``<prefix> ` 1`` (`|...|9`): change focus by number

#### create/close

- `<prefix> g`: create new (∵ 余ってるキーの中で押しやすそうなやつを割り当てた) ☆
- `<prefix> ;` (`|'`): create new virtical/horizontal ☆
- `<prefix> q`: close (∵ "q"uit)
- `<prefix> o`: close other panes (∵ "o"ther)
- `<prefix> /`: create new floating

#### edit

- `<prefix> ←` (`|↓|↑|→`): resize
- `<prefix> i`: rename (∵ r"i"ne-mu)
- `<prefix> z`: toggle maximize (∵ "z"en mode)

#### movement

- `<prefix> s` (`|f`): swap current position with previous/next position
<!-- - `<prefix> d` (`|e`): swap current with first/last -->
- `<prefix> b`: break current pane to new tabpage (∵ "b"reak)
- `<prefix> [` (`|]`): break current pane to previous/next tabpage

#### special

- `<prefix> $`: sync panes (∵ "$"(s)ync)

### tabpage

("tabpage" is called "window" officially.)

#### navigation

- `<prefix> Ctrl-h` (`|l`): change focus ☆
- `<prefix> Ctrl-j` (`|k`): change focus to first/last
<!--TODO: Change focus to previous/next with Ctrl-r/n ?-->

#### create/close

- `<prefix> Ctrl-g`: create new (∵ 余ってるキーの中で押しやすそうなやつを割り当てた) ☆
- `<prefix> Ctrl-q`: close (∵ "q"uit)
- `<prefix> Ctrl-o`: close other tabpages (∵ "o"ther)

#### edit

- `<prefix> Ctrl-i`: rename (∵ r"i"ne-mu)

#### movement

- `<prefix> Ctrl-s` (`|f`): swap current with left/right
- `<prefix> Ctrl-d` (`|e`): swap current with first/last

### session

#### navigation

<!-- - `<prefix> Alt-n` (`|r`): change focus to next/previous (∵ "n"ext, p"r"evious/"r"everse) -->
- `<prefix> Alt-u`: choose from tree (∵ 余ってるキーの中で押しやすそうなやつを割り当てた)

<!--    - or `:choose-tree -w` -->
<!-- - `$ t a -t <session_name>`: attach to session -->
<!--    - or `$ tmux attach-session -t <session_name>` -->

#### create/close

- `<prefix> Alt-g`: create new and attach to it (∵ 余ってるキーの中で押しやすそうなやつを割り当てた) ☆
    - or `$ t`, `$ tmux`, `$ tmux new`, `:new`
- `$ t -s <session_name>`: create new with name
    - or `$ ts <sesion_name>`, `$ tmux new -s <sesion_name>`, `:new -s <session_name>`
- `<prefix> Alt-q`: close (∵ "q"uit)
    - or `:kill-session`

#### edit

- `<prefix> Alt-i`: rename (∵ r"i"ne-mu)

### server

#### create/close

- `<prefix> Alt-Ctrl-q`: close (∵ "q"uit)
    - or `:kill-server`
    - (close server = kill all sessions)

### copy-mode

- `<prefix> Space`: enter copy-mode ☆
- `<prefix> p`: paste buffer ☆
- TODO: Add more
    - Ref: <https://github.com/tmux/tmux/wiki/Getting-Started#copy-mode-key-bindings>

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

- Notes:
    - 今の空きキー→ `wxvyu@#$<>()-+=`
    - `Ctrl-c` の使用は避けること！
        - 「キャンセル」コマンドとして使われていることが多く、非常に衝突しやすい

### prefix

- `<leader>`: `Space`
- `<my_prefix>`: `<Ctrl-w>`

### pane

("pane" is "window" officiay.)

- `Ctrl-w h` (`|j|k|l`): change focus ☆
    - or `Ctrl-h` (`|j|k|l`) ☆
    - or `<leader> w h` (`|j|k|l`)
- TODO:??: resize
    - or `Ctrl ←` (`|↓|↑|→`)?? ☆
- TODO:

- `<prefix> /`: create new floating terminal

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

## CLI - bat

TODO:
