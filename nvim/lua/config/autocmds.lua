-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- reload buffers changed outside nvim (e.g. by Claude) via inotify file watches
local watchers = {}

local function unwatch(buf)
  local w = watchers[buf]
  if w then
    w:stop()
    w:close()
    watchers[buf] = nil
  end
end

local function watch(buf)
  unwatch(buf)
  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" or vim.bo[buf].buftype ~= "" or not vim.uv.fs_stat(path) then
    return
  end
  local w = vim.uv.new_fs_event()
  watchers[buf] = w
  w:start(path, {}, vim.schedule_wrap(function()
    -- one change can queue several events; skip those from an already replaced watch
    if watchers[buf] ~= w then
      return
    end
    if not vim.api.nvim_buf_is_valid(buf) then
      return unwatch(buf)
    end
    if not vim.uv.fs_stat(path) then
      -- some tools delete then recreate a file on save, so wait before calling it gone
      unwatch(buf)
      return vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        if vim.uv.fs_stat(path) then
          watch(buf)
          vim.cmd("silent! checktime " .. buf)
        else
          vim.notify(vim.fn.fnamemodify(path, ":~:.") .. " was deleted or moved on disk", vim.log.levels.WARN)
        end
      end, 200)
    end
    -- re-arm: a save that renames a new file into place orphans the old watch
    watch(buf)
    if vim.api.nvim_get_mode().mode ~= "c" then
      vim.cmd("silent! checktime " .. buf)
    end
  end))
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  callback = function(ev) watch(ev.buf) end,
})
-- pick a file back up if it reappears after being deleted or moved
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(ev)
    if not watchers[ev.buf] then
      watch(ev.buf)
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  callback = function(ev) unwatch(ev.buf) end,
})
-- this file loads on VeryLazy, after buffers from the command line are already open
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) then
    watch(buf)
  end
end
