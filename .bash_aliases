# git setup

git config push.autoSetupRemote true

# gpg setup

[[ ! -z $GNUPG_KEY  ]] &&
      gpg --quiet --batch --import <(echo $GNUPG_KEY|base64 -d) &&
      echo 'pinentry-mode loopback' >> ~/.gnupg/gpg.conf &&
      git config --global user.signingkey 0EBC54F6EDC08015 &&
      git config commit.gpgsign true
      
[[ ! -z $EXTENDA_NEXUS_TOKEN  ]] && (
    npm list -g @hiiretail/nest-app-cli &> /dev/null ||
    npm i -g @hiiretail/nest-app-cli
)

echo 1 | gpg -s --pinentry-mode=loopback --passphrase $GNUPG_PASS > /dev/null
