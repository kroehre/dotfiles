-- Neo-tree component: git diff numstat (+N/-N) per file
-- Green for additions, red for deletions (Dracula palette)
vim.api.nvim_set_hl(0, "DiffStatsAdd", { fg = "#50fa7b" })
vim.api.nvim_set_hl(0, "DiffStatsDel", { fg = "#ff5555" })

local stats_cache = {}

local function refresh_stats()
  vim.fn.jobstart({ "git", "diff", "--numstat" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local new = {}
      for _, line in ipairs(data) do
        local a, d, file = line:match("^(%d+)%s+(%d+)%s+(.+)$")
        if file then new[file] = { a = tonumber(a), d = tonumber(d) } end
      end
      stats_cache = new
    end,
  })
end

local function refresh_all()
  refresh_stats()
  local ok, manager = pcall(require, 'neo-tree.sources.manager')
  if ok then
    for _, source in ipairs({ 'filesystem', 'git_status' }) do
      pcall(manager.refresh, source)
    end
  end
end

refresh_stats()
vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained" }, { callback = refresh_all })

-- Poll for changes every 5s so the tree stays current while Claude works
local timer = vim.loop.new_timer()
timer:start(1000, 1000, vim.schedule_wrap(refresh_all))

return function(config, node, state)
  if node.type ~= "file" then return {} end

  local path = node:get_id()
  local rel = path:gsub("^" .. vim.pesc(vim.fn.getcwd()) .. "/", "")
  local s = stats_cache[rel]

  if not s then
    local ok, gs = pcall(node.get_git_status, node)
    if ok and gs and type(gs) == "string" and gs:match("%?") then
      return { { text = "+new ", highlight = "DiffStatsAdd" } }
    end
    return {}
  end

  local parts = {}
  if s.a > 0 then parts[#parts + 1] = { text = "+" .. s.a, highlight = "DiffStatsAdd" } end
  if s.d > 0 then parts[#parts + 1] = { text = "/" .. "-" .. s.d, highlight = "DiffStatsDel" } end
  if #parts > 0 then parts[#parts].text = parts[#parts].text .. " " end
  return parts
end
