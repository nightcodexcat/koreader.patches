-- 2-add-open-to-longpress-menu-pt.lua
-- Add a direct "Open" action to the long‑press menu for files.

local FileManager = require("apps/filemanager/filemanager")
local UIManager = require("ui/uimanager")

if FileManager._add_open_to_longpress_patched then
    return
end
FileManager._add_open_to_longpress_patched = true

FileManager:addFileDialogButtons("open_direct", function(file, is_file)
    if not is_file then
        return nil
    end

    return {
        {
            text = "Open",
            callback = function()
                local fm = FileManager.instance
                local fc = fm.file_chooser

                if fc.file_dialog then
                    UIManager:close(fc.file_dialog)
                end

                fm:openFile(file)
            end,
        },
    }
end)