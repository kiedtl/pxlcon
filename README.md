<h3 align="center"><img src="https://lptstr.github.io/lptstr-images/proj/pxlcon/logo.png" height="150px"></h3>
<p align="center">A [WIP] cross-platform pixel art editor for the terminal.</p>

<p align="center">
    <img alt="GitHub code size in bytes" src="https://img.shields.io/github/languages/code-size/lptstr/pxlcon.svg">
    <a href="https://www.codacy.com/app/lptstr/pxlcon?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=lptstr/pxlcon&amp;utm_campaign=Badge_Grade">
        <img src="https://api.codacy.com/project/badge/Grade/1bd99c5bb57b4e86867579ccb9c72eed"/>
    </a>
    <img alt="GitHub" src="https://img.shields.io/github/license/lptstr/pxlcon.svg">
</p>

<img src="https://lptstr.github.io/lptstr-images/screenshots/projects/pxlcon/screenshot.png" alt="pxlcon" align="right"
width="51%">

Pxlcon is an tiny pixel art editor for the terminal, which you control with the keyboard instead of the mouse. It is a port of `pxltrm` to PowerShell, aiming for full cross-platform compatibility.

- **Lightweight** (less than 1.38 KB)
- **RGB color support** (for true-color terminals)
- Ability to write projects to a file.
- View pixel art in the terminal with `cat`.

**Note:** This project is currently WIP. If you break it or want a feature, file an issue!


## Requirements

- PowerShell 5 (or later)
- .NET 4.5 (or later)
- True-color terminal (optional)


## Installation
### Windows
- Use [Scoop](https://scoop.sh).
    ```
    scoop bucket add lptstr https://github.com/lptstr/lptstr-scoop
    scoop install pxlcon
    ```

### macOS/Linux
- Move `pxlcon.ps1` somewhere in your `$PATH`.


## TODO

- [ ] Implement undo/redo feature.
- [ ] Test on *nix systems and macOS.
- [ ] Implement color palette.

## Inspiration
- [pxltrm](https://github.com/dylanaraps/pxltrm)

