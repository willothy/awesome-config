# Welcome, stranger!

This is my awful configuration for the almighty AwesomeWM, featuring a 
user configuration file, repositionable bar and titles, dashboard,
notifications, screenshooting tools, multiple colorschemes, and more to
come, all done with Awesome's widget API!

![Display](./screenshot.png)

## Dependencies

### Mandatory
- Awesome-git (duh)
- mpd, mpDris2, and playerctl
- Network Manager
- Pipewire and Wireplumber
- Roboto, Material Icons, and CascadiaCode Nerd Font
- xclip

### Optional (toggleable)
- brightnessctl
- bluez and bluez-utils
- upower

----------------------
This configuration also uses alacritty, nvim, firefox, htop, lf, thunar, 
xclip and rofi by default, but none of these are hard requirements and 
you can easily change them in `userconf.lua`, although I still 
recommend **at least installing alacritty**.

## Installation

Install the dependencies listed above for your own distro. After that is
done you need only run:
```sh
$ git clone https://github.com/Gwynsav/gwdawful.git --recursive
$ mkdir ~/.config/awesome/
$ cp -r gwdawful/* ~/.config/awesome/
```
Also note that CascadiaCode Nerd Font is very likely not packaged for your
distro. It can easily be installed by [getting it](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/CascadiaCode.zip), 
putting it in either `/usr/share/fonts` or `~/.local/share/fonts/` and 
running `fc-cache -f`.

And that is basically it, note that I do not provide configuration files 
for the programs used by default, this is because those are written in Nix
for my [NixOS rice](https://github.com/Gwynsav/nix-dots/tree/master/users/gw/config). 
You may still use them as reference but they don't exactly work if you're
not using Nix with Home Manager as is.

## Usage
### Basic Keybinds
| Keybind           | Description                 |
| ----------------- | --------------------------- |
| `mod + Shift + w` | Opens the keybindings menu. |
| `mod + Return`    | Opens a terminal.           |

That should be enough for you to access both the configuration and keybinds
menu and see all the other stuff.

### Simple Configuration
You can edit some basic stuff by using the included variables inside of
`userconf.lua`. This configuration includes, border size, gaps, titles and
bar positions, as well as toggling features.

<details>
| Variable       | Type      | Description                        |
| -------------- | --------- | ---------------------------------- |
| Applications   | -         | -                                  |
| `terminal`     | `string`  | Terminal emulator to use           |
| `editor`       | `string`  | Text editor to use                 |
| `browser`      | `string`  | Internet browser to use            |
| `top`          | `string`  | top application (like htop) to use |
| `files_cli`    | `string`  | CLI file explorer to use           |
| `files_gui`    | `string`  | GUI file explorer to use           |
| `app_launcher` | `string`  | Application launcher (may deprecate) |
| Settings       | -         | -                                  |
| `modkey`       | `string`  | Mod1 is Alt, Mod4 is Super         |
| `hover_focus`  | `boolean` | Should windows be focused on hover |
| `battery`      | `boolean` | Enable/disable battery metrics     |
| `brightness`   | `boolean` | Enable/disable brightness metrics  |
| `bluetoothctl` | `boolean` | Enable/disable bluetooth metrics   |
| UI             | -         | -                                  |
| `scaling`      | `number`  | Your vertical resolution, eg 1080p |
| `aspect_ratio` | `number`  | Your aspect ratio, eg 16/9 or 4/3  |
| `inner_gaps`   | `number`  | Regular gap size                   |
| `outer_gaps`   | `number`  | Screen padding size                |
| `border_size`  | `number`  | Size of client and widget borders  |
| `border_rad`   | `number`  | Border rounding, 0 to disable      |
| `bar_enabled`  | `boolean` | Change default bar state.          |
| `bar_size`     | `number`  | Change bar thickness               |
| `bar_pos`      | `string`  | May be: left, top, right, bottom   |
| `bar_gap`      | `boolean` | Apply outer_gaps to bar            |
| `title_enable` | `boolean` | Enable/disable client titlebars    |
| `titles_size`  | `number`  | Change titlebar thickness          |
| `titles_pos`   | `string`  | May be: left, top, right, bottom   |
| `notif_size`   | `number`  | Change notification size           |
| `notif_pos`    | `string`  | May be: top_left, top_right, bottom_left, bottom_right |
| Theming        | -         | -                                  |
| `clr_palette`  | `string`  | catppuccin, decay, everblush, everforest, tokyonight |
| `ui_font`      | `string`  | Name of main UI font. Does **NOT** take size. |
| `ic_font`      | `string`  | Name of text icon font. Does **NOT** take size. |
| `mn_font`      | `string`  | Name of monospace font. Does **NOT** take size. |
| `user_avatar`  | `string`  | "default" follows colorscheme, or path |
| `user_wall`    | `string`  | "default" follows colorscheme, or path |
| `player_bg`    | `string`  | "default" follows colorscheme, or path |
| `awm_icon`     | `string`  | "default", "nix", or path |
| `scrnshot_dir` | `string`  | Directory to save screenshots to   |
</details>

# References
These people's dotfiles (and in some cases they themselves) have massively
helped me create this configuration.

[Alpha.'s NixOS Awesome setup](https://github.com/AlphaTechnolog/nixdots). 
General reference and stole his helpers :)

[Stardust-kyun's dotfiles](https://github.com/Stardust-kyun/dotfiles). 
Basically the first thing I started reading when I got into Awesome.

[Aproxia's dotfiles](https://github.com/Aproxia-dev/.dotfiles). 
Funny animation ghost.

Also got a few ideas from [elenapan's dotfiles](https://github.com/elenapan/dotfiles) 
and [rxyhn's Yoru](https://github.com/rxyhn/yoru).
