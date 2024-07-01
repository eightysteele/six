#!/usr/bin/env bash

set -eu

SIX_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_DIR=$(dirname "$SIX_DIR")

if [ -f .env ]; then
	export $(cat .env | xargs)
fi

emacs-daemon-running() {
	if pgrep -af "^emacs.*--daemon$" >/dev/null; then
		return 0
	else
		return 1
	fi
}

emacs-daemon-start() {
	emacs --daemon --init-directory "$HOME/$EMACS_D"
}

bootstrap() {
	if ! gh auth status >/dev/null 2>&1; then
		gh auth login
	fi

	echo "✓ gh online"
	sleep 0.5

	pushd "$HOME" >/dev/null 2>&1
	if [ ! -d "$EMACS_D" ]; then
		gh repo clone "$SPACEMACS" "$EMACS_D"
		mkdir "$EMACS_D/org-roam"
		gh repo clone "$ORG_ROAM_DATA" "$EMACS_D/org-roam/$ORG_ROAM_DATA"
	fi
	popd >/dev/null 2>&1

	echo "✓ emacs online"
	sleep 0.5

	pushd "$XDG_CONFIG_HOME" >/dev/null 2>&1
	if [ ! -d "$SPACEMACS_D" ]; then
		gh repo clone "$SPACEMACS_D" "$SPACEMACS_D"
	fi
	popd >/dev/null 2>&1

	echo "✓ spacemacs online"
	sleep 0.5
}

main() {
	bootstrap
	if ! emacs-daemon-running; then
		emacs-daemon-start
		sleep 3.0
	fi
	emacsclient -nc
}

main "$@"
