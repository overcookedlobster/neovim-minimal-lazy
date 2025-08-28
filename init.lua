-- Minimal Neovim Configuration with Robust Error Handling
-- This configuration provides fallback mechanisms for installation issues

-- Set leader keys first
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load basic configuration modules with error handling
local config_modules = {
  "config.options",
  "config.keymaps",
  "config.autocmds",
}

for _, module in ipairs(config_modules) do
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify("Error loading " .. module .. ": " .. err, vim.log.levels.WARN)
  end
end

-- Try to load lazy.nvim configuration with multiple fallbacks
local function try_lazy_config()
  -- Try robust lazy configuration first
  local ok, err = pcall(function()
    local robust_config = require("config.lazy-robust")
    return robust_config.init()
  end)

  if ok and err then
    return true
  end

  -- Try original lazy configuration
  ok, err = pcall(require, "config.lazy")
  if ok then
    return true
  end

  -- Final fallback to no-lazy configuration
  vim.notify("Lazy.nvim failed to load. Using fallback configuration.", vim.log.levels.WARN)
  ok, err = pcall(require, "config.no-lazy-fallback")
  if ok then
    return true
  end

  -- Last resort: minimal inline configuration
  vim.notify("All configurations failed. Using minimal setup.", vim.log.levels.ERROR)
  vim.cmd("colorscheme desert")
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "File explorer" })

  return false
end

-- Initialize configuration
try_lazy_config()

