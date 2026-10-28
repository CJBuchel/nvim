-- Which code style applies to a buffer.
--
-- Every language-specific formatter config (lua/plugins/lang/*.lua) asks this
-- module which style to use when a project has no formatter config of its own.
-- A project's own .clang-format / pyproject.toml / .prettierrc always wins;
-- the formatters handle that themselves and never consult this module.
--
-- Resolution order, first match wins:
--
--   1. vim.g.code_style   set with `:CodeStyle <name>` for the session, or by a
--                         project-local .nvim.lua (see README "Code style")
--   2. detection          the file is inside a ROS 2 package (package.xml above it)
--   3. M.default
--
-- The active style is shown in the statusline for C/C++ and Python buffers.

local M = {}

M.styles = { "google", "ros2" }
M.default = "google"

-- Files that mark a ROS 2 package. Searched upward from the buffer's directory.
local ros2_markers = { "package.xml" }

---@param bufnr? integer
---@return string style one of M.styles
function M.get(bufnr)
  if vim.g.code_style then
    return vim.g.code_style
  end
  local file = vim.api.nvim_buf_get_name(bufnr or 0)
  if file ~= "" and vim.fs.find(ros2_markers, { path = vim.fs.dirname(file), upward = true })[1] then
    return "ros2"
  end
  return M.default
end

--- Human-readable form for the statusline and :CodeStyle, e.g. "google (auto)".
---@param bufnr? integer
function M.describe(bufnr)
  local style = M.get(bufnr)
  return vim.g.code_style and style or (style .. " (auto)")
end

---@param style string one of M.styles, or "auto" to go back to detection
function M.set(style)
  if style == "auto" then
    vim.g.code_style = nil
  elseif vim.tbl_contains(M.styles, style) then
    vim.g.code_style = style
  else
    local expected = "auto, " .. table.concat(M.styles, ", ")
    vim.notify(("Unknown code style %q (expected: %s)"):format(style, expected), vim.log.levels.ERROR)
    return
  end
  vim.notify("Code style: " .. M.describe())
end

--- Registers `:CodeStyle [auto|google|ros2]`. Called from config/autocmds.lua.
function M.setup()
  vim.api.nvim_create_user_command("CodeStyle", function(cmd)
    if cmd.args == "" then
      vim.notify("Code style: " .. M.describe())
    else
      M.set(cmd.args)
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.list_extend({ "auto" }, M.styles)
    end,
    desc = "Show or set the code style used by formatters",
  })
end

return M
