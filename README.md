# koreader-patches
Repository for various KOReader Patches

## Filebrowser Sorting By Author and Series (Project Title  users)
> **Warning:** Multi‑author books will cause KOReader to crash. 

Modified Patch: See Original [permalink](https://github.com/chiahsien/KOReader.Patches/tree/3ae7a8f53c41ec4e4ab322da06406ca2723e274d/2-sort-by-author-series)

### Choose One:

#### Pure Title + Pure Series
##### [2-sort-by-author-title-series.lua](https://github.com/nightcodexcat/koreader.patches/blob/34b7ab689bf3ad5769c10189664850de1973db01/2-sort-by-author-title-series.lua)

**Uses the book’s Title and Series fields as-is. No article stripping.  
Series and standalone books are merged alphabetically under each author.**


#### TitleSort + Pure Series

##### [2-sort-by-author-titlesort-series.lua](https://github.com/nightcodexcat/koreader.patches/blob/399157eae8b13b9c27133d9c79140f2931ed2401/2-sort-by-author-titlesort-series.lua)

**Uses Calibre TitleSort when available. Series names are left unchanged.  
Series and standalone books are merged alphabetically under each author.**

#### TitleSort + SeriesSort

##### [2-sort-by-author-titlesort-seriessort.lua](https://github.com/nightcodexcat/koreader.patches/blob/99bcfb3a6bc40a9f7fb1368384db8caa89a486dd/2-sort-by-author-titlesort-seriessort.lua)

**Uses Calibre TitleSort and a normalized SeriesSort. Leading articles (“The”, “An”, “A”) are removed from titles and series names when comparing books by the same author.**

Example:  
* Alix E. Harrow – The Everlasting  
* Alix E. Harrow – A Spindle Splintered (Fractured Fables #1)

sort as:
* Everlasting, The
* A Spindle Splintered (Fractured Fables #1)


> **Warning:** Multi‑author books will cause KOReader to crash.

These patches adds the following sort options:

The alphabetical sorting mixes both standalone books and series books,
rather than listing all series alphabetically first and all standalones afterward.

* Author (First Last) – Alphabetical
* Author (Last First) – Alphabetical
* Author (First Last) – Alphabetical – Published Date
* Author (Last First) – Alphabetical – Published Date

## File Manager Behavior Patches (Project Title Users)

These patches modify KOReader’s FileChooser and FileManager behavior. They were created and tested with the Project Title plugin enabled on a Kobo Clara BW (2024) running KOReader v2025.10.

### [2-disable-tap-open-files-pt.lua](https://github.com/nightcodexcat/koreader.patches/blob/34b7ab689bf3ad5769c10189664850de1973db01/2-disable-tap-open-files-pt.lua)

Disables single‑tap opening of files in the FileChooser.

Intended for:  
* Project Title users
* Not tested with the stock File Browser

What it changes:  
* Tapping folders still navigates normally
* Tapping files does nothing
* Long‑press on files still opens the action menu
* Select‑mode toggling continues to work normally

### [2-add-open-to-longpress-menu-pt.lua](https://github.com/nightcodexcat/koreader.patches/blob/34b7ab689bf3ad5769c10189664850de1973db01/2-add-open-to-longpress-menu-pt.lua)
Adds a direct Open option to the long‑press menu for files.


#### Intended for:  
* Project Title users
* Not tested with the stock File Browser

#### What it changes:  
* Adds a new Open button in the long‑press dialog
* Immediate opening of the file with the default engine
* No need to use "Open With" unless desired


## Compatibility Notes

These patches have been tested on the Kobo Clara BW (2024)  
running KOReader v2025.10 with Project Title enabled.  
Behavior in the default File Browser is not guaranteed.


## Installation
Download the desired lua patch file

Place Patch files in:
```text
koreader/patches/
```

You may need to create the "patches" folder if it does not already exist.

For more information on KOReader patches please visit:

https://github.com/koreader/koreader/wiki/User-patches