-- [[ Pre Plugin Setup ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- bootstrap lazy.nvim, etc
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

require("lazy").setup("plugins", {
  -- This Configuration is for lazy.nvim itself
  -- Needed for interop with home-manager
  performance = { 
    reset_packpath = false
  },
  lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json"
})

require("config")

-- function dump(o)
--    if type(o) == 'table' then
--       local s = '{ '
--       for k,v in pairs(o) do
--          if type(k) ~= 'number' then k = '"'..k..'"' end
--          s = s .. '['..k..'] = ' .. dump(v) .. ','
--       end
--       return s .. '} '
--    else
--       return tostring(o)
--    end
-- end
-- 
-- function splitStringByComma(inputString)
--     local result = {}
--     local pattern = "[^,]+"
--     
--     for substring in string.gmatch(inputString, pattern) do
--         table.insert(result, substring)
--     end
--     
--     return result
-- end
-- 
-- local packp = vim.opt.packpath["_value"]
-- local n = splitStringByComma(packp)[1]
-- print(n)

-- pack/myNeovimPackages/start/nvim-treesitter

