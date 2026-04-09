local opt = vim.opt

-- General
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true

-- Tabs and indentation (based on user's old config - 4 spaces for C/C++/Python)
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- System behavior
opt.updatetime = 300
opt.clipboard:append("unnamedplus")
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 7 -- Keep 7 lines above/below cursor (from user's old config)
opt.mouse = "a"

-- Backup/Undo
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true -- Persistent undo

-- Auto-strip trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
