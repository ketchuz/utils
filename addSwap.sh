#!/bin/bash

DEFAULT_RAM=4
DEFAULT_SWAP_NAME=swapfile

RAM_VALUE=${1:-$DEFAULT_RAM}
SWAP_NAME=${2:-$DEFAULT_SWAP_NAME}

sudo fallocate -l ${RAM_VALUE}G /${SWAP_NAME}
sudo chmod 600 /${SWAP_NAME}
sudo mkswap /${SWAP_NAME}
sudo swapon /${SWAP_NAME}
sudo swapon -s
sudo echo "/${SWAP_NAME}   none    swap    sw    0   0" >> /etc/fstab

echo "🚀 Swapfile added"
