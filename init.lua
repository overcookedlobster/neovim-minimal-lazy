-- Minimal Neovim Configuration with Lazy.nvim
-- This is the main entry point for your Neovim configuration

-- Set leader key BEFORE loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Fix Lua module path for Neovim config directory
local config_dir = vim.fn.stdpath("config")
package.path = config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua;" .. package.path

-- Properly bootstrap lazy.nvim with error handling
local plugin_dir = "/nfs/iil/proj/mpg/sa_09/chip_design/projects/usb2/sonora3/ysalomox/nvim-plugins"
local lazypath = plugin_dir .. "/lazy/lazy.nvim"

print("Initializing lazy.nvim...")

-- Function to check if lazy.nvim installation is complete
local function is_lazy_complete()
  return vim.fn.isdirectory(lazypath) == 1 and
         vim.fn.isdirectory(lazypath .. "/lua") == 1 and
         vim.fn.isdirectory(lazypath .. "/doc") == 1
end

-- Bootstrap lazy.nvim if needed
if not is_lazy_complete() then
  print("Lazy.nvim not found or incomplete, installing...")

  -- Clean up any broken installation
  vim.fn.system({"rm", "-rf", lazypath})

  -- Ensure plugin directory exists
  vim.fn.mkdir(plugin_dir, "p")

  -- Clone lazy.nvim
  local clone_result = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })

  -- Verify installation
  if not is_lazy_complete() then
    error("Failed to install lazy.nvim properly. Clone result: " .. tostring(clone_result))
  end

  print("Lazy.nvim installed successfully!")
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Bootstrap lazy.nvim plugin manager
require("config.lazy")

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

