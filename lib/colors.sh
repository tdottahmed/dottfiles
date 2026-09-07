#!/usr/bin/env bash
# Shared colors and logging helpers. Sourced by every script in this repo.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

info()  { echo -e "${CYAN}==>${NC} $*"; }
ok()    { echo -e "${GREEN} ok ${NC} $*"; }
warn()  { echo -e "${YELLOW} !! ${NC} $*"; }
error() { echo -e "${RED}fail${NC} $*" >&2; }
die()   { error "$*"; exit 1; }
