vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set the leader key to space for easier keybindings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Flag to indicate if Nerd Fonts are available (useful for plugins like icons)
vim.g.have_nerd_font = true

-- Fixes an error with Bun (JavaScript runtime) where it cannot find modules
vim.opt.backupcopy = 'yes'

-- Enable true color support in the terminal
vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Show line numbers
vim.opt.number = true
-- Show relative line numbers for easier navigation
vim.opt.relativenumber = true

-- Hide the mode indicator (e.g., -- INSERT --) since status lines often show this
vim.opt.showmode = false

-- Use the system clipboard for copy/paste operations
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent for better readability of wrapped lines
vim.opt.breakindent = true

-- Enable persistent undo, allowing undo history to persist across sessions
vim.opt.undofile = true

-- Ignore case in search patterns...
vim.opt.ignorecase = true
-- ...but make searches case-sensitive if the pattern contains uppercase letters
vim.opt.smartcase = true

-- Always show the sign column (e.g., for diagnostics, git changes)
vim.opt.signcolumn = 'yes'

-- Set the timeout length for mapped sequences (in milliseconds)
vim.opt.timeoutlen = 250

-- Open new vertical splits to the right and horizontal splits below
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Enable display of invisible characters (e.g., tabs, trailing spaces)
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show live preview of substitutions
vim.opt.inccommand = 'split'

-- Highlight the current line for better focus
vim.opt.cursorline = true

-- Keep 10 lines visible above/below the cursor when scrolling
vim.opt.scrolloff = 10

-- Keybinding: Exit insert mode by pressing 'jk'
vim.keymap.set('i', 'jk', '<ESC>', { noremap = true })

-- Keybinding: Clear search highlights by pressing Escape in normal mode
vim.keymap.set('n', '<ESC>', '<cmd>nohlsearch<CR>')

-- Keybindings: Cycle through buffers using Tab and Shift-Tab
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>')
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>')

-- Keybindings: Navigate between windows using Ctrl + h/j/k/l
vim.keymap.set('n', '<C-h>', '<cmd>wincmd h<CR>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<cmd>wincmd l<CR>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<cmd>wincmd j<CR>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<cmd>wincmd k<CR>', { desc = 'Move focus to the upper window' })

-- vim.keymap.set('n', '<leader>x', '<cmd>bd<CR>', { desc = 'Close current buffer' })
vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
vim.keymap.set("n", "<leader>ba", function() Snacks.bufdelete.all() end, { desc = "Delete All Buffers" })

-- Tabs
vim.keymap.set('n', '<leader>tn', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
vim.keymap.set('n', '<leader>tp', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<CR>', { desc = 'Close Tab' })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<CR>', { desc = 'Close Other Tabs' })
vim.keymap.set('n', '<leader>tt', '<cmd>tabnew<CR>', { desc = 'New tab' })

-- FZF Keymaps
-- vim.keymap.set('n', '<leader>ff', '<cmd>Files<CR>', { desc = 'Find Files (FZF)' })
-- vim.keymap.set('n', '<leader>fg', '<cmd>GitFiles<CR>', { desc = 'Find Git Files (FZF)' })
-- vim.keymap.set('n', '<leader>fb', '<cmd>Buffers<CR>', { desc = 'Find Buffers (FZF)' })
-- vim.keymap.set('n', '<leader>fw', '<cmd>Rg<CR>', { desc = 'Grep for word (FZF)' })
-- vim.keymap.set('n', '<leader>fc', '<cmd>Commands<CR>', { desc = 'FZF Commands' })
-- vim.keymap.set('n', '<leader>fh', '<cmd>Helptags<CR>', { desc = 'FZF Helptags' })
-- vim.keymap.set('n', '<leader>fl', '<cmd>BLines<CR>', { desc = 'FZF Buffer Lines' })
