local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function GitAmr()
  local git_status = vim.fn.system("git status --porcelain")
  local a, m, r = 0, 0, 0
  for _, line in ipairs(vim.split(git_status, "\n")) do
    local stat = trim(string.sub(line, 1, 2))
    if stat == "A" then
      a = a + 1
    elseif stat == "M" then
      m = m + 1
    elseif stat == "D" then
      r = r + 1
    end
  end
  return a, m, r
end

local function GitBranch()
  local gb = vim.fn.system("git branch --show-current")
  if gb then
    return trim(gb)
  end
  return ""
end

local function FallbackStatusline()
  vim.opt.statusline = " %f%m%= %{&fileencoding?&fileencoding:&encoding}[%{&fileformat}]%y %3p%% %4l:%3c"
end

local function StatuslineUpdate()
  local branch = GitBranch() ~= "" and string.format("[%s]", GitBranch()) or "[N/A]"
  local added, modified, removed = GitAmr()
  local amr = GitBranch() ~= "" and "(+" .. added .. " ~" .. modified .. " -" .. removed .. ")" or ""
  vim.opt.statusline = branch
      .. amr
      .. " %f%m%= %{&fileencoding?&fileencoding:&encoding}[%{&fileformat}]%y %3p%% %4l:%3c"
end

if vim.fn.executable("git") == 1 then
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = StatuslineUpdate,
  })
  vim.keymap.set("n", "<leader>gu", StatuslineUpdate, {})
else
  FallbackStatusline()
end
