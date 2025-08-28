-- Minimal Neovim Configuration with Lazy.nvim
-- This is the main entry point for your Neovim configuration

-- Bootstrap lazy.nvim plugin manager
require("config.lazy")

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

