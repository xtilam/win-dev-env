@echo off

wsl -d debian -- bash --login -c "export ZELLIJ_CONFIG_DIR=/mnt/d/Projects/dev-configs/zellij/config;zellij %*"
