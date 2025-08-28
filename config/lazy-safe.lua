-- Safe lazy.nvim configuration with better error handling and fallback
print("Starting lazy.nvim bootstrap...")

local target_dir = "/nfs/iil/proj/mpg/sa_09/chip_design/projects/usb2/sonora3/ysalomox/nvim-plugins"
local lazypath = target_dir .. "/lazy/lazy.nvim"

-- Function to safely test git operations
local function test_git_operations()
  local test_dir = target_dir .. "/git-test"

  -- Clean up any existing test directory
  vim.fn.system({"rm", "-rf", test_dir})

  -- Try to clone a small test repository
  local result = vim.fn.system({
    "git", "clone", "--depth=1",
    "https://github.com/folke/lazy.nvim.git",
    test_dir
  })

  local success = vim.fn.isdirectory(test_dir .. "/.git")

  -- Clean up test directory
  vim.fn.system({"rm", "-rf", test_dir})

  return success, result
end

-- Function to create directory safely
local function ensure_directory(path)
  if not vim.fn.isdirectory(path) then
    local result = vim.fn.mkdir(path, "p")
    if result == 0 then
      error("Failed to create directory: " .. path)
    end
  end
end

-- Check if lazy.nvim is already installed and working
local lazy_installed = vim.fn.isdirectory(lazypath .. "/.git")

if not lazy_installed then
  print("Lazy.nvim not found, testing git operations...")

  -- Ensure target directory exists
  local ok, err = pcall(ensure_directory, target_dir)
  if not ok then
    error("Cannot create plugin directory: " .. err)
  end

  -- Test if git operations work in this directory
  local git_works, git_error = test_git_operations()

  if not git_works then
    error("Git operations failed in target directory. Error: " .. tostring(git_error) ..
          "\nPlease choose a different directory or check permissions.")
  end

  print("Git test passed, cloning lazy.nvim...")

  -- Clean up any broken lazy.nvim installation
  vim.fn.system({"rm", "-rf", lazypath})

  -- Clone lazy.nvim with better error handling
  local clone_result = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--depth=1",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })

  -- Verify the clone was successful
  if not vim.fn.isdirectory(lazypath .. "/.git") then
    error("Failed to clone lazy.nvim. Error: " .. tostring(clone_result))
  end

  print("Lazy.nvim cloned successfully!")
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim with minimal plugins to avoid loading issues
local ok, lazy = pcall(require, "lazy")
if not ok then
  error("Failed to load lazy.nvim after installation")
end

lazy.setup({
  -- Essential colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Essential file explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    },
  },

  -- Essential fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    },
  },
}, {
  root = target_dir,
  defaults = { lazy = false },
  install = { missing = true },
  checker = { enabled = false }, -- Disable checker to avoid network issues
  change_detection = { enabled = false }, -- Disable to avoid file watching issues
  ui = {
    size = { width = 0.8, height = 0.8 },
    border = "rounded",
  },
})

print("Lazy.nvim setup completed successfully!")

