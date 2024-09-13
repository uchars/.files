local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function git_amr()
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

if not vim.fn.exists(":Git") ~= 0 then
  -- use fallback statusline
  vim.opt.statusline = "%f%m%= %{&fileencoding?&fileencoding:&encoding}[%{&fileformat}]%y %3p%% %4l:%3c"
  return
end

local branch = vim.fn.FugitiveHead() ~= "" and "[%{FugitiveHead()}]" or "[N/A]"
local added, modified, removed = git_amr()
local amr = vim.fn.FugitiveHead() ~= "" and "(+" .. added .. " ~" .. modified .. " -" .. removed .. ")" or ""
vim.opt.statusline = branch .. amr .. " %f%m%= %{&fileencoding?&fileencoding:&encoding}[%{&fileformat}]%y %3p%% %4l:%3c"
