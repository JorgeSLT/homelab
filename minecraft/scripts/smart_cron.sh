#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLAYERS=$(docker exec minecraft rcon-cli list 2>/dev/null)

if [[ "$PLAYERS" == *"There are "* ]] && [[ ! "$PLAYERS" == *" 0 of "* ]]; then
    echo "Players detected. Triggering backup..."
    "$SCRIPT_DIR/backup_minecraft.sh"
else
    echo "No players online. Skipping backup."
fi