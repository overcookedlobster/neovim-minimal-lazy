-- Debug version of init.lua to diagnose the module loading issue
print("=== Neovim Configuration Debug ===")

-- Check Neovim config directory
local config_dir = vim.fn.stdpath("config")
print("Config directory: " .. config_dir)

-- Check current working directory
local cwd = vim.fn.getcwd()
print("Current working directory: " .. cwd)

-- Check if config directory exists
local config_exists = vim.fn.isdirectory(config_dir)
print("Config directory exists: " .. tostring(config_exists))

-- Check if config/lazy.lua exists
local lazy_file = config_dir .. "/config/lazy.lua"
local lazy_exists = vim.fn.filereadable(lazy_file)
print("Lazy file path: " .. lazy_file)
print("Lazy file exists: " .. tostring(lazy_exists))

-- Check Lua package path
print("Lua package.path:")
for path in string.gmatch(package.path, "[^;]+") do
    print("  " .. path)
end

-- Try to add config directory to Lua path
package.path = config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua;" .. package.path
print("Updated package.path")

-- Now try to require config.lazy
local success, err = pcall(require, "config.lazy")
if success then
    print("SUCCESS: config.lazy loaded!")
else
    print("ERROR loading config.lazy: " .. tostring(err))
end

print("=== End Debug ===")

