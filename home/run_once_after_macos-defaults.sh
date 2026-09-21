#!/bin/bash
# macOS のシステム設定を chezmoi の初回 apply 時に一度だけ反映する
# 値は移行元マシンの defaults read で確認したもの
set -u

if [ -n "${CI:-}" ] || [ "$(uname)" != "Darwin" ]; then
  exit 0
fi

# キー長押しでリピート (vim の hjkl 用)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# ダークモード
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
# 拡張子を常に表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Dock: 自動的に隠す、アイコンサイズ
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 67
# Finder: カラム表示
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

killall Dock Finder 2>/dev/null || true
