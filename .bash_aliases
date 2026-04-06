main() {
  if [[ -f .nvmrc ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    echo ".nvmrc found, loading env..."
    
    cmd nvm install
    
    clear
  fi
}

cmd() {
  local log_file="/tmp/cmd_error_$$.log"
  
  if ! "$@" &> "$log_file"; then
    clear
    echo "Error: ${*} failed:"
    cat "$log_file"
    rm -f "$log_file"
    return 1
  fi
  rm -f "$log_file"
  return 0
}

main
