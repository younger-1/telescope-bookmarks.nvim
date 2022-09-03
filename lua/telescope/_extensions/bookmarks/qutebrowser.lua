local qutebrowser = {}

local utils = require "telescope._extensions.bookmarks.utils"

local bookmarks_filepath = {
  Darwin = { ".qutebrowser", "bookmarks", "urls" },
  Linux = { ".config", "qutebrowser", "bookmarks", "urls" },
  Windows_NT = {
    "AppData",
    "Roaming",
    "qutebrowser",
    "config",
    "bookmarks",
    "urls",
  },
}

---Collect all the bookmarks for qutebrowser.
---@param state TelescopeBookmarksState
---@return Bookmark[]|nil
function qutebrowser.collect_bookmarks(state)
  local components = bookmarks_filepath[state.os_name]
  if not components then
    utils.warn("Unsupported OS for qutebrowser: " .. state.os_name)
    return nil
  end

  local filepath = utils.join_path(state.os_homedir, components)
  local file = io.open(filepath, "r")
  if not file then
    utils.warn("No qutebrowser bookmarks file found at: " .. filepath)
    return nil
  end

  local bookmarks = {}
  for line in file:lines() do
    -- Format: "<url> <name>"
    local words = vim.split(line, "%s+", { trimempty = true })
    if vim.tbl_count(words) == 1 then
      table.insert(bookmarks, {
        name = "",
        path = "",
        url = words[1],
      })
    else
      local name = table.concat(words, " ", 2)
      table.insert(bookmarks, {
        name = name,
        path = name,
        url = words[1],
      })
    end
  end
  return bookmarks
end

return qutebrowser