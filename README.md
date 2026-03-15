# vim-pink

A powerline-style statusline plugin with a pink/magenta color palette inspired by Starship.

## Features

- Starship-inspired color palette (purple → pink → peach → blue → teal)
- Mode-aware colors (NORMAL / INSERT / VISUAL / REPLACE)
- Git branch display (uses vim-fugitive if available, falls back to git CLI)
- Shows file path, filetype, encoding, line:column, and time
- Distinct active/inactive window statuslines

## Requirements

- Vim with `termguicolors` or GVim
- [Powerline font](https://github.com/powerline/fonts)

## Installation

```vim
Plug 'mattn/vim-pink'
```

## License

MIT

## Author

Yasuhiro Matsumoto (a.k.a. mattn)
