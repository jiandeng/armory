local api = require("Comment.api")
local config = require("Comment.config")
local ft = require("Comment.ft")
local utils = require("Comment.utils")

local M = {}

local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

local function visual_call(fn)
  return function()
    vim.api.nvim_feedkeys(esc, "nx", false)
    fn(vim.fn.visualmode())
  end
end

local function linewise_commentstring(bufnr)
  local filetype = vim.bo[bufnr or 0].filetype
  return ft.get(filetype, utils.ctype.linewise) or vim.bo[bufnr or 0].commentstring
end

local function blockwise_commentstring(bufnr)
  local linewise = linewise_commentstring(bufnr)
  local filetype = vim.bo[bufnr or 0].filetype
  local blockwise = ft.get(filetype, utils.ctype.blockwise)

  if not blockwise or blockwise == linewise then
    return nil
  end

  return blockwise
end

local function has_alternate_style(bufnr)
  return blockwise_commentstring(bufnr) ~= nil
end

local function get_active_style()
  if not has_alternate_style() then
    return utils.ctype.linewise
  end

  local active = vim.b.comment_preferred_ctype
  if active == utils.ctype.blockwise then
    return active
  end

  return utils.ctype.linewise
end

local function set_active_style(ctype)
  vim.b.comment_preferred_ctype = ctype
end

local function comment_api(ctype, mode)
  local api_group = mode == utils.cmode.uncomment and api.uncomment or api.comment
  return ctype == utils.ctype.blockwise and api_group.blockwise or api_group.linewise
end

local function current_or_count(comment_fn)
  return function()
    if vim.v.count > 0 then
      comment_fn.count(vim.v.count)
      return
    end

    comment_fn.current()
  end
end

local function comment_current_or_count()
  return current_or_count(comment_api(get_active_style(), utils.cmode.comment))()
end

local function comment_selection(mode)
  comment_api(get_active_style(), utils.cmode.comment)(mode)
end

local function comment_check(cstr, range)
  local left, right = utils.unwrap_cstr(cstr)
  local padding = utils.is_fn(config:get().padding)
  return utils.is_commented(left, right, padding)(utils.get_lines(range))
end

local function count_range(count)
  local _, range = utils.get_count_lines(count)
  return range
end

local function uncomment_current_or_count()
  if vim.v.count > 0 then
    local range = count_range(vim.v.count)

    if has_alternate_style() and comment_check(blockwise_commentstring(), range) then
      api.uncomment.blockwise.count(vim.v.count)
      return
    end

    api.uncomment.linewise.count(vim.v.count)
    return
  end

  local range = utils.get_region()
  if has_alternate_style() and comment_check(blockwise_commentstring(), range) then
    api.uncomment.blockwise.current()
    return
  end

  api.uncomment.linewise.current()
end

local function uncomment_selection(mode)
  local range = utils.get_region(mode)

  if has_alternate_style() and comment_check(blockwise_commentstring(), range) then
    api.uncomment.blockwise(mode)
    return
  end

  api.uncomment.linewise(mode)
end

local function commentstring_label(cstr)
  if not cstr then
    return ""
  end

  local left, right = utils.unwrap_cstr(cstr)
  if right == "" then
    return left
  end

  return left .. " " .. right
end

M.comment_line = comment_current_or_count
M.uncomment_line = uncomment_current_or_count
M.comment_selection = visual_call(comment_selection)
M.uncomment_selection = visual_call(uncomment_selection)

function M.has_alternate_style()
  return has_alternate_style()
end

function M.toggle_comment_style()
  if not has_alternate_style() then
    return
  end

  local next_style = get_active_style() == utils.ctype.linewise and utils.ctype.blockwise or utils.ctype.linewise
  set_active_style(next_style)

  local current = next_style == utils.ctype.blockwise and blockwise_commentstring() or linewise_commentstring()
  vim.notify("Comment style: " .. commentstring_label(current), vim.log.levels.INFO)
end

function M.configure_alt_keymaps(bufnr)
  pcall(vim.keymap.del, "n", "<leader>ca", { buffer = bufnr })
  pcall(vim.keymap.del, "x", "<leader>ca", { buffer = bufnr })

  if not has_alternate_style(bufnr) then
    return
  end

  local buf = vim.b[bufnr]
  if buf.comment_preferred_ctype == nil then
    buf.comment_preferred_ctype = utils.ctype.linewise
  end

  vim.keymap.set("n", "<leader>ca", M.toggle_comment_style, {
    buffer = bufnr,
    desc = "Switch comment style",
  })
  vim.keymap.set("x", "<leader>ca", M.toggle_comment_style, {
    buffer = bufnr,
    desc = "Switch comment style",
  })
end

return M
