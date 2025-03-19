# MacOS specific config

set brewcmd (path filter /opt/homebrew/bin/brew /usr/local/bin/brew)[1]
and $brewcmd shellenv | source

fish_add_path /opt/homebrew/opt/llvm/bin
# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
