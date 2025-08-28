# Minimal Neovim Configuration with Lazy.nvim

A clean, minimal, and well-organized Neovim configuration using [Lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager.

## Ì†ΩÌ≥Å Structure

```
nvim-minimal-config/
‚îú‚îÄ‚îÄ init.lua                 # Main entry point
‚îú‚îÄ‚îÄ config/                  # Core configuration
‚îÇ   ‚îú‚îÄ‚îÄ lazy.lua            # Lazy.nvim bootstrap and setup
‚îÇ   ‚îú‚îÄ‚îÄ options.lua         # Neovim options
‚îÇ   ‚îú‚îÄ‚îÄ keymaps.lua         # Key mappings
‚îÇ   ‚îî‚îÄ‚îÄ autocmds.lua        # Auto commands
‚îú‚îÄ‚îÄ plugins/                 # Plugin configurations
‚îÇ   ‚îú‚îÄ‚îÄ init.lua            # Plugin organization structure
‚îÇ   ‚îú‚îÄ‚îÄ colorscheme.lua     # Colorscheme configuration
‚îÇ   ‚îú‚îÄ‚îÄ editor.lua          # Editor enhancement plugins
‚îÇ   ‚îú‚îÄ‚îÄ ui.lua              # UI enhancement plugins
‚îÇ   ‚îî‚îÄ‚îÄ coding.lua          # Coding enhancement plugins
‚îî‚îÄ‚îÄ README.md               # This file
```

## Ì†ΩÌ∫Ä Features

### Core Configuration
- **Options**: Sensible defaults for line numbers, indentation, search, and more
- **Keymaps**: Intuitive key mappings with leader key set to space
- **Autocmds**: Useful auto commands for better editing experience

### Essential Plugins
- **Colorscheme**: Tokyo Night theme
- **File Explorer**: nvim-tree for file navigation
- **Fuzzy Finder**: Telescope for finding files and content
- **Syntax Highlighting**: Treesitter for better syntax highlighting
- **Status Line**: Lualine for a beautiful status line
- **Buffer Line**: Bufferline for tab-like buffer management
- **Git Integration**: Gitsigns for git status in the gutter
- **Auto Pairs**: Automatic bracket/quote pairing
- **Comments**: Easy commenting with Comment.nvim
- **Surround**: Easy text surrounding with nvim-surround
- **Which Key**: Key binding hints

## Ì†ΩÌ≥¶ Installation

1. **Backup your existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone or copy this configuration**:
   ```bash
   git clone <this-repo> ~/.config/nvim
   # or copy the files to ~/.config/nvim/
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```

4. **Lazy.nvim will automatically**:
   - Install itself on first run
   - Install all configured plugins
   - Set up the configuration

## ‚å®Ô∏è Key Mappings

### General
- `<Space>` - Leader key
- `jk` - Exit insert mode
- `<leader>nh` - Clear search highlights

### Window Management
- `<leader>sv` - Split window vertically
- `<leader>sh` - Split window horizontally
- `<leader>se` - Make splits equal size
- `<leader>sx` - Close current split
- `<C-h/j/k/l>` - Navigate between windows

### File Operations
- `<leader>e` - Toggle file explorer
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fh` - Help tags

### Buffer Navigation
- `<S-l>` - Next buffer
- `<S-h>` - Previous buffer

## Ì†ΩÌ¥ß Customization

### Adding New Plugins
1. Create a new file in `plugins/` directory (e.g., `plugins/lsp.lua`)
2. Return a table with your plugin configurations:
   ```lua
   return {
     {
       "plugin/name",
       config = function()
         -- Plugin configuration
       end,
     },
   }
   ```

### Modifying Existing Configuration
- **Options**: Edit `config/options.lua`
- **Keymaps**: Edit `config/keymaps.lua`
- **Autocmds**: Edit `config/autocmds.lua`
- **Plugin configs**: Edit respective files in `plugins/`

### Plugin Organization
Plugins are organized by category:
- `colorscheme.lua` - Color schemes
- `editor.lua` - Editor enhancements (file explorer, fuzzy finder, etc.)
- `ui.lua` - UI improvements (status line, buffer line, etc.)
- `coding.lua` - Coding utilities (auto pairs, comments, etc.)

## Ì†ºÌæ® Colorscheme

The default colorscheme is Tokyo Night. To change it:
1. Edit `plugins/colorscheme.lua`
2. Replace the plugin or modify the colorscheme command

## Ì†ΩÌ≥ö Learning Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Documentation](https://github.com/folke/lazy.nvim)
- [Lua Guide for Neovim](https://github.com/nanotee/nvim-lua-guide)

## Ì†æÌ¥ù Contributing

Feel free to fork this configuration and make it your own! This is designed to be a starting point for your Neovim journey.

## Ì†ΩÌ≥Ñ License

This configuration is provided as-is for educational and personal use.

# neovim-minimal-lazy
