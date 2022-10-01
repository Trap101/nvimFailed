local keymap = vim.keymap.set

local opts = { silent = true }
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.localmapleader = " "
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "ge", "<S-g>", opts)
keymap("n", "ne", "$", opts)
keymap("v", "ne", "$", opts)
keymap("n", "ns", "0", opts)
keymap("v", "ns", "0", opts)
-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope current_buffer_fuzzy_find<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
--buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<S-q>", ":bdelete<CR>", opts)
-- CHADtree
keymap("n", "<leader>e", ":CHADopen<CR>", opts)

--codeRunner
vim.keymap.set("n", "<leader>r", ":RunCode<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rft", ":RunFile tab<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rp", ":RunProject<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rc", ":RunClose<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>crf", ":CRFiletype<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>crp", ":CRProjects<CR>", { noremap = true, silent = false })
