#!/bin/bash

echo "======================================"
echo " Updating kawai..."
echo "======================================"
# -t allocates a TTY so you can enter your sudo password
ssh -t kawai 'sudo apt update && sudo apt upgrade -y && cd services/ && for d in */; do echo "=== $d ===" && docker compose -f "${d}docker-compose.yml" pull && docker compose -f "${d}docker-compose.yml" up -d; done && docker image prune -af'

echo "======================================"
echo " Updating kawai-remote..."
echo "======================================"
ssh -t kawai-remote 'apt update && apt upgrade -y'

echo "======================================"
echo " Done!"
echo "======================================"
