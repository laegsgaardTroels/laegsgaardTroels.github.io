Commands i find useful in Vim.<!--more-->

A good place to start using vim is to go through the guide in:

```bash
vimtutor
```

To read more about below commands use `:help` in vim. 

## Goto file with `:gf`

Super useful, when you hover over a path or something in your `PATH` then vim will goto the file.

## Explore files with `:Vexplore` and `:Sexplore`

Will split the text editor s.t. you can jump in a new window to something different.

## Jump back and forth with `CTRL-I` and `CTRL-O`

When you have jumped somewhere you can use these two to jump back and forth.

I often type 

```bash
vim .
```

And then `CTRL-O` to jump to the file I had just been editing.

## Search and Replace

You can search and replace with `:%s/from/go/gc`. The c option gives a prompt which is great.

## Sort

Mark stuff in visual mode and then type `:sort` and you will sort stuff.

## Find and till a word.

Used `:f` find a word and `:t` to find a word but put the cursor before it. Useful in visual mode.

## Find closing bracket with `%`

If you have the cursor on a bracket typing `%` will jump to the closing bracket.

## Run stuff in terminal emulator

Type `:terminal` and you will get a terminal emulator. You can copy from this terminal emulator by going into normal mode in it.
