-- Bootstrap lazy.nvim plugin manager
local lazypath = "/nfs/iil/proj/mpg/sa_09/chip_design/projects/usb2/sonora3/ysalomox/nvim-plugins/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
  root = "/nfs/iil/proj/mpg/sa_09/chip_design/projects/usb2/sonora3/ysalomox/nvim-plugins", -- directory where plugins will be installed
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

