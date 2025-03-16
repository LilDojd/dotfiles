# First, as part of mamba's configuration, some complete would have been defined
# Let's erase them, so that we start from a blank state
complete -c mamba -e

function __fish_mamba_subcommand
    # This function does triple-duty:
    # If called without arguments, it will print the first subcommand.
    # If one exists, it returns false.
    # If it doesn't, it returns true.
    #
    # If called with arguments, it will check that those match the given subcommands,
    # and that there are no additional subcommands.
    set -l subcmds $argv
    set -q subcmds[1]
    set -l have_sub $status

    # get the commandline args without the "mamba"
    set -l toks (commandline -xpc)[2..-1]

    # Remove any important options - if we had options with arguments,
    # they'd need to be listed here to be removed.
    argparse -i h/help v/version -- $toks 2>/dev/null
    # Return false if it fails - this shouldn't really happen,
    # so all bets are off
    or return 2

    # Remove all matching subcommands
    while set -q subcmds[1]
        # If the subcommand matches, or we have an option, go on.
        # (if the option took an argument we wouldn't know,
        #  so it needs to be argparse'd out above!)
        if test "$subcmds[1]" = "$argv[1]"
            set -e argv[1]
            set -e subcmds[1]
        else if string match -q -- '-*' $argv[1]
            set -e argv[1]
        else
            return 1
        end
    end

    # Skip any remaining options.
    while string match -q -- '-*' $argv[1]
        set -e argv[1]
    end

    # If we have no subcommand left,
    # we either matched all given subcommands or we need one.
    if not set -q argv[1]
        return $have_sub
    end

    echo -- $argv[1]

    # If we didn't have subcommands to check, return true
    # If we did, this is an additional command and so we return false.
    not test $have_sub -eq 0
end

function __fish_mamba -a cmd
    complete -c mamba -n "contains -- (__fish_mamba_subcommand) $cmd" $argv[2..-1]
end

# Complete for the first argument only
function __fish_mamba_top
    complete -c mamba -n 'not __fish_mamba_subcommand' $argv
end

function __fish_mamba_config_keys
    mamba config --show | string match -r '^\w+(?=:)'
end

function __fish_mamba_environments
    mamba env list | string match -rv '^#' | string match -r '^\S+'
end

# common options
complete -c mamba -f
complete -c mamba -s h -l help -d "Show help and exit"

# top-level options
__fish_mamba_top -s V -l version -d "Show the mamba version number and exit"

# top-level commands
__fish_mamba_top -a clean -d "Remove unused packages and caches"
__fish_mamba_top -a config -d "Modify configuration values in .mambarc"
__fish_mamba_top -a create -d "Create a new mamba environment from a list of specified packages"
__fish_mamba_top -a help -d "Displays a list of available mamba commands and their help strings"
__fish_mamba_top -a info -d "Display information about current mamba install"
__fish_mamba_top -a install -d "Installs a list of packages into a specified mamba environment"
__fish_mamba_top -a list -d "List linked packages in a mamba environment"
__fish_mamba_top -a package -d "Low-level mamba package utility (EXPERIMENTAL)"
__fish_mamba_top -a remove -d "Remove a list of packages from a specified mamba environment"
__fish_mamba_top -a uninstall -d "Alias for mamba remove"
__fish_mamba_top -a search -d "Search for packages and display associated information"
__fish_mamba_top -a update -d "Updates mamba packages to the latest compatible version"
__fish_mamba_top -a upgrade -d "Alias for mamba update"

# command added by sourcing ~/minimamba3/etc/fish/conf.d/mamba.fish,
# which is the recommended way to use mamba with fish
__fish_mamba_top -a activate -d "Activate the given environment"
__fish_mamba activate -x -a "(__fish_mamba_environments)"
__fish_mamba_top -a deactivate -d "Deactivate current environment, reactivating the previous one"

# common to all top-level commands

set -l __fish_mamba_commands clean config create help info install list package remove uninstall search update upgrade
for cmd in $__fish_mamba_commands
    __fish_mamba $cmd -l json -d "Report all output as json"
    __fish_mamba $cmd -l debug -d "Show debug output"
    __fish_mamba $cmd -l verbose -s v -d "Use once for info, twice for debug, three times for trace"
end

# 'clean' command
__fish_mamba clean -s y -l yes -d "Do not ask for confirmation"
__fish_mamba clean -l dry-run -d "Only display what would have been done"
__fish_mamba clean -s q -l quiet -d "Do not display progress bar"
__fish_mamba clean -s a -l all -d "Remove all: same as -iltps"
__fish_mamba clean -s i -l index-cache -d "Remove index cache"
__fish_mamba clean -s l -l lock -d "Remove all mamba lock files"
__fish_mamba clean -s t -l tarballs -d "Remove cached package tarballs"
__fish_mamba clean -s p -l packages -d "Remove unused cached packages (no check for symlinks)"
__fish_mamba clean -s s -l source-cache -d "Remove files from the source cache of mamba build"

# 'config' command

__fish_mamba config -l system -d "Write to the system .mambarc file"
__fish_mamba config -l env -d "Write to the active mamba environment .mambarc file"
__fish_mamba config -l file -d "Write to the given file" -F
__fish_mamba config -l show -x -a "(__fish_mamba_config_keys)" -d "Display configuration values"
__fish_mamba config -l show-sources -d "Display all identified configuration sources"
__fish_mamba config -l validate -d "Validate all configuration sources"
__fish_mamba config -l describe -x -a "(__fish_mamba_config_keys)" -d "Describe configuration parameters"
__fish_mamba config -l write-default -d "Write the default configuration to a file"
__fish_mamba config -l get -x -a "(__fish_mamba_config_keys)" -d "Get a configuration value"
__fish_mamba config -l append -d "Add one configuration value to the end of a list key"
__fish_mamba config -l prepend -d "Add one configuration value to the beginning of a list key"
__fish_mamba config -l add -d "Alias for --prepend"
__fish_mamba config -l set -x -a "(__fish_mamba_config_keys)" -d "Set a boolean or string key"
__fish_mamba config -l remove -x -a "(__fish_mamba_config_keys)" -d "Remove a configuration value from a list key"
__fish_mamba config -l remove-key -x -a "(__fish_mamba_config_keys)" -d "Remove a configuration key (and all its values)"
__fish_mamba config -l stdin -d "Apply configuration given in yaml format from stdin"

# 'help' command
__fish_mamba help -d "Displays a list of available mamba commands and their help strings"
__fish_mamba help -x -a "$__fish_mamba_commands"

# 'info' command
__fish_mamba info -l offline -d "Offline mode, don't connect to the Internet."
__fish_mamba info -s a -l all -d "Show all information, (environments, license, and system information)"
__fish_mamba info -s e -l envs -d "List all known mamba environments"
__fish_mamba info -s l -l license -d "Display information about the local mamba licenses list"
__fish_mamba info -s s -l system -d "List environment variables"
__fish_mamba info -l base -d "Display base environment path"
__fish_mamba info -l unsafe-channels -d "Display list of channels with tokens exposed"

# The remaining commands share many options, so the definitions are written the other way around:
# the outer loop is on the options

# Option channel
for cmd in create install remove search update
    __fish_mamba $cmd -s c -l channel -d 'Additional channel to search for packages'
end

# Option channel-priority
for cmd in create install update
    __fish_mamba $cmd -l channel-priority -d 'Channel priority takes precedence over package version'
end

# Option clobber
for cmd in create install update
    __fish_mamba $cmd -l clobber -d 'Allow clobbering of overlapping file paths (no warnings)'
end

# Option clone
__fish_mamba create -l clone -x -a "(__fish_mamba_environments)" -d "Path to (or name of) existing local environment"

# Option copy
for cmd in create install update
    __fish_mamba $cmd -l copy -d 'Install all packages using copies instead of hard- or soft-linking'
end

# Option download-only
for cmd in create install update
    __fish_mamba $cmd -l download-only -d 'Solve an environment: populate caches but no linking/unlinking into prefix'
end

# Option dry-run
for cmd in create install remove update
    __fish_mamba $cmd -l dry-run -d 'Only display what would have been done'
end

# Option file
for cmd in create install update
    __fish_mamba $cmd -l file -d 'Read package versions from the given file' -F
end

# Option force
for cmd in create install remove update
    __fish_mamba $cmd -l force -d 'Force install (even when package already installed)'
end

# Option insecure
for cmd in create install remove search update
    __fish_mamba $cmd -l insecure -d 'Allow mamba to perform "insecure" SSL connections and transfers'
end

# Option mkdir
for cmd in create install update
    __fish_mamba $cmd -l mkdir -d 'Create the environment directory if necessary'
end

# Option name
__fish_mamba create -s n -l name -d "Name of new environment"
for cmd in install list remove search update
    __fish_mamba $cmd -s n -l name -x -a "(__fish_mamba_environments)" -d "Name of existing environment"
end

# Option no-channel-priority
for cmd in create install update
    __fish_mamba $cmd -l no-channel-priority -l no-channel-pri -l no-chan-pri -d 'Package version takes precedence over channel priority'
end

# Option no-default-packages
__fish_mamba create -l no-default-packages -d 'Ignore create_default_packages in the .mambarc file'

# Option no-deps
for cmd in create install update
    __fish_mamba $cmd -l no-deps -d 'Do not install, update, remove, or change dependencies'
end

# Option no-pin
for cmd in create install remove update
    __fish_mamba $cmd -l no-pin -d 'Ignore pinned file'
end

# Option no-show-channel-urls
for cmd in create install list update
    __fish_mamba $cmd -l no-show-channel-urls -d "Don't show channel urls"
end

# Option no-update-dependencies
for cmd in create install update
    __fish_mamba $cmd -l no-update-dependencies -l no-update-deps -d "Don't update dependencies"
end

# Option offline
for cmd in create install remove search update
    __fish_mamba $cmd -l offline -d "Offline mode, don't connect to the Internet"
end

# Option only-deps
for cmd in create install update
    __fish_mamba $cmd -l only-deps -d "Only install dependencies"
end

# Option override-channels
for cmd in create install remove search update
    __fish_mamba $cmd -l override-channels -d "Do not search default or .mambarc channels"
end

# Option prefix
for cmd in create install list remove search update
    __fish_mamba $cmd -s p -l prefix -d "Full path to environment prefix"
end

# Option quiet
for cmd in create install remove update
    __fish_mamba $cmd -s q -l quiet -d "Do not display progress bar"
end

# Option show-channel-urls
for cmd in create install list update
    __fish_mamba $cmd -l show-channel-urls -d "Show channel urls"
end

# Option update-dependencies
for cmd in create install update
    __fish_mamba $cmd -l update-dependencies -l update-deps -d "Update dependencies"
end

# Option use-index-cache
for cmd in create install remove search update
    __fish_mamba $cmd -s C -l use-index-cache -d "Use cache of channel index files, even if it has expired"
end

# Option use-local
for cmd in create install remove search update
    __fish_mamba $cmd -l use-local -d "Use locally built packages"
end

# Option yes
for cmd in create install remove update
    __fish_mamba $cmd -s y -l yes -d "Do not ask for confirmation"
end

# Option revision
__fish_mamba install -l revision -d "Revert to the specified REVISION"

# Option canonical
__fish_mamba list -s c -l canonical -d "Output canonical names of packages only. Implies --no-pip"

# Option explicit
__fish_mamba list -l explicit -d "List explicitly all installed mamba with URL (output usable by mamba create --file)"

# Option export
__fish_mamba list -s e -l export -d "Output requirement string only (output usable by mamba create --file)"

# Option full-name
__fish_mamba list -s f -l full-name -d "Only search for full names, i.e., ^<regex>\$"

# Option md5
__fish_mamba list -l md5 -d "Add MD5 hashsum when using --explicit"

# Option no-pip
__fish_mamba list -s c -l canonical -d "Output canonical names of packages only. Implies --no-pip"

# Option revisions
__fish_mamba list -s r -l revisions -d "List the revision history and exit"

# Option all
__fish_mamba remove -l all -d "Remove all packages, i.e., the entire environment"
__fish_mamba update -l all -d "Update all installed packages in the environment"

# Option features
__fish_mamba remove -l features -d "Remove features (instead of packages)"

# Option info
__fish_mamba search -s i -l info -d "Provide detailed information about each package"

# Option platform
set -l __fish_mamba_platforms {osx,linux,win}-{32,64}
__fish_mamba search -l platform -x -a "$__fish_mamba_platforms" -d "Search the given platform"

# Option reverse-dependency
__fish_mamba search -l reverse-dependency -d "Perform a reverse dependency search"

__fish_mamba_top -a env -d "mamba options for environments"
complete -c mamba -n "__fish_mamba_subcommand env" -a create -d "Create a new environment"
complete -c mamba -n "__fish_mamba_subcommand env" -a list -d "List all mamba environments"
complete -c mamba -n "__fish_mamba_subcommand env create" -s f -l file -rF -d "Create environment from yaml file"
