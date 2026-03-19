local DiffStats = require("nvim-tree.api").Decorator:extend()

-- Green for additions, red for deletions (Dracula palette)
vim.api.nvim_set_hl(0, "DiffStatsAdd", { fg = "#50fa7b" })
vim.api.nvim_set_hl(0, "DiffStatsDel", { fg = "#ff5555" })

-- Shared cache, refreshed async on file changes
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
      require("nvim-tree.api").tree.reload()
    end,
  })
end

refresh_stats()
vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained" }, { callback = refresh_stats })

function DiffStats:new()
  self.enabled = true
  self.highlight_range = "none"
  self.icon_placement = "right_align"
end

function DiffStats:icons(node)
  if node.type ~= "file" then return end
  local rel = node.absolute_path:gsub("^" .. vim.pesc(vim.fn.getcwd()) .. "/", "")
  local s = stats_cache[rel]
  if not s then
    -- Untracked files
    local gs = node.git_status and node.git_status.file
    if type(gs) == "string" and gs:match("%?") then
      return { { str = " +new", hl = { "DiffStatsAdd" } } }
    end
    return
  end
  local r = {}
  if s.a > 0 then r[#r+1] = { str = " +" .. s.a, hl = { "DiffStatsAdd" } } end
  if s.d > 0 then r[#r+1] = { str = " -" .. s.d, hl = { "DiffStatsDel" } } end
  if #r > 0 then return r end
end

return DiffStats
