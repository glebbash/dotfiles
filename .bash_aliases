if [[ -f .nvmrc ]]; then
  nvm install
  npx -y google-artifactregistry-auth
  npm i -g @hiiretail/nest-app-cli
fi
