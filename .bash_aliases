# gpg setup

[[ ! -z $GNUPG_KEY  ]] &&
      gpg --quiet --batch --import <(echo $GNUPG_KEY|base64 -d) &&
      echo 'pinentry-mode loopback' >> ~/.gnupg/gpg.conf &&
      git config --global user.signingkey 0EBC54F6EDC08015 &&
      git config commit.gpgsign true

alias gpg-login='echo 1 | gpg --clearsign > /dev/null'
