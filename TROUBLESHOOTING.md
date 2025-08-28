# Troubleshooting Guide

This guide helps you resolve common issues when installing and using the nvim-minimal-config.

## Common Installation Issues

### 1. "module 'lazy.help' not found" Error

**Symptoms:**
```
Error executing vim.schedule lua callback: .../lazy.nvim/lua/lazy/async.lua:127:
...lazy.nvim/lua/lazy/manage/init.lua:103: module 'lazy.help' not found
```

**Causes:**
- Corrupted or incomplete lazy.nvim installation
- Git clone interrupted during installation
- Network issues during plugin installation
- Permission issues in the data directory

**Solutions:**

#### Quick Fix (Recommended)
1. **Use the installation script:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```
   The script will automatically clean up corrupted installations.

2. **Manual cleanup:**
   ```bash
   # Remove corrupted lazy.nvim installation
   rm -rf ~/.local/share/nvim/lazy
   rm -rf ~/.local/share/nvim/state
   rm -rf ~/.cache/nvim

   # Start Neovim - it will reinstall lazy.nvim
   nvim
   ```

3. **Use fallback configuration:**
   ```bash
   nvim -u ~/.config/nvim/config/no-lazy-fallback.lua
   ```

#### Advanced Troubleshooting
1. **Check git configuration:**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **Test git connectivity:**
   ```bash
   git clone https://github.com/folke/lazy.nvim.git /tmp/test-lazy
   rm -rf /tmp/test-lazy
   ```

3. **Check Neovim data directory permissions:**
   ```bash
   ls -la ~/.local/share/nvim/
   # Should be writable by your user
   ```

### 2. Git Clone Failures

**Symptoms:**
- "Failed to clone lazy.nvim"
- Network timeout errors
- SSL certificate errors

**Solutions:**

1. **Check network connectivity:**
   ```bash
   ping github.com
   curl -I https://github.com
   ```

2. **Configure git for corporate networks:**
   ```bash
   # If behind a corporate firewall
   git config --global http.proxy http://proxy.company.com:8080
   git config --global https.proxy https://proxy.company.com:8080

   # If SSL issues
   git config --global http.sslverify false  # Use with caution
   ```

3. **Use SSH instead of HTTPS:**
   ```bash
   git config --global url."git@github.com:".insteadOf "https://github.com/"
   ```

### 3. Plugin Installation Failures

**Symptoms:**
- Plugins fail to install
- "Plugin not found" errors
- Timeout during plugin installation

**Solutions:**

1. **Manual plugin installation:**
   ```vim
   :Lazy install
   :Lazy sync
   ```

2. **Check plugin installation directory:**
   ```bash
   ls -la ~/.local/share/nvim/lazy/
   ```

3. **Clear plugin cache:**
   ```vim
   :Lazy clear
   :Lazy install
   ```

### 4. Permission Issues

**Symptoms:**
- "Permission denied" errors
- Cannot write to config directory
- Cannot create directories

**Solutions:**

1. **Fix directory permissions:**
   ```bash
   chmod -R 755 ~/.config/nvim
   chmod -R 755 ~/.local/share/nvim
   ```

2. **Check ownership:**
   ```bash
   ls -la ~/.config/nvim
   # Should be owned by your user
   ```

3. **Recreate directories:**
   ```bash
   rm -rf ~/.config/nvim
   mkdir -p ~/.config/nvim
   # Then reinstall the configuration
   ```

## Platform-Specific Issues

### Windows (WSL/Native)

1. **Path issues:**
   ```bash
   # Check Neovim config path
   nvim -c "echo stdpath('config')" -c "quit"
   ```

2. **Line ending issues:**
   ```bash
   git config --global core.autocrlf input
   ```

### macOS

1. **Homebrew Neovim issues:**
   ```bash
   brew uninstall neovim
   brew install neovim --HEAD
   ```

2. **XCode command line tools:**
   ```bash
   xcode-select --install
   ```

### Linux

1. **AppImage Neovim:**
   ```bash
   # Download latest AppImage
   curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
   chmod u+x nvim.appimage
   ./nvim.appimage
   ```

2. **Package manager issues:**
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install neovim

   # Arch Linux
   sudo pacman -S neovim

   # Fedora
   sudo dnf install neovim
   ```

## Configuration Issues

### 1. Keybindings Not Working

**Check leader key:**
```vim
:echo mapleader
" Should show a space character
```

**Reload configuration:**
```vim
:source ~/.config/nvim/init.lua
```

### 2. Colorscheme Issues

**Fallback colorschemes:**
```vim
:colorscheme desert
:colorscheme default
:colorscheme habamax
```

**Check available colorschemes:**
```vim
:colorscheme <Tab>
```

### 3. LSP/Treesitter Issues

**Check health:**
```vim
:checkhealth
:checkhealth lazy
:checkhealth treesitter
```

**Manual treesitter installation:**
```vim
:TSInstall lua vim
```

## Diagnostic Commands

### Check Neovim Installation
```bash
nvim --version
which nvim
```

### Check Configuration
```vim
:checkhealth
:Lazy
:echo stdpath('config')
:echo stdpath('data')
```

### Debug Mode
```bash
# Start Neovim with verbose output
nvim -V9nvim.log

# Check the log file
tail -f nvim.log
```

## Recovery Procedures

### Complete Reset
```bash
# Backup current config
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d)

# Clean all Neovim data
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Reinstall configuration
git clone <your-config-repo> ~/.config/nvim
cd ~/.config/nvim
./install.sh
```

### Minimal Working Configuration
If all else fails, create a minimal `~/.config/nvim/init.lua`:

```lua
-- Minimal working configuration
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Basic keymaps
vim.keymap.set("n", "<leader>e", ":Explore<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

-- Basic colorscheme
vim.cmd("colorscheme desert")

print("Minimal Neovim configuration loaded")
```

## Getting Help

1. **Check the logs:**
   ```bash
   tail -f ~/.local/state/nvim/log
   ```

2. **Enable debug mode:**
   ```vim
   :set verbose=9
   ```

3. **Community resources:**
   - [Neovim GitHub Issues](https://github.com/neovim/neovim/issues)
   - [Lazy.nvim Documentation](https://lazy.folke.io/)
   - [r/neovim](https://reddit.com/r/neovim)

4. **Create an issue:**
   When reporting issues, include:
   - Neovim version (`nvim --version`)
   - Operating system
   - Error messages
   - Steps to reproduce
   - Output of `:checkhealth`

## Prevention Tips

1. **Regular maintenance:**
   ```vim
   :Lazy update
   :checkhealth
   ```

2. **Backup your configuration:**
   ```bash
   git init ~/.config/nvim
   git add .
   git commit -m "Backup config"
   ```

3. **Test changes incrementally:**
   - Make small changes
   - Test each change
   - Commit working configurations

4. **Keep fallback options:**
   - Always have a working fallback configuration
   - Test the fallback regularly
   - Document your customizations

