-- Minimal Neovim Configuration with Lazy.nvim
-- This is the main entry point for your Neovim configuration

-- Set leader key BEFORE loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Fix Lua module path for Neovim config directory
local config_dir = vim.fn.stdpath("config")
package.path = config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua;" .. package.path

-- Completely bypass lazy.nvim due to persistent issues
-- Use only built-in Neovim features for a stable configuration

print("Loading minimal Neovim configuration with built-in features...")

-- Basic colorscheme (using built-in schemes)
vim.cmd([[
  try
    colorscheme desert
  catch
    colorscheme default
  endtry
]])

-- Basic file explorer using netrw (built-in)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25

-- Key mapping for file explorer
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })

-- Basic find functionality using built-in commands
vim.keymap.set("n", "<leader>ff", ":find ", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", ":grep ", { desc = "Grep search" })
vim.keymap.set("n", "<leader>fb", ":ls<CR>:b ", { desc = "List buffers" })

-- Basic status line
vim.opt.laststatus = 2
vim.opt.statusline = "%f %h%m%r%=%-14.(%l,%c%V%) %P"

-- Enable syntax highlighting (built-in)
vim.cmd("syntax enable")

-- Basic completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"

print("Minimal configuration loaded successfully!")
print("Using only built-in Neovim features.")
print("Key mappings:")
print("  <leader>e  - Open file explorer")
print("  <leader>ff - Find files")
print("  <leader>fg - Grep search")
print("  <leader>fb - List buffers")

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

