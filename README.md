<h3 align="center">
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/logos/exports/1544x1544_circle.png" width="100" alt="Logo"/><br/>
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
	Catppuccin-friendly
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
</h3>

<h6 align="center">
  <a href="http://ipa-reader.xyz/?text=%CB%8Ck%C3%A6tp%CA%8A%CB%88t%CA%83i%CB%90n">/ˌkætpʊˈtʃiːn ˈfɹɛndli/</a>
</h6>

<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="400" />
</p>

![Maintenance](https://img.shields.io/maintenance/yes/2024) ![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg) ![License](https://img.shields.io/github/license/LilDojd/dotfiles)

My **opinionated** dotfiles, featuring a `bspwm` setup based on z0mbi3's config :shipit:

## Preview

<p align="center">
  <img width="1600" alt="Terminal overviw" src="https://github.com/LilDojd/dotfiles/assets/37330594/24ac3e83-4f7c-4146-b81c-d501a93eb9e6">
</p>

<p align="center">
  <img width="1600" alt="Apps" src="https://github.com/LilDojd/dotfiles/assets/37330594/ea6c4407-1d3b-47c6-9e6c-52dbcabd6f9e">
</p>

## Features

- **Window Manager**: `bspwm`
- **Terminal Emulators**: Configurations for both `kitty` and `alacritty` are included. Choose what suits you best.
- **Editor**: Custom `AstroNvimV4` conifg
- **Theme**: A soothing pastel theme that extends across terminal and editor for a uniform look.
- **Music**: `MPD`-empowered polybar configured for music management via `Mopidy`, ncmpcpp as a player
- **Prompt**: `starship.toml` taken from hyprland-dots for a sleek terminal prompt.

## Installation (WIP)

1.  Clone the repository and cd to it:

    ```bash
    git clone https://github.com/yourusername/dotfiles.git; cd dotfiles

    ```

2.  Stow everythin to create symlinks pointing to cloned git folder:

        ```bash
        stow .
        ```

    You might also want to install a lot of fonts and icons as specified in the [gh0stzk repo](https://github.com/gh0stzk/dotfiles)

3.  (Optional) For Spotify to work with ncmpcpp, install Mopidy and mopidy-spotify

## Acknowledgments

- gh0stzk (a lot of stuff)
- AstroNvim
- Hyprland (starship.toml)
- dharmx for beautiful ASCII

## Important Notice !!!

- This configuration looks nice in 3840x2160 at 144 DPI with a single monitor, other configurations might need tweaking
- `cpuusage` binary in bspwm scripts is pre-built for x86_64, you might want to rebuild id based on your system configuration from .scripts
