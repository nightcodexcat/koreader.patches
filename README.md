# koreader-patches
Repository for various KOReader Patches

## Filebrowser Sorting By Author and Series (Project Title  users)
### [2-sort-by-author-title-series.lua](https://github.com/nightcodexcat/koreader.patches/blob/cd184822b61ae77e35ba85ca72d1f01a9c3f062e/2-sort-by-author-title-series.lua)

Modified Patch: See Original [permalink](https://github.com/chiahsien/KOReader.Patches/tree/3ae7a8f53c41ec4e4ab322da06406ca2723e274d/2-sort-by-author-series)

> **Warning:** Multi‑author books will cause KOReader to crash.

This patch adds the following sort options:

The alphabetical sorting mixes both standalone books and series books,
rather than listing all series alphabetically first and all standalones afterward.

* Author (First Last) – Alphabetical
* Author (Last First) – Alphabetical
* Author (First Last) – Alphabetical – Published Date
* Author (Last First) – Alphabetical – Published Date


## File Manager Behavior Patches (Project Title Users)

These patches modify KOReader’s FileChooser and FileManager behavior. They were created and tested with the Project Title plugin enabled on a Kobo Clara BW (2024) running KOReader v2025.10.

### [2-disable-tap-open-files-pt.lua](https://github.com/mendechris/koreader-patches/blob/e30906e63ecdaac90d80729795e8b3409e768608/2-disable-tap-open-files-pt.lua)

Disables single‑tap opening of files in the FileChooser.

Intended for:  
* Project Title users
* Not tested with the stock File Browser

What it changes:  
* Tapping folders still navigates normally
* Tapping files does nothing
* Long‑press on files still opens the action menu
* Select‑mode toggling continues to work normally

### [2-add-open-to-longpress-menu-pt.lua](https://github.com/mendechris/koreader-patches/blob/e30906e63ecdaac90d80729795e8b3409e768608/2-add-open-to-longpress-menu-pt.lua)
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