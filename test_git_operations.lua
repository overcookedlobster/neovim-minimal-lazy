-- Test script to check if git operations work in the target directory
print("=== Testing Git Operations ===")

local target_dir = "/nfs/iil/proj/mpg/sa_09/chip_design/projects/usb2/sonora3/ysalomox/nvim-plugins"
local test_repo = target_dir .. "/test-repo"

print("Target directory: " .. target_dir)

-- Check if directory exists and is writable
local dir_exists = vim.fn.isdirectory(target_dir)
print("Directory exists: " .. tostring(dir_exists))

if not dir_exists then
    print("Creating directory...")
    local mkdir_result = vim.fn.mkdir(target_dir, "p")
    print("Directory creation result: " .. tostring(mkdir_result))
end

-- Test git clone
print("Testing git clone...")
local clone_cmd = {
    "git", "clone",
    "https://github.com/folke/lazy.nvim.git",
    test_repo
}

local clone_result = vim.fn.system(clone_cmd)
print("Clone command: " .. table.concat(clone_cmd, " "))
print("Clone result: " .. tostring(clone_result))

-- Check if clone was successful
local repo_exists = vim.fn.isdirectory(test_repo)
print("Test repo exists after clone: " .. tostring(repo_exists))

if repo_exists then
    print("SUCCESS: Git operations work in this directory")
    -- Clean up test repo
    vim.fn.system({"rm", "-rf", test_repo})
    print("Cleaned up test repository")
else
    print("FAILED: Git operations don't work in this directory")
    print("Error details: " .. tostring(clone_result))
end

print("=== End Test ===")

