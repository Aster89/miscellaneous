#!/usr/bin/env bash
error() {
  printf '\e[4;5;31m%-s\e[m\n' "$@" >&2
}
warning() {
  printf '\e[4;5;33m%-s\e[m\n' "$@" >&2
}
