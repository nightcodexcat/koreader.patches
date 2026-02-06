-- 2-disable-tap-open-files-pt.lua
-- Disable single‑tap opening of files in the FileChooser.
-- Behavior preserved:
--   • Tapping folders still navigates normally
--   • Long‑press on files still opens the action menu
--   • Select‑mode toggling still works as usual

local FileChooser = require("ui/widget/filechooser")

if FileChooser._disable_tap_open_files_patched then
    return
end
FileChooser._disable_tap_open_files_patched = true

local orig_onMenuSelect = FileChooser.onMenuSelect

function FileChooser:onMenuSelect(item)
    -- Allow folder taps to behave normally
    if not item.is_file then
        return orig_onMenuSelect(self, item)
    end

    -- Block single‑tap on files
    return true
end