#!/bin/sh

. "$HOME/.bashrc.d/sources.sh"
. "$HOME/.bashrc.d/functions.sh"

# Make sure the sources.sh are loaded first.
# Otherwise some packages won't be found.
. "$HOME/.bashrc.d/aliases.sh"

export EDITOR=nvim
