#!/bin/bash

main() {
    if [ -f ".env" ]; then
        source .env
    fi

    aliases_setup || (echo "aliases_setup job failed and exited" && exit 1)
    git_setup || (echo "git_setup job failed and exited" && exit 1)
    curl -fsSL https://deno.land/install.sh | sh -s -- -y
}

aliases_setup() {
    echo "Setting up bash aliases"

    cp "${HOME}/.dotfiles/.bash_aliases" "${HOME}/.bash_aliases"
}

git_setup() {
    echo "Setting up Git"

    git config --global push.autoSetupRemote true

    echo "Git: Use rebase to pull"
    git config --global pull.rebase false

    if [ -n "${GPG_PRIVATE_KEY_BASE64:-}" ]; then
        echo "Git: Installing GPG key"
        gpg --verbose --batch --import <(echo "${GPG_PRIVATE_KEY_BASE64}" | base64 -d)
        echo 'pinentry-mode loopback' >> ~/.gnupg/gpg.conf
        git config --global user.signingkey "${GPG_SIGNING_KEY}"
        git config --global commit.gpgsign true
        git config --global tag.gpgsign true
    fi
}

main "$@"
