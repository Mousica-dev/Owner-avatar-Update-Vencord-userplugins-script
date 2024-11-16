#!/bin/bash

for dir in */; do
    if [ -d "$dir/.git" ]; then
        echo "Checking $dir..."
        cd "$dir"
        git remote update > /dev/null 2>&1

        UPSTREAM=${1:-'@{u}'}
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse "$UPSTREAM")
        BASE=$(git merge-base @ "$UPSTREAM")

        if [ "$LOCAL" = "$REMOTE" ]; then
            echo "$dir is up to date."
        elif [ "$LOCAL" = "$BASE" ]; then
            echo "$dir needs to pull updates."
            git pull
        elif [ "$REMOTE" = "$BASE" ]; then
            echo "$dir has unpushed commits."
        else
            echo "$dir has diverged."
        fi

        cd ..
    fi
done

