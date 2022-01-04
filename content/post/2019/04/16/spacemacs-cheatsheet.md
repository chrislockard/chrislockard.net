---
title: "Spacemacs Cheatsheet"
date: "2019-04-16T15:54:22-04:00"
url: "/posts/spacemacs-cheatsheet"
categories:
- foss
tags:
- foss
- coding
- workflow
- efficiency
- emacs
- spacemacs
summary: "My personal spacemacs cheatsheet for daily use."
---

I threw this post together because I couldn't decide where my notes to myself on
using Spacemacs should go. So here they are.

Updates will frequently happen to this page, and if you're really curious, you
can view those
[here.](https://github.com/chrislockard/blog/commits/master/content/posts/2019-04-16-spacemacs-cheatsheet.md
"Link to commit history for this post") 

# Usage

Spacemacs usage notes. Note that if you find a modal seems to have trapped you
and you're not sure how to escape it, try `q` first, then `ESC`, and `C-g` (hold
CTRL and press g). My frustration when starting out with Spacemacs revolved
primarily around my fingers moving faster than my brain, and I wound up opening
prompts and terminals without understanding how to get out of them.

## Text Navigation

This is the primary feature that drew me to Spacemacs in the first place -
efficiently navigating text. I'm not going to include all of the movements you
find in `:evil-tutor-start` 

### Move between characters, lines, words, and paragraphs

`h j k l` to move left one character, down one line, up one line, or right one
character

`w` move forward to the beginning of the next word

`W` move forward one WORD (non-whitespace characters)

`B` move backward one WORD (non-whitespace characters)

`b` move backward to the beginning of the last word

`(` move backward one sentence

`)` move forward one sentence

`{` move backward one paragraph

`}` move forward one paragraph

`0` move to the start of the current line

`^` move to the first non-whitespace character on the current line

`$` move to the end of the current line

`H` move to the top of the screen

`M` move to the middle of the screen

`L` move to the bottom of the screen

`|` move to the first column on the line

Prepend a number to the front of these movements to move that number of times.
e.g., `10j` moves down 10 lines, `70|` moves to the 70th column, etc.

For a more complete reference, see [this article on the Vim
Wiki](https://vim.fandom.com/wiki/Moving_around "Vim movement keys") 

### Deletion

`d)` deletes from cursor to the end of the sentence

`d(` deletes from cursor to the beginning of the sentence

`d}` deletes from cursor to the end of the paragraph

`d{` deletes from cursor to the beginning of the paragraph

### Insertion

`SPC r y` views the [Emacs kill
ring](https://www.gnu.org/software/emacs/manual/html_node/emacs/Kill-Ring.html
"Emacs kill ring documentation") allowing for rapid selection of recently
cut/yanked text 

### Navigating headers

`gh` moves up a header

`gl` moves to the next header

`gj` moves to the next header at the same level (i.e., from one # to the next #
in markdown)

`gk` moves to the previous header at the same level (i.e., from one # to the
previous # in markdown)

### Using avy timer

`avy-goto-char-timer` is functionally equivalent to the wonderful feature of
[Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb
"Vimium plugin for Chrome") which allows for very rapidly moving to a specific
location. It's brilliant in Spacemacs! It works like this:

* Identify where you want the cursor to jump.
* `SPC j j` then press the character you want to jump to.
* All occurrences of that character will change to different characters. These
  changed characters are what you press on the keyboard to instantly put cursor
  at the location you wanted to jump to.

### Using Marks

Set a mark using `mp` where `p` is the name of the mark.

`'p` moves to the beginning of the line of mark `p`

``p` moves to the cursor position of mark `p` (this is a back-tick-p)

`''` return to cursor's location prior to the last jump (two single quotes)

`` undo last jump (two back ticks)

## File Navigation

`SPC f f` to use helm-find-file - start typing a filename to match flies in the
current helm project

`SPC f g` for rgrep. If you want to search a directory for files containing a
string, try `SPC f g` to specify the string to search for, the filetypes to
search in, and the directory in which to look.

> Note:[The Silver Searcher](https://github.com/ggreer/the_silver_searcher) must
> be installed for this to work!

`SPC s a f` for `helm-do-ag` - this is like rgrep but much faster! Will prompt
for the directory to search in and the pattern to look for in files within that
directory. (Note: permissions issues will display in the resulting buffer,
potentially clogging up results). 

### Treemacs

Be sure to check out [the Treemacs
documentation](https://github.com/Alexander-Miller/treemacs "Treemacs
documentation on github") for more information

`SPC f t` show/hide the treemacs pane

`M-0` (with OSX layer enabled, this is `alt-0`) Focuses the treemacs pane

`SPC SPC treemacs-switch-workspace` changes the treemacs workspace

`SPC SPC treemacs-edit-workspaces` edits treemacs workspaces (use `SPC SPC
treemacs-finish-edit` when done)

## Using the silver searcher (ag)

Note:[The Silver Searcher](https://github.com/ggreer/the_silver_searcher) must
be installed for this to work!

Use helm-ag to search within the current file with `SPC s a a` (space, search,
ag, helm-ag-this-file). This a very fast way to find all occurrences of a
pattern within the current file. *Note:* You need to save the file (`SPC f s`)
prior to using this search for it to work.

Use helm-ag to search for the first occurrence of a pattern in files within a
directory with `SPC s a d` (space > search > ag > helm-dir-do-ag). This can very
rapidly to, say, locate text you know is within a blog post. An alternate way to
do this is with `SPC s a f` (space > search > ag > helm-do-ag) and then enter
the directory manually you want to search. If you've opened a file from a
project in Spacemacs, it should auto-populate the project's directory for you.

## Error Checking

`flycheck-mode` is used to check certain major modes for errors. I use
`flycheck-mode`, for example, to catch markdown linting errors as I type blog
posts. This mode can be invoked with `SPC e` and then the corresponding keys:

`SPC e b` runs flycheck mode on the current buffer

`SPC e c` clears flycheck errors in the current buffer

`SPC e l` lists all flycheck errors in the current buffer (Note: keeping this
buffer open as you type can impose a performance hit)

`SPC e n` moves to the next flycheck error

`SPC e p` moves to the previous flycheck error

### Spelling 

`flycheck-mode` is also used for spell checking. Spelling errors in Spacemacs
live under the `SPC S` tree. Some of the useful ones include:

`SPC S b` run flycheck spelling on the buffer

`SPC S n` moves to the next flyspell error

`SPC S t` enables the flyspell transient state, from which you can enable or
disable flyspell

## Getting Help

`SPC h l` get help with the various layers installed and running

`SPC h k` define top-level keys. This is useful for learning what all of your
key-bindings are 

Note: This will open the helm buffer with pagination. Press `C-h n` to move
forward one page, `C-h p` to move backward one page

`SPC h d k` describes what the key does. This is helpful for discovering how to
use emacs. Note that this only shows what the key does in the current mode.

`SPC h d l` describe the last keys pressed. This is helpful for when you're not
sure what you pressed to cause an action. Text from this command will be placed
in the *Messages* buffer, which you can access with `SPC b b` and then `C-p` or
`C-n` to move lines.

`SPC h d f` describes the help information for a function. Helpful if you know
the name of a function, but you want to know what the function does. Also
helpful for discovering how much of emacs works :)

`SPC ?` show key bindings for the current major mode and minor modes

## OSX Layer

`SPC x w d` define the word under cursor

# Configuration

Spacemacs configuration notes

Understanding how Spacemacs modifies Emacs can be accomplished by reviewing
several files/directories:

`~/.emacs.d/init.el` to see how Spacemacs modifies init.el

`~/.spacemacs` is the Spacemacs configuration file that is likely the first
place investigated to better understand what Spacemacs offers

`~/.emacs.d/layers/LAYERS.org` provides a list of the layers offered by
Spacemacs

`~/.emacs.d/layers/*` review the various layer folders to view the code and
implementation of various functions

## Add new packages to Spacemacs

New packages can be installed in `~/.spacemacs` in the
`dotspacemacs-additional-packages()` list. 

## Additional Components

Some functionality in Spacemacs requires additional tools. For instance:

`gem install mdl` is required to install the `markdown linter` gem used by
flycheck

## Setting visual line movement

I prefer to have `j` and `k` move by visual rather than logical lines. To do so,
I added the following at the end of `(defun dotspacemacs/user-config ()`:

```lisp
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
```
