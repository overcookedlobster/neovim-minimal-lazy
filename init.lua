-- Minimal Neovim Configuration with Lazy.nvim
-- This is the main entry point for your Neovim configuration

-- Set leader key BEFORE loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Fix Lua module path for Neovim config directory
local config_dir = vim.fn.stdpath("config")
package.path = config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua;" .. package.path

-- Skip lazy.nvim bootstrap since plugins are already installed
-- and the auto-installation is causing the "Too many rounds" error
local lazypath = "/nfs/iil/proj/mpg/sa_09/chip_design/projects/usb2/sonora3/ysalomox/nvim-plugins/lazy/lazy.nvim"

-- Only try to load lazy.nvim if it exists, don't auto-install
if vim.loop.fs_stat(lazypath) then
  vim.opt.rtp:prepend(lazypath)

  -- Try to load lazy.nvim safely
  local ok, lazy = pcall(require, "lazy")
  if ok then
    print("Loading existing plugins...")
    -- Just load existing plugins, don't try to install new ones
    lazy.setup({}, {
      root = "/nfs/iil/proj/mpg/sa_09/chip_design/projects/usb2/sonora3/ysalomox/nvim-plugins",
      install = { missing = false }, -- Don't auto-install missing plugins
      checker = { enabled = false }, -- Disable update checker
      change_detection = { enabled = false }, -- Disable file watching
    })
  else
    print("Lazy.nvim found but failed to load, skipping plugin manager...")
  end
else
  print("Lazy.nvim not found, using built-in features only...")
end

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

