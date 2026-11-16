#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Minecraft watcher..."

( while true; do 
    docker events --filter 'container=minecraft' --filter 'event=die' | while read event; do
        echo "Minecraft container stopped. Triggering backup..."
        "$SCRIPT_DIR/backup_minecraft.sh"
    done
    sleep 5
done ) &

( while true; do 
    docker logs -f --tail 0 minecraft | while read line; do
        if [[ "$line" == *"[Autopause] Pausing Java process"* ]]; then
            echo "Autopause triggered. Triggering backup..."
            "$SCRIPT_DIR/backup_minecraft.sh"
        fi
    done
    sleep 5
done ) &

wait