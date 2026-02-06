-- 2-sort-by-author-titlesort-seriessort.lua
-- Custom sorting for KOReader’s file browser.
-- Alphabetical hybrid sort (series + standalone mixed).
-- Uses Calibre title_sort when available.
-- Strips leading articles ("The", "A", "An") from series names.
-- Place this file in koreader/patches/.
-- Not compatible with multi-author ebooks.


local BookList = require("ui/widget/booklist")
local ffiUtil = require("ffi/util")
local _ = require("gettext")

local function prepareItem(item, ui)
    if not ui or not ui.bookinfo then
        item.doc_props = {
            authors = "\u{FFFF}",
            series = "\u{FFFF}",
            display_title = item.text,
            pubdate = "\u{FFFF}"
        }
        return
    end

    local doc_props = ui.bookinfo:getDocProps(item.path or item.file)
    doc_props.authors = doc_props.authors or "\u{FFFF}"
    doc_props.series = doc_props.series or "\u{FFFF}"
    doc_props.display_title = doc_props.display_title or item.text
    doc_props.pubdate = doc_props.pubdate or "\u{FFFF}"
    item.doc_props = doc_props
end

-- NEW: unified sortable-title helper
local function getSortableTitle(doc_props)
    if not doc_props then return "" end

    -- Prefer Calibre's title_sort if present
    local t = doc_props.title_sort
    if t and t ~= "" then
        return t
    end

    -- Fallback: strip leading articles from display_title
    t = doc_props.display_title or ""
    t = t:gsub("^The%s+", "", 1)
         :gsub("^A%s+", "", 1)
         :gsub("^An%s+", "", 1)

    return t
end

-- NEW: sortable-series helper (strip leading articles)
local function getSortableSeries(doc_props)
    if not doc_props then return "" end

    local s = doc_props.series or ""
    s = s:gsub("^The%s+", "", 1)
         :gsub("^A%s+", "", 1)
         :gsub("^An%s+", "", 1)

    return s
end

local function processAuthorName(author_name, sort_type)
    if not author_name or author_name == "\u{FFFF}" then
        return author_name
    end

    if sort_type == "last_first" then
        local words = {}
        for word in author_name:gmatch("%S+") do
            table.insert(words, word)
        end
        if #words > 1 then
            local last_name = words[#words]
            local first_names = {}
            for i = 1, #words - 1 do
                table.insert(first_names, words[i])
            end
            return last_name .. ", " .. table.concat(first_names, " ")
        end
    end

    return author_name
end

local function formatInfo(item, sort_type)
    local info = ""
    if not item.doc_props then
        return info
    end

    if item.doc_props.authors and item.doc_props.authors ~= "\u{FFFF}" then
        local formatted_author = processAuthorName(item.doc_props.authors, sort_type)
        info = info .. formatted_author
    end

    if item.doc_props.series and item.doc_props.series ~= "\u{FFFF}" then
        if item.doc_props.series_index then
            info = info .. " • " .. item.doc_props.series .. " #" .. item.doc_props.series_index
        else
            info = info .. " • " .. item.doc_props.series
        end
    end

    if item.doc_props.pubdate and item.doc_props.pubdate ~= "\u{FFFF}" then
        info = info .. " • " .. item.doc_props.pubdate
    end

    return info
end

local function compareAuthorSeries(a, b, author_sort_type)
    -- Normalize author names
    local author_a = processAuthorName(a.doc_props.authors, author_sort_type)
    local author_b = processAuthorName(b.doc_props.authors, author_sort_type)

    -- 1. Compare authors
    if author_a ~= author_b then
        return ffiUtil.strcoll(author_a, author_b)
    end

    -- 2. Build a "series key" that normalizes series names and titles
    local series_a = a.doc_props.series
    local series_b = b.doc_props.series

    local key_a = (series_a and series_a ~= "\u{FFFF}")
                  and getSortableSeries(a.doc_props)
                  or getSortableTitle(a.doc_props)

    local key_b = (series_b and series_b ~= "\u{FFFF}")
                  and getSortableSeries(b.doc_props)
                  or getSortableTitle(b.doc_props)

    -- 3. Compare series key (merges standalones + series alphabetically)
    if key_a ~= key_b then
        return ffiUtil.strcoll(key_a, key_b)
    end

    -- 4. If both are in the same series, compare series index
    if a.doc_props.series_index and b.doc_props.series_index
       and series_a ~= "\u{FFFF}" then
        return a.doc_props.series_index < b.doc_props.series_index
    end

    -- 5. Final fallback: compare sortable titles
    return ffiUtil.strcoll(getSortableTitle(a.doc_props), getSortableTitle(b.doc_props))
end

-- Helper functions defined at module level
local CustomSorting = {
    prepareItem = prepareItem,
    formatInfo = formatInfo,
    compareAuthorSeries = compareAuthorSeries,
}

-- Sorting options
BookList.collates.author_first_last_series_title = {
    text = _("author (first name) – alphabetical – title"),
    menu_order = 5,
    can_collate_mixed = false,

    item_func = function(item, ui)
        CustomSorting.prepareItem(item, ui)
    end,

    init_sort_func = function(cache)
        local my_cache = cache or {}
        return function(a, b)
            local result = CustomSorting.compareAuthorSeries(a, b, "first_last")
            if result ~= nil then
                return result
            end
            return ffiUtil.strcoll(getSortableTitle(a.doc_props), getSortableTitle(b.doc_props))
        end, my_cache
    end,

    mandatory_func = function(item)
        return CustomSorting.formatInfo(item, "first_last")
    end,
}

BookList.collates.author_last_first_series_title = {
    text = _("author (last name) – alphabetical – title"),
    menu_order = 6,
    can_collate_mixed = false,

    item_func = function(item, ui)
        CustomSorting.prepareItem(item, ui)
    end,

    init_sort_func = function(cache)
        local my_cache = cache or {}
        return function(a, b)
            local result = CustomSorting.compareAuthorSeries(a, b, "last_first")
            if result ~= nil then
                return result
            end
            return ffiUtil.strcoll(getSortableTitle(a.doc_props), getSortableTitle(b.doc_props))
        end, my_cache
    end,

    mandatory_func = function(item)
        return CustomSorting.formatInfo(item, "last_first")
    end,
}

BookList.collates.author_first_last_series_date = {
    text = _("author (first name) – alphabetical – date"),
    menu_order = 7,
    can_collate_mixed = false,

    item_func = function(item, ui)
        CustomSorting.prepareItem(item, ui)
    end,

    init_sort_func = function(cache)
        local my_cache = cache or {}
        return function(a, b)
            local result = CustomSorting.compareAuthorSeries(a, b, "first_last")
            if result ~= nil then
                return result
            end
            if a.doc_props.pubdate ~= b.doc_props.pubdate then
                return ffiUtil.strcoll(a.doc_props.pubdate, b.doc_props.pubdate)
            end
            return ffiUtil.strcoll(getSortableTitle(a.doc_props), getSortableTitle(b.doc_props))
        end, my_cache
    end,

    mandatory_func = function(item)
        return CustomSorting.formatInfo(item, "first_last")
    end,
}

BookList.collates.author_last_first_series_date = {
    text = _("author (last name) – alphabetical – date"),
    menu_order = 8,
    can_collate_mixed = false,

    item_func = function(item, ui)
        CustomSorting.prepareItem(item, ui)
    end,

    init_sort_func = function(cache)
        local my_cache = cache or {}
        return function(a, b)
            local result = CustomSorting.compareAuthorSeries(a, b, "last_first")
            if result ~= nil then
                return result
            end
            if a.doc_props.pubdate ~= b.doc_props.pubdate then
                return ffiUtil.strcoll(a.doc_props.pubdate, b.doc_props.pubdate)
            end
            return ffiUtil.strcoll(getSortableTitle(a.doc_props), getSortableTitle(b.doc_props))
        end, my_cache
    end,

    mandatory_func = function(item)
        return CustomSorting.formatInfo(item, "last_first")
    end,
}

return BookList.collates
