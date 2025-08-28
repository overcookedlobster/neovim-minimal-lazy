-- Robust lazy.nvim configuration with better error handling
-- This configuration includes fallback mechanisms and better error handling

local M = {}

-- Function to safely bootstrap lazy.nvim
local function bootstrap_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  -- Check if lazy.nvim already exists
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    print("Bootstrapping lazy.nvim...")

    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable",
      lazyrepo,
      lazypath
    })

    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nFalling back to minimal configuration...", "WarningMsg" },
      }, true, {})

      -- Load fallback configuration
      vim.schedule(function()
        local fallback_path = vim.fn.stdpath("config") .. "/config/no-lazy-fallback.lua"
        if vim.fn.filereadable(fallback_path) == 1 then
          dofile(fallback_path)
        else
          -- Minimal inline fallback
          vim.cmd("colorscheme desert")
          vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "File explorer" })
          print("Minimal fallback configuration loaded")
        end
      end)
      return false
    end
  end

  vim.opt.rtp:prepend(lazypath)
  return true
end

-- Function to safely setup lazy.nvim
local function setup_lazy()
  local success, lazy = pcall(require, "lazy")
  if not success then
    vim.api.nvim_echo({
      { "Failed to load lazy.nvim module\n", "ErrorMsg" },
      { "Loading fallback configuration...", "WarningMsg" },
    }, true, {})
    return false
  end

  -- Plugin specifications
  local plugins = {
    -- Colorscheme with fallback
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        local ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
        if not ok then
          vim.cmd("colorscheme desert")
        end
      end,
    },

    -- File explorer
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        local ok, nvim_tree = pcall(require, "nvim-tree")
        if ok then
          nvim_tree.setup({})
        end
      end,
      keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
      },
    },

    -- Fuzzy finder
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.5",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local ok, telescope = pcall(require, "telescope")
        if ok then
          telescope.setup({})
        end
      end,
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      },
    },

    -- Treesitter with error handling
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local ok, configs = pcall(require, "nvim-treesitter.configs")
        if ok then
          configs.setup({
            ensure_installed = { "lua", "vim", "vimdoc", "query" },
            sync_install = false,
            auto_install = true,
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
          })
        end
      end,
    },

    -- Status line
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        local ok, lualine = pcall(require, "lualine")
        if ok then
          lualine.setup({
            options = {
              theme = "auto",
              component_separators = { left = "", right = "" },
              section_separators = { left = "", right = "" },
            },
          })
        end
      end,
    },

    -- Buffer line
    {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
        local ok, bufferline = pcall(require, "bufferline")
        if ok then
          bufferline.setup({})
        end
      end,
    },

    -- Additional plugins with error handling
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      config = function()
        local ok, ibl = pcall(require, "ibl")
        if ok then
          ibl.setup()
        end
      end,
    },

    {
      "lewis6991/gitsigns.nvim",
      config = function()
        local ok, gitsigns = pcall(require, "gitsigns")
        if ok then
          gitsigns.setup()
        end
      end,
    },

    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        local ok, autopairs = pcall(require, "nvim-autopairs")
        if ok then
          autopairs.setup({})
        end
      end,
    },

    {
      "numToStr/Comment.nvim",
      config = function()
        local ok, comment = pcall(require, "Comment")
        if ok then
          comment.setup()
        end
      end,
    },

    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      config = function()
        local ok, surround = pcall(require, "nvim-surround")
        if ok then
          surround.setup({})
        end
      end,
    },

    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      config = function()
        local ok, which_key = pcall(require, "which-key")
        if ok then
          which_key.setup({})
        end
      end,
    },
  }

  -- Lazy.nvim setup with error handling
  local setup_ok, setup_err = pcall(lazy.setup, plugins, {
    defaults = {
      lazy = false,
      version = false,
    },
    install = {
      missing = true,
      colorscheme = { "tokyonight", "desert", "default" },
    },
    checker = {
      enabled = true,
      notify = false,
    },
    change_detection = {
      enabled = true,
      notify = false,
    },
    ui = {
      size = { width = 0.8, height = 0.8 },
      wrap = true,
      border = "rounded",
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })

  if not setup_ok then
    vim.api.nvim_echo({
      { "Failed to setup lazy.nvim:\n", "ErrorMsg" },
      { tostring(setup_err), "WarningMsg" },
      { "\nSome features may not work correctly.", "WarningMsg" },
    }, true, {})
    return false
  end

  return true
end

-- Main initialization function
function M.init()
  -- Set leader keys before loading plugins
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  -- Bootstrap lazy.nvim
  if not bootstrap_lazy() then
    return false
  end

  -- Setup lazy.nvim with plugins
  if not setup_lazy() then
    return false
  end

  -- Success message
  vim.schedule(function()
    print("Lazy.nvim configuration loaded successfully!")
  end)

  return true
end

-- Auto-command to handle lazy.nvim errors
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyInstall",
  callback = function()
    -- Check for installation errors and provide guidance
    vim.schedule(function()
      local lazy = require("lazy")
      local failed = {}

      for name, plugin in pairs(lazy.plugins()) do
        if plugin._.installed == false then
          table.insert(failed, name)
        end
      end

      if #failed > 0 then
        vim.api.nvim_echo({
          { "Some plugins failed to install:\n", "WarningMsg" },
          { table.concat(failed, ", "), "ErrorMsg" },
          { "\nYou can retry with :Lazy install", "Normal" },
        }, true, {})
      end
    end)
  end,
})

return M

