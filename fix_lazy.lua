-- Script to properly fix and reinstall lazy.nvim
print("=== Fixing Lazy.nvim Installation ===")

local plugin_dir = "/nfs/iil/proj/mpg/sa_09/chip_design/projects/usb2/sonora3/ysalomox/nvim-plugins"
local lazypath = plugin_dir .. "/lazy/lazy.nvim"

print("Plugin directory: " .. plugin_dir)
print("Lazy.nvim path: " .. lazypath)

-- Step 1: Clean up broken installation
print("Step 1: Cleaning up broken lazy.nvim installation...")
vim.fn.system({"rm", "-rf", lazypath})
print("Removed broken lazy.nvim installation")

-- Step 2: Ensure plugin directory exists
print("Step 2: Creating plugin directory...")
vim.fn.mkdir(plugin_dir, "p")
print("Plugin directory created/verified")

-- Step 3: Clone lazy.nvim fresh
print("Step 3: Cloning fresh lazy.nvim...")
local clone_result = vim.fn.system({
  "git", "clone", "--filter=blob:none",
  "https://github.com/folke/lazy.nvim.git",
  "--branch=stable",
  lazypath
})

print("Clone result: " .. tostring(clone_result))

-- Step 4: Verify installation
local doc_dir = lazypath .. "/doc"
local lua_dir = lazypath .. "/lua"

print("Step 4: Verifying installation...")
print("Lazy.nvim directory exists: " .. tostring(vim.fn.isdirectory(lazypath)))
print("Doc directory exists: " .. tostring(vim.fn.isdirectory(doc_dir)))
print("Lua directory exists: " .. tostring(vim.fn.isdirectory(lua_dir)))

-- Step 5: List contents to verify
if vim.fn.isdirectory(lazypath) then
  print("Contents of lazy.nvim directory:")
  local contents = vim.fn.readdir(lazypath)
  for _, item in ipairs(contents) do
    print("  " .. item)
  end
else
  print("ERROR: Lazy.nvim directory was not created properly")
end

print("=== Fix Complete ===")
print("If all directories exist, lazy.nvim should work now.")
print("Restart Neovim to test the fixed installation.")

