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
	yes | emacs --daemon
}

bootstrap() {
	if ! gh auth status >/dev/null 2>&1; then
		gh auth login
	fi

	echo "✓ gh online"
	sleep 0.5

	if [ ! -d "$EMACS_D" ]; then
		gh repo clone "$SPACEMACS" "$EMACS_D"
		mkdir "$EMACS_D/org-roam"
		gh repo clone "$ORG_ROAM_DATA" "$EMACS_D/org-roam/$ORG_ROAM_DATA"
	fi

	echo "✓ emacs online"
	sleep 0.5

	if [ ! -d "$SPACEMACS_D" ]; then
		gh repo clone "$SPACEMACS_D" "$SPACEMACS_D"
	fi


	pushd "$SPACEMACS_D" >/dev/null 2>&1
	if git log HEAD..origin/$(git rev-parse --abbrev-ref HEAD) --oneline | grep .; then
		echo "Heads up: There are upstream changes to pull from $SPACEMACS_D"
	fi
	popd >/dev/null 2>&1

	echo "✓ spacemacs online"
	sleep 0.5
}

main() {
    pushd "$SIX_DIR" >/dev/null 2>&1
	  bootstrap
    popd >/dev/null 2>&1
}

main "$@"
