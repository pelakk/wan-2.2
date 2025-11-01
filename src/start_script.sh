#!/usr/bin/env bash
# Robust startup script:
# 1. If /start.sh exists inside the image, run it.
# 2. Otherwise clone the repo to /tmp and try to find start.sh (handles repo name mismatches).

set -euo pipefail

if [ -x "/start.sh" ]; then
	echo "/start.sh exists in image — executing it"
	exec /start.sh
fi

REPO_URL="https://github.com/pelakk/wan-2.2.git"
TMPDIR="/tmp/wanrepo"

echo ">>> /start.sh not found in image, attempting to clone repo to ${TMPDIR}"
rm -rf "$TMPDIR"
git clone "$REPO_URL" "$TMPDIR" || { echo "git clone failed"; exit 1; }

if [ -f "$TMPDIR/src/start.sh" ]; then
	echo "Found start.sh in $TMPDIR/src — copying to /start.sh and executing"
	cp "$TMPDIR/src/start.sh" /start.sh
	chmod +x /start.sh
	# Set environment variable so start.sh knows where the repo is
	export CLONED_REPO_PATH="$TMPDIR"
	exec /start.sh
fi

# If repo directory had different name (older scripts expected comfyui-wan)
if [ -d "/tmp/wanrepo" ]; then
	for candidate in "/tmp/wanrepo" "/tmp/wanrepo/comfyui-wan"; do
		if [ -f "${candidate}/src/start.sh" ]; then
			echo "Found start.sh in ${candidate}/src — copying to /start.sh and executing"
			cp "${candidate}/src/start.sh" /start.sh
			chmod +x /start.sh
			# Set environment variable so start.sh knows where the repo is
			export CLONED_REPO_PATH="$candidate"
			exec /start.sh
		fi
	done
fi

echo "Could not locate start.sh in image or cloned repo. Exiting with error."
exit 1