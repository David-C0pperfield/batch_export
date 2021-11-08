# About Translation

## How to use the translation utilities

### On Windows

#### 1. Adding .ts files

1. Open `1-lupdate.cmd` in editer. (e.g, VSCode or Notepad, etc.)
2. Append your new file name to the end of first line, in the format **locale_**_language-code_**.ts** (e.g, locale_de, local_zh-cn, etc.).
3. Run the command file in cmd.
4. You will find the new file in the same location as the `1-lupdate.cmd`.

#### 2.Generating / Updating .qm files

Just run the command file in cmd.

### On Linux / macOS

Use the `translation_utility.sh`.

This is a 2-in-1 utility, which will enables you to process `.ts` and `.qm` files in an effcient way.

Double click on `translation_utility.sh`. The instructions are shown inside the shell.

## Acknowledgement

### Translations

This plugin now comes with translations of the dialogs into German, French (thanks to lasconic), Spanish (thanks to jorgk), Italian (thanks to Shoichi) and Simplified Chinese (thanks to David Copperfield), for all other language settings in MuseScore, it remains English. More translations are welcome, just contact us for including them.
