#!/bin/bash

main() {
    if [ -f ".env" ]; then
        source .env
    fi

    aliases_setup || (echo "aliases_setup job failed and exited" && exit 1)
    git_setup || (echo "git_setup job failed and exited" && exit 1)
}

aliases_setup() {
    echo "Setting up bash aliases"

    cp "${HOME}/.dotfiles/.bash_aliases" "${HOME}/.bash_aliases"
}

git_setup() {
    echo "Setting up Git"

    set -euo pipefail

    local SECRETS_FILE="./secrets.yaml"

    if ! command -v yq >/dev/null 2>&1; then
        echo "yq is missing"
        exit 1
    fi

    if [[ ! -f "$SECRETS_FILE" ]]; then
        echo "Missing $SECRETS_FILE"
        exit 1
    fi

    mkdir -p ~/.ssh ~/.gnupg
    chmod 700 ~/.ssh ~/.gnupg

    yq -r '.ssh.private_key' "$SECRETS_FILE" > ~/.ssh/id_ed25519
    yq -r '.ssh.public_key' "$SECRETS_FILE" > ~/.ssh/id_ed25519.pub

    chmod 600 ~/.ssh/id_ed25519
    chmod 644 ~/.ssh/id_ed25519.pub

    yq -r '.gpg.private_key' "$SECRETS_FILE" | gpg --import
    yq -r '.gpg.public_key' "$SECRETS_FILE" | gpg --import

    git config --global user.name "$(yq -r '.git.name' "$SECRETS_FILE")"
    git config --global user.email "$(yq -r '.git.email' "$SECRETS_FILE")"
    git config --global user.signingkey "$(yq -r '.gpg.key_id' "$SECRETS_FILE")"
    git config --global commit.gpgsign true
    git config --global push.autoSetupRemote true
    git config --global pull.rebase false

    if [[ -z "${SSH_AUTH_SOCK:-}" ]] || ! ssh-add -l >/dev/null 2>&1; then
        eval "$(ssh-agent -s)" >/dev/null
    fi

    KEY_FPR=$(ssh-keygen -lf ~/.ssh/id_ed25519.pub | awk '{print $2}')
    if ! ssh-add -l 2>/dev/null | grep -q "$KEY_FPR"; then
        ssh-add ~/.ssh/id_ed25519
    fi
}

main "$@"
