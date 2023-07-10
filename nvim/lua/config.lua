-- [[ Setting options ]]
-- See `:help vim.o`
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- Save undo history
vim.opt.undofile = true
-- Set highlight on search
vim.opt.hlsearch = false
vim.opt.incsearch = true
-- Set colorscheme
vim.opt.termguicolors = true
vim.cmd "colorscheme onedark"
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
-- vim.opt.isfname:append("@-@")
-- Decrease update time
vim.opt.updatetime = 100
vim.opt.colorcolumn = "80"
-- Make line numbers default
vim.wo.number = true
-- Enable mouse mode
vim.opt.mouse = 'a'
-- Enable break indent
vim.opt.breakindent = true
-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'
vim.cmd 'language en_US'

-- [[ Basic Keymaps ]]
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})
