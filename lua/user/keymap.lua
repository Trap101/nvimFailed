


local keymap = vim.keymap.set 
local opts = {silent=true} 
keymap("", "<Space>", "<Nop>", opts) 
vim.g.mapleader = " " 
vim.g.localmapleader=" "
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)


-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope current_buffer_fuzzy_find<CR>", opts)

--buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- CHADtree 
keymap("n", "<leader>e", ":CHADopen<CR>", opts)
