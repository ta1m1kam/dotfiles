# =============================================================================
# Git Worktree functions
# =============================================================================

# -----------------------------------------------------------------------------
# Helper functions
# -----------------------------------------------------------------------------

function _gwt_dir() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$root" ]]; then
    dirname "$root"
  fi
}

function _gwt_repo_name() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$root" ]]; then
    basename "$root"
  fi
}

function _gwt_main_branch() {
  if git show-ref --verify --quiet refs/heads/main; then
    echo "main"
  else
    echo "master"
  fi
}

# -----------------------------------------------------------------------------
# Basic operations
# -----------------------------------------------------------------------------

function gwt() {
  local worktree
  worktree=$(gwq list -g 2>/dev/null | \
    fzf --preview '
      cd {} 2>/dev/null && {
        echo "Branch: $(git branch --show-current)"
        echo "Latest: $(git log -1 --format="%h %s")"
        echo "---"
        git status -s | head -20
      }
    ')
  if [[ -n "$worktree" ]]; then
    cd "$worktree"
    zoxide add "$worktree"
  fi
}

function gwta() {
  local branch_name base_branch wt_path

  if ! git rev-parse --show-toplevel &>/dev/null; then
    echo "Not in a git repository"
    return 1
  fi

  base_branch=$(git branch -a --sort=-committerdate | \
    sed 's/^[* ]*//' | \
    fzf --header "Select base branch" \
        --preview 'git log --oneline {} 2>/dev/null | head -20' | \
    sed 's/remotes\/origin\///')
  [[ -z "$base_branch" ]] && return 0

  echo -n "New branch name (empty to checkout existing): "
  read -r branch_name

  if [[ -z "$branch_name" ]]; then
    gwq add "$base_branch"
    wt_path=$(gwq list -g 2>/dev/null | grep "=${base_branch##*/}$" | head -1)
  else
    git fetch origin "$base_branch" 2>/dev/null || true
    git branch "$branch_name" "origin/${base_branch}" 2>/dev/null || \
      git branch "$branch_name" "$base_branch"
    gwq add "$branch_name"
    wt_path=$(gwq list -g 2>/dev/null | grep "=${branch_name//\//-}$" | head -1)
  fi

  if [[ -n "$wt_path" ]]; then
    cd "$wt_path"
    zoxide add "$wt_path"
  fi
}

function gwtr() {
  local worktree
  worktree=$(gwq list -g 2>/dev/null | \
    fzf -m --preview '
      cd {} 2>/dev/null && {
        echo "This worktree will be removed"
        echo "---"
        echo "Branch: $(git branch --show-current)"
        echo "Uncommitted changes:"
        git status -s
      }
    ')

  if [[ -n "$worktree" ]]; then
    echo "$worktree" | while read -r dir; do
      echo "Removing: $dir"
      gwq remove -g "$dir"
      zoxide remove "$dir" 2>/dev/null
    done
  fi
}

function gwts() {
  echo "Git Worktrees"
  echo "---"

  git worktree list | while read -r line; do
    local dir=$(echo "$line" | awk '{print $1}')
    local branch=$(echo "$line" | awk '{print $3}' | tr -d '[]')

    (
      cd "$dir" 2>/dev/null || exit

      local changes=$(git status -s | wc -l | tr -d ' ')
      local status_icon="[ok]"
      [[ "$changes" -gt 0 ]] && status_icon="[*]"

      printf "%s %-35s [%s] %s changes\n" "$status_icon" "$(basename "$dir")" "$branch" "$changes"
    )
  done
}

# -----------------------------------------------------------------------------
# PR/Issue integration
# -----------------------------------------------------------------------------

function gwtpr() {
  local pr pr_number branch_name worktree_path wt_dir repo_name
  wt_dir=$(_gwt_dir)
  repo_name=$(_gwt_repo_name)

  if [[ -z "$wt_dir" ]]; then
    echo "Not in a git repository"
    return 1
  fi

  pr=$(gh pr list --limit 50 | \
    fzf --preview 'echo {} | awk "{print \$1}" | xargs gh pr view')

  if [[ -z "$pr" ]]; then
    return 0
  fi

  pr_number=$(echo "$pr" | awk '{print $1}')
  branch_name=$(gh pr view "$pr_number" --json headRefName -q '.headRefName')
  worktree_path="${wt_dir}/${repo_name}-pr-${pr_number}"

  git fetch origin "pull/${pr_number}/head:${branch_name}" 2>/dev/null || \
    git fetch origin "${branch_name}"

  git worktree add "$worktree_path" "$branch_name"

  if [[ $? -eq 0 ]]; then
    cd "$worktree_path"
    zoxide add "$worktree_path"
    echo "PR #${pr_number} checked out to: $worktree_path"
  fi
}

function gwtfix() {
  local fix_name worktree_path wt_dir main_branch repo_name
  wt_dir=$(_gwt_dir)
  repo_name=$(_gwt_repo_name)

  if [[ -z "$wt_dir" ]]; then
    echo "Not in a git repository"
    return 1
  fi

  echo -n "Hotfix name (e.g., fix-login-bug): "
  read -r fix_name

  if [[ -z "$fix_name" ]]; then
    echo "Hotfix name required"
    return 1
  fi

  main_branch=$(_gwt_main_branch)
  worktree_path="${wt_dir}/${repo_name}-hotfix-${fix_name}"

  git fetch origin "$main_branch"
  git worktree add -b "hotfix/${fix_name}" "$worktree_path" "origin/${main_branch}"

  if [[ $? -eq 0 ]]; then
    cd "$worktree_path"
    zoxide add "$worktree_path"
    echo "Hotfix worktree created: $worktree_path"
  fi
}

# -----------------------------------------------------------------------------
# tmux integration
# -----------------------------------------------------------------------------

function gwtt() {
  local worktree session_name
  worktree=$(git worktree list | \
    fzf --preview '
      dir=$(echo {} | awk "{print \$1}")
      name=$(basename "$dir")
      echo "Worktree: $name"
      echo "---"
      if tmux has-session -t "$name" 2>/dev/null; then
        echo "[tmux session exists]"
        tmux list-windows -t "$name"
      else
        echo "[No tmux session]"
      fi
    ' | awk '{print $1}')

  if [[ -z "$worktree" ]]; then
    return 0
  fi

  session_name=$(basename "$worktree")

  if tmux has-session -t "$session_name" 2>/dev/null; then
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach-session -t "$session_name"
    fi
  else
    tmux new-session -d -s "$session_name" -c "$worktree"
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach-session -t "$session_name"
    fi
  fi
}

# -----------------------------------------------------------------------------
# Claude Code integration
# -----------------------------------------------------------------------------

function gwtc() {
  local worktree
  worktree=$(gwq list -g 2>/dev/null | \
    fzf --preview '
      cd {} 2>/dev/null && {
        echo "Claude Code workspace"
        echo "---"
        echo "Branch: $(git branch --show-current)"
        echo "Latest: $(git log -1 --format="%h %s")"
        echo ""
        if [[ -f "CLAUDE.md" ]]; then
          echo "[CLAUDE.md found]"
          head -20 CLAUDE.md
        fi
      }
    ')

  if [[ -n "$worktree" ]]; then
    cd "$worktree"
    claude
  fi
}

function gwtcn() {
  local branch_name base_branch wt_path

  if ! git rev-parse --show-toplevel &>/dev/null; then
    echo "Not in a git repository"
    return 1
  fi

  echo -n "New feature branch name: "
  read -r branch_name
  [[ -z "$branch_name" ]] && return 1

  base_branch=$(git branch -a --sort=-committerdate | sed 's/^[* ]*//' | \
    fzf --header "Select base branch" \
        --preview 'git log --oneline {} 2>/dev/null | head -20' | \
    sed 's/remotes\/origin\///')
  [[ -z "$base_branch" ]] && base_branch=$(_gwt_main_branch)

  gwq add -b "$branch_name" "$base_branch"
  wt_path=$(gwq list -g 2>/dev/null | grep "=${branch_name//\//-}$" | head -1)

  if [[ -n "$wt_path" ]]; then
    cd "$wt_path"
    zoxide add "$wt_path"
    echo "Starting Claude Code in: $wt_path"
    claude
  fi
}

# -----------------------------------------------------------------------------
# Utility
# -----------------------------------------------------------------------------

function gwtz() {
  local dir
  dir=$(zoxide query --list | while read -r d; do
    if [[ -d "$d/.git" ]] || git -C "$d" rev-parse --is-inside-work-tree &>/dev/null; then
      echo "$d"
    fi
  done | fzf --preview '
    cd {} 2>/dev/null && {
      echo "Branch: $(git branch --show-current 2>/dev/null || echo "N/A")"
      echo "Latest: $(git log -1 --format="%h %s" 2>/dev/null || echo "N/A")"
      echo "---"
      ls -la
    }
  ')

  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}
