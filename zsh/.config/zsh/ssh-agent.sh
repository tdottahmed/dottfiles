#!/usr/bin/env bash
# Starts an ssh-agent and loads the default key, if there is one.

SSH_KEY="$HOME/.ssh/default"

if [ -z "${SSH_AUTH_SOCK:-}" ]; then
    eval "$(ssh-agent -s)" >/dev/null 2>&1
fi

if [ -f "$SSH_KEY" ]; then
    chmod 600 "$SSH_KEY"
    ssh-add -l 2>/dev/null | grep -q "$SSH_KEY" || ssh-add "$SSH_KEY" >/dev/null 2>&1
fi
