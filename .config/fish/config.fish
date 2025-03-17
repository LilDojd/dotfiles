set fish_greeting ""

set -gx EDITOR hx
set -gx VISUAL $EDITOR
set -gx TERMINAL ghostty

# Set to true to use ESP toolchain
set -q ESP_RS || set -gx ESP_RS false
set -q LS_AFTER_CD || set -gx LS_AFTER_CD true

# show directory listing on directory change
function __ls_after_cd__on_variable_pwd --on-variable PWD
    if test "$LS_AFTER_CD" = true; and status --is-interactive
        ls -GF
    end
end

fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin

# Variables
set fzf_fd_opts --hidden --max-depth 5

# abbr -aeviations and aliases

if type -q lazyjj
    abbr -a lj lazyjj
end

if type -q lazygit
    abbr -a lg lazygit
end

if type -q eza
    abbr -a ls "eza -G"
    abbr -a ll "eza -l -g --icons"
end

abbr -a la "ll -a"

abbr -a grep "grep --color=auto"
abbr -a mtar "tar -zcvf"
abbr -a utar "tar -zxvf"
abbr -a uz unzip

abbr -a vim nvim

# Verbose mv cp rm
abbr -a mv "mv -v"
abbr -a cp "cp -vr"
abbr -a rm "rm -vr"

if test "$ESP_RS" = true
    fish_add_path $HOME/.rustup/toolchains/esp/xtensa-esp-elf/esp-14.2.0_20240906/xtensa-esp-elf/bin
    set LIBCLANG_PATH $LIBCLANG_PATH/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-18.1.2_20240912/esp-clang/lib
end

# Source platform-specific configurations
switch (uname)
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f $HOME/miniforge3/bin/conda
    eval $HOME/miniforge3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
        . "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "$HOME/miniforge3/bin" $PATH
    end
end
# <<< conda initialize <<<

if status is-interactive
    # Commands to run in interactive sessions can go here

    if test -f "$HOME/.local/bin/colorscript"
        $HOME/.local/bin/colorscript -r
    end
    starship init fish | source
end

function abbr_update_keys_and_values
    __abbr_tips_init
end

abbr_update_keys_and_values
