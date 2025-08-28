-- Minimal Neovim Configuration with Lazy.nvim
-- This is the main entry point for your Neovim configuration

-- Set leader key BEFORE loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Fix Lua module path for Neovim config directory
local config_dir = vim.fn.stdpath("config")
package.path = config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua;" .. package.path

-- Bootstrap lazy.nvim plugin manager
require("config.lazy")

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

