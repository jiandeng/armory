vim.g.mapleader = ","

local keymap = vim.keymap

-- General
keymap.set("i", "jk", "<ESC>")
keymap.set("n", "<leader>nh", ":nohl<CR>")
keymap.set("n", "<leader>w", ":w!<CR>") -- Fast saving with bang (from user's old config)
keymap.set("n", "<leader>q", ":q<CR>")

-- Window navigation (Vi-style)
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

-- Splits
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sx", ":close<CR>")

-- Move text
keymap.set("n", "<M-j>", ":m .+1<CR>==")
keymap.set("n", "<M-k>", ":m .-2<CR>==")
keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv")
keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv")

-- Function key mapping (from classic habits if any)
keymap.set("n", "0", "^") -- Map 0 to ^ (from user's old config)

-- Nvim-tree / Neo-tree toggle (Explore File)
keymap.set("n", "<leader>ef", ":Neotree toggle<CR>")

-- Aerial toggle (Explore Symbol)
keymap.set("n", "<leader>es", "<cmd>AerialToggle! right<CR>")

-- ToggleTerm (Terminal)
keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>")

-- Telescope shortcuts
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
