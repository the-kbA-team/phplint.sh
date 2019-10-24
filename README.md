# phplint.sh

This script checks the PHP files of the given directories for syntax errors.

Usage: `phplint.sh [options] <directory> [<directory> ...]`

**Parameters:**
* `<directory>`  The directory/directories to search for PHP files.

**Options:**
* `-e <ext>` | `--extension <ext>`  Define PHP files extension other than *.php to lint.
* `-v | --verbose` Print positive lint results too.
* `-h | --help` Show this help.

## Composer usage

Include this package using composer.

```bash
composer require kba-team/phplint.sh: "~1.0"
```
