typeset -gU prefixes
typeset -gU kde_prefixes

if [[ -o interactive ]]; then
    path=($HOME/bin /usr/local/bin /usr/bin /bin)
    prefixes=()
    kde_prefixes=()
    LD_LIBRARY_PATH=
    RUBYLIB=
    rubylib=()
    PKG_CONFIG_PATH=
    pkg_config_path=()
    RUBYOPT=
fi

if test -z "$RUBY"; then
    RUBY=ruby
fi

if [[ -d $HOME/system/gems ]] && [[ -z "$GEM_HOME" ]]; then
    export GEM_HOME=$HOME/system/gems
fi

if [[ "$DISABLE_GEMS" != "full" ]]; then
    if [[ -n "$GEM_HOME" ]]; then
	path=($GEM_HOME/bin $path)
    fi
    if [[ -d "$HOME/system/rubygems" ]]; then
	prefixes=($prefixes $HOME/system/rubygems)
    fi
fi

if [[ "$DISABLE_GEMS" != "yes" ]] && [[ ! -z "$GEM_HOME" ]]; then
    export RUBYOPT="-r rubygems $RUBYOPT"
fi

if [[ -d $HOME/bin ]]; then
    path=($HOME/bin $path)
fi

# Environment variables for Debian tools
export DEBFULLNAME=""
export DEBEMAIL=""
export EDITOR=vim

export GIT_PAGER=

# Load rehash-prefixes
source $HOME/.zsh/functions/rehash-prefixes
rehash-prefixes

# Set up the various environment variables w.r.t. the presence of RubyGems and
# the ruby version. If the DISABLE_GEMS environment variable is set to "yes",
# prefixes(), path() and GEM_HOME are set but the -r rubygems option is not
# added to RUBYOPT.  If it is set to "full", only GEM_HOME is set.
rubygem_setup() {
    GEM_HOME=$1

    # Update first the various environment variables w.r.t. the current value
    # of prefixes(), since this function's behaviour depends on the ruby
    # version
    rehash-prefixes

    if [[ -d $HOME/system ]]; then
	RUBY_VERSION=${${"$(ruby --version)"##ruby }%% ?200?-??-?? *}
        RUBY_MAJOR_VERSION=${${RUBY_VERSION}%.*}

	# Allow to overwrite GEM_HOME before calling this function
	if [[ -z "$GEM_HOME" ]]; then
            tests=(gems-$RUBY_VERSION gems-$RUBY_MAJOR_VERSION gems)
            for dir in $tests; do
                fulldir=$HOME/system/$dir
                if [[ -d $fulldir ]]; then
                    export GEM_HOME=$fulldir
                    break
                fi
            done
	fi

	# Do not add system/rubygems to the prefixes array if ruby version is
	# >= 1.9
	if [[ -n "$GEM_HOME" ]] && [[ "$DISABLE_GEMS" != "full" ]]; then
            if [[ $RUBY_VERSION =~ '^1\.8.*' ]] && [[ -d $HOME/system/rubygems ]]; then
                prefixes=($prefixes $HOME/system/rubygems)
            fi

	    path=($GEM_HOME/bin $path)
	fi
    fi

    if [[ "$DISABLE_GEMS" != "yes" ]] && [[ ! -z "$GEM_HOME" ]]; then
	export RUBYOPT="-r rubygems $RUBYOPT"
    fi

    rehash-prefixes
}

