# fzf + Git functions

function gb() {
  local branch
  branch=$(git branch -a --sort=-committerdate | \
    fzf --preview 'git log --oneline --graph --color=always {1} | head -50' | \
    sed 's/^[* ]*//' | sed 's/remotes\/origin\///')
  if [[ -n "$branch" ]]; then
    git checkout "$branch"
  fi
}

function gshow() {
  local commit
  commit=$(git log --oneline --graph --color=always | \
    fzf --ansi --preview 'echo {} | cut -d" " -f2 | xargs git show --color=always' | \
    awk '{print $2}')
  if [[ -n "$commit" ]]; then
    git show "$commit"
  fi
}

function gcp() {
  local commit
  commit=$(git log --oneline --all --graph --color=always | \
    fzf --ansi --preview 'echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs git show --color=always' | \
    grep -o "[a-f0-9]\{7\}" | head -1)
  if [[ -n "$commit" ]]; then
    git cherry-pick "$commit"
  fi
}

function gstash() {
  local stash
  stash=$(git stash list | \
    fzf --preview 'echo {} | cut -d: -f1 | xargs git stash show -p --color=always' | \
    cut -d: -f1)
  if [[ -n "$stash" ]]; then
    git stash apply "$stash"
  fi
}

function gadd() {
  local files
  files=$(git status -s | \
    fzf -m --preview 'echo {} | awk "{print \$2}" | xargs git diff --color=always' | \
    awk '{print $2}')
  if [[ -n "$files" ]]; then
    echo "$files" | xargs git add
    git status -s
  fi
}

# gh (GitHub CLI) + fzf functions

function gpr() {
  local pr
  pr=$(gh pr list --limit 50 | \
    fzf --preview 'echo {} | awk "{print \$1}" | xargs gh pr view' | \
    awk '{print $1}')
  if [[ -n "$pr" ]]; then
    gh pr checkout "$pr"
  fi
}

function gprv() {
  local pr
  pr=$(gh pr list --limit 50 --state all | \
    fzf --preview 'echo {} | awk "{print \$1}" | xargs gh pr view' | \
    awk '{print $1}')
  if [[ -n "$pr" ]]; then
    gh pr view "$pr" --web
  fi
}

function gis() {
  local issue
  issue=$(gh issue list --limit 50 | \
    fzf --preview 'echo {} | awk "{print \$1}" | xargs gh issue view' | \
    awk '{print $1}')
  if [[ -n "$issue" ]]; then
    gh issue view "$issue" --web
  fi
}
