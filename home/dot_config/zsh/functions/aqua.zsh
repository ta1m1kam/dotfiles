# aqua policy auto-allow on directory change

function _aqua_auto_policy_allow() {
  local policy_file="$PWD/aqua-policy.yaml"
  if [[ -f "$policy_file" ]]; then
    aqua policy allow "$policy_file" > /dev/null 2>&1
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _aqua_auto_policy_allow
