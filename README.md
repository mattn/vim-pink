# vim-pink

A powerline-style statusline plugin with a pink/magenta color palette inspired by Starship.

![](https://github.com/user-attachments/assets/b8232fed-de74-4033-9582-bc8587b16e83)

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

## Customization

### Sections

Left and right sections can be customized via `g:pink_sections_left` and `g:pink_sections_right`. Each section is a dictionary with the following keys:

| Key | Required | Description |
|-----|----------|-------------|
| `content` | Yes | Statusline expression. Use `'mode'` for the mode indicator |
| `color` | No | Background color (hex). Defaults to `g:pink_default_bg` or `#DA627D` |
| `fg` | No | Foreground color (hex). Defaults to `g:pink_default_fg` or `#ECF0F1` |
| `gui` | No | GUI attributes, e.g. `'bold'` |
| `mode_colors` | No | Per-mode color overrides (only for `content = 'mode'`) |

```vim
let g:pink_sections_left = [
  \ {'content': 'mode', 'color': '#9A348E', 'fg': '#ECF0F1', 'gui': 'bold',
  \  'mode_colors': {
  \    'i': {'color': '#FCA17D', 'fg': '#2C3E50'},
  \    'R': {'color': '#C0392B', 'fg': '#ECF0F1'},
  \    'v': {'color': '#06969A', 'fg': '#ECF0F1'},
  \  }},
  \ {'content': ' %f ', 'color': '#DA627D', 'fg': '#ECF0F1', 'gui': 'bold'},
  \ {'content': ' %{pink#branch()}%{&modified ? " +" : ""} ', 'color': '#FCA17D', 'fg': '#2C3E50'},
  \ {'content': ' %{&filetype!=""?&filetype:""} ', 'color': '#86BBD8', 'fg': '#2C3E50'},
  \ ]

let g:pink_sections_right = [
  \ {'content': ' %{&fileencoding!=""?&fileencoding:&encoding} ', 'color': '#86BBD8', 'fg': '#2C3E50'},
  \ {'content': ' %l:%c ', 'color': '#06969A', 'fg': '#ECF0F1'},
  \ {'content': ' %{strftime("♥ %H:%M")} ', 'color': '#33658A', 'fg': '#ECF0F1', 'gui': 'bold'},
  \ ]
```

Colors can be omitted — default values will be used:

```vim
let g:pink_sections_left = [
  \ {'content': 'mode', 'gui': 'bold'},
  \ {'content': ' %f '},
  \ {'content': ' %l:%c ', 'color': '#9A348E'},
  \ ]
```

### Colors

| Variable | Description | Default |
|----------|-------------|---------|
| `g:pink_default_fg` | Default foreground when `fg` is omitted | `#ECF0F1` |
| `g:pink_default_bg` | Default background when `color` is omitted | `#DA627D` |
| `g:pink_color_middle` | Middle fill area | `{'color': '#06969A', 'fg': '#ECF0F1'}` |
| `g:pink_color_inactive` | Inactive window statusline | `{'color': '#9A348E', 'fg': '#ECF0F1'}` |

### Cached Command Execution

`pink#exec(cmd)` runs a shell command and caches the result per buffer.
The cache is automatically refreshed on `WinEnter`, `BufEnter`, and `BufWritePost`.

This is useful when adding custom sections that run external commands — without caching, the command would run on every statusline redraw.

```vim
" Show Node.js version
let g:pink_sections_right = [
  \ {'content': ' %{pink#exec("node --version")} ', 'color': '#33658A', 'fg': '#ECF0F1'},
  \ {'content': ' %l:%c ', 'color': '#06969A', 'fg': '#ECF0F1'},
  \ ]
```

### Other Options

| Variable | Description | Default |
|----------|-------------|---------|
| `g:pink_separator` | Separator character | `\ue0b0` (Powerline right arrow) |
| `g:pink_mode_labels` | Mode label overrides | `{'n': 'NORMAL', 'i': 'INSERT', ...}` |

## License

MIT

## Author

Yasuhiro Matsumoto (a.k.a. mattn)
