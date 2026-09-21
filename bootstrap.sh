#!/bin/bash
# 新しい Mac の最初の 1 コマンド。冪等なので途中で失敗しても再実行できる。
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ta1m1kam/dotfiles/master/bootstrap.sh)"
set -euo pipefail

DOTFILES="$HOME/dotfiles"
REPO_HTTPS="https://github.com/ta1m1kam/dotfiles.git"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

step "Xcode Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "    Finish the installer dialog, then re-run this script."
  exit 1
fi

step "Homebrew"
if [ ! -x /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

step "Clone dotfiles to $DOTFILES"
if [ ! -d "$DOTFILES/.git" ]; then
  git clone "$REPO_HTTPS" "$DOTFILES"
fi

step "Base tools (mise, chezmoi, gh, 1Password)"
brew install mise chezmoi gh
brew install --cask 1password 1password-cli 2>/dev/null || true

step "GitHub CLI login"
if ! gh auth status >/dev/null 2>&1; then
  gh auth login --git-protocol ssh --web
fi

step "SSH key (generated on this machine, registered to GitHub)"
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "$(whoami)@$(hostname -s)" -f "$HOME/.ssh/id_ed25519"
  gh ssh-key add "$HOME/.ssh/id_ed25519.pub" --title "$(hostname -s)"
fi

step "1Password CLI (optional, for work secrets)"
cat <<'MSG'
    If this is a work machine, sign in to the 1Password app, enable
    Settings > Developer > "Integrate with 1Password CLI", then run:
      op account add        # personal account holding dotfiles secrets
      eval "$(op signin)"
    chezmoi init will ask for the account and vault name (leave empty to skip).
MSG
read -r -p "    Press Enter to continue..." _

step "Run the installer (mise run install)"
cd "$DOTFILES"
mise run install
