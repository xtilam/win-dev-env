@echo off
wsl -d debian -- bash --login -c "zellij %*"
REM debian run bash --login --login -c "zellij %*"
