local keymap = vim.keymap
local comment = require("core.comment")

-- General
keymap.set("i", "jk", "<ESC>")
keymap.set("n", "<leader>nh", ":nohl<CR>")
keymap.set("n", "<leader>w", ":w!<CR>") -- Fast saving with bang (from user's old config)
keymap.set("n", "<leader>q", ":q<CR>")
keymap.set("n", "<leader>bd", "<cmd>Bdelete<CR>", { desc = "Delete buffer but keep window" })

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

-- Commenting (via Comment.nvim)
-- ,cc comment with current style, ,cu uncomment, ,ca switch style when supported
keymap.set("n", "<leader>cc", comment.comment_line, { desc = "Comment line with current style" })
keymap.set("n", "<leader>cu", comment.uncomment_line, { desc = "Uncomment line" })
keymap.set("x", "<leader>cc", comment.comment_selection, { desc = "Comment selection with current style" })
keymap.set("x", "<leader>cu", comment.uncomment_selection, { desc = "Uncomment selection" })

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  callback = function(args)
    comment.configure_alt_keymaps(args.buf)
  end,
})
