# /etc/profile

# Manage the read/write/execute permissions that are masked out (i.e.
# restricted) for newly created files by the user.
umask 022

# Load profiles from /etc/profile.d
if test -d /etc/profile.d/; then
    for profile in /etc/profile.d/*.sh; do
        test -r "$profile" && . "$profile"
    done
    unset profile
fi

# Source global bash config, when interactive but not posix or sh mode
if test "$BASH" &&\
   test "$PS1" &&\
   test -z "$POSIXLY_CORRECT" &&\
   test "${0#-}" != sh &&\
   test -r /etc/bash/bashrc
then
    . /etc/bash/bashrc
fi

# Termcap is outdated, old, and crusty, kill it.
unset TERMCAP

# Man is much better than us at figuring this out
unset MANPATH

################################################################################
# Custom XDG directories.
################################################################################

# Where user-specific configurations should be written (analogous to /etc).
export XDG_CONFIG_HOME="$HOME/.config"

# Where user-specific non-essential (cached) data should be written (analogous
# to /var/cache).
export XDG_CACHE_HOME="$HOME/.cache"

# Where user-specific data files should be written (analogous to /usr/share).
export XDG_DATA_HOME="$HOME/.local/share"

# Where user-specific state files should be written (analogous to /var/lib).
export XDG_STATE_HOME="$HOME/.local/state"

# Used for non-essential, user-specific data files such as sockets, named
# pipes, etc.
export XDG_RUNTIME_DIR="/run/user/$UID"

################################################################################
# XDG-Ninja
################################################################################

# [ruby bundler]: $HOME/.bundle
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

# [bash]: ${HOME}/.bash_history
export HISTFILE="$XDG_STATE_HOME/bash/history"

# [cargo]: $HOME/.cargo
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# [gnupg]: $HOME/.gnupg
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# [gnu-screen]: $HOME/.screenrc
export SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"

# [gtk-2]: $HOME/.gtkrc-2.0
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# [kde]: $HOME/.kde4
export KDEHOME="$XDG_CONFIG_HOME/kde"

# [less]: ${HOME}/.lesshst
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"

# [most]: $HOME/.mostrc
export MOST_INITFILE="$XDG_CONFIG_HOME/mostrc"

# [nodejs]: $HOME/.node_repl_history
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

# [pass]: $HOME/.password-store
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"

# [texmf]: $HOME/.texlive/texmf-var
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"

################################################################################
# Custom exports.
################################################################################

# For executing Groovy code. Find JAVA_HOME by using the following command:
# java -XshowSettings:properties 2>&1 | grep java.home | xargs | cut -d' ' -f3
export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'

################################################################################
# Custom paths.
################################################################################

# Append "$1" to $PATH when not already in.
# This function API is accessible to scripts in /etc/profile.d
append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

# Append our default paths
append_path '/usr/local/sbin'
append_path '/usr/local/bin'
append_path '/usr/bin'

# Make Python modules executable. Needed by cppman.
append_path "$HOME/.local/bin"

# Make Ruby gems executable. Needed by Jekyll.
append_path "$XDG_DATA_HOME/gem/ruby/3.0.0/bin"

# Make Rust crates executable. Needed by wasm-bindgen.
append_path "$CARGO_HOME/bin"

# Add Mason server directory for Neovim.
append_path "$HOME/.local/share/nvim/mason/bin"

# Unload our profile API functions
unset -f append_path

# Force PATH to be environment
export PATH

