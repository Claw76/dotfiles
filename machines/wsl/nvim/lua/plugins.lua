-- this gets a plugin installed via home-manager
function viaNix(name)
  local p = ""
  local nixpath = vim.opt.packpath["_value"]
  for sub in string.gmatch(nixpath, "[^,]+") do
    p = sub 
    break
  end
  return p ..  "/pack/myNeovimPackages/start/" .. name
end

return {
    { dir = viaNix("nvim-treesitter"), name = "nvim-treesitter" },
    { dir = viaNix("ondedark.nvim"), name = "onedark" },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    "nvim-treesitter/nvim-treesitter-textobjects",
    "mbbill/undotree",
    "lewis6991/gitsigns.nvim",
    "nvim-lualine/lualine.nvim",
    "lukas-reineke/indent-blankline.nvim",
    "numToStr/Comment.nvim",
    "tpope/vim-sleuth",
}
