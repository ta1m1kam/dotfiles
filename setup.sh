#!/bin/bash

source ./lib/brew.sh

has() {
  type "$1" > /dev/null 2>&1
}

run_brew
