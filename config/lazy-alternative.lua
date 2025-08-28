-- Alternative lazy.nvim configuration with different plugin locations
-- Use this if /tmp/nvim-plugins/ has git restrictions

-- Option 1: Use home directory temporary location
local home_tmp = os.getenv("HOME") .. "/.cache/nvim-plugins-temp"

-- Option 2: Use XDG cache directory
local xdg_cache = vim.fn.stdpath("cache") .. "/plugins-temp"

-- Choose your preferred location (uncomment one):
local plugin_root = home_tmp -- Option 1: ~/.cache/nvim-plugins-temp
-- local plugin_root = xdg_cache  -- Option 2: ~/.cache/nvim/plugins-temp
-- local plugin_root = "/tmp/nvim-plugins"  -- Option 3: Original /tmp location

-- Bootstrap lazy.nvim plugin manager
local lazypath = plugin_root .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	-- Clean up any existing broken installation
	vim.fn.system({ "rm", "-rf", plugin_root })

	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
	-- Explicitly load each plugin file instead of auto-discovery
	require("plugins.colorscheme"),
	require("plugins.editor"),
	require("plugins.ui"),
	require("plugins.coding"),
}, {
	-- Custom plugin installation directory
	root = plugin_root, -- directory where plugins will be installed
	-- Lazy.nvim configuration options
	defaults = {
		lazy = false, -- should plugins be lazy-loaded?
		version = false, -- always use the latest git commit
	},
	install = {
		-- install missing plugins on startup
		missing = true,
		colorscheme = { "default" },
	},
	checker = {
		-- automatically check for plugin updates
		enabled = true,
		notify = false, -- don't notify about updates
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = false, -- don't notify about changes
	},
	ui = {
		-- a number <1 is a percentage., >1 is a fixed size
		size = { width = 0.8, height = 0.8 },
		wrap = true, -- wrap the lines in the ui
		-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
		border = "rounded",
	},
})
