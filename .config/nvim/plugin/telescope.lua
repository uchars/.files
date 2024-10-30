local ok, _ = pcall(require, "telescope")
local fzf_ok, _ = pcall(require, "fzf")
if not ok then
  return
end

local function get_env_or_default(env, default)
  if os.getenv(env) == nil then
    return default
  end
  return os.getenv(env)
end

local function remove_nonexistant_dirs(dirs)
  local valid = {}
  for _, dir in pairs(dirs) do
    if vim.fn.isdirectory(dir) ~= 0 then
      table.insert(valid, dir)
    end
  end
  return valid
end

require("telescope").setup({
  defaults = {
    file_ignore_patterns = { ".git/", ".cache/" },
    theme = "ivy",
    previewer = true,
    prompt_prefix = "-> ",
    layout_strategy = "bottom_pane",
    layout_config = {
      height = 0.3,
      prompt_position = "top",
    },
    borderchars = { "─", "", "", "", "", "", "", "" },
  },
  pickers = {
    live_grep = {
      hidden = true,
    },
    find_files = {
      hidden = true,
    },
  },
})

if fzf_ok then
  require("telescope").load_extension("fzf")
end
require("telescope").load_extension("git_worktree")

vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles)
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>/", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    theme = "ivy",
    previewer = true,
    prompt_prefix = "-> ",
    layout_strategy = "bottom_pane",
    layout_config = {
      height = 0.3,
      prompt_position = "top",
    },
    borderchars = { "─", "", "", "", "", "", "", "" },
  }))
end)
vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files)
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files)
vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string)
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<C-f>", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics)
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<leader>gb", require("telescope.builtin").git_branches)
vim.keymap.set("n", "<leader>gc", require("telescope.builtin").git_commits)
vim.keymap.set("n", "<leader>gw", require("telescope").extensions.git_worktree.git_worktrees)
vim.keymap.set("n", "<leader>gW", require("telescope").extensions.git_worktree.create_git_worktree)
