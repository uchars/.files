local ok_gs, gs = pcall(require, "gitsigns")
local ok_gw, gw = pcall(require, "git-worktree")
if not ok_gw and not ok_gs then
  return
end

gs.setup()
gw.setup()

vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>")
