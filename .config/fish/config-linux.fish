abbr -a mirrors "sudo reflector --verbose --latest 5 --country 'United Arab Emirates' --age 6 --sort rate --save /etc/pacman.d/mirrorlist"
abbr -a fm yazi
abbr -a ya yazi
abbr -a yays "yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | awk \"{print \$2}\")' | xargs -ro yay -S"
abbr -a pacr "pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
abbr -a p "pacman -Q | fzf"
