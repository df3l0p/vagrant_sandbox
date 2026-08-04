#!/usr/bin/env bash
# Prepare the sandbox VM for a clean golden snapshot: clear shell history,
# provisioning artifacts, package/journal/log cruft, and user caches.
# Run inside the guest (e.g. `make clean-vm`), then snapshot from the host.
set -euo pipefail

echo "Clearing shell history (vagrant and root, zsh and bash)..."
for f in /home/vagrant/.zsh_history /home/vagrant/.bash_history \
	/root/.zsh_history /root/.bash_history; do
	sudo truncate -s 0 "$f" 2>/dev/null || true
done

echo "Removing provisioning artifacts from /tmp and /var/tmp..."
sudo find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} + 2>/dev/null || true

echo "Cleaning APT cache and orphaned packages..."
sudo apt-get -y autoremove --purge
sudo apt-get -y clean

echo "Truncating logs and vacuuming the journal..."
sudo find /var/log -type f -name '*.log' -exec truncate -s 0 {} +
sudo find /var/log -type f \( -name '*.gz' -o -name '*.[0-9]' -o -name '*.old' \) -delete
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s
for f in /var/log/wtmp /var/log/btmp /var/log/lastlog; do
	sudo truncate -s 0 "$f" 2>/dev/null || true
done

# Preserve the Proton VPN session: credentials live in ~/.config/Proton and
# ~/.local/share/keyrings (never touched here), and its cache in ~/.cache/Proton
# is kept so the VPN stays signed in across the snapshot. This script also never
# signs out or disconnects Proton.
echo "Removing user caches and trash (keeping Proton session)..."
find "$HOME/.cache" -mindepth 1 -maxdepth 1 ! -name Proton -exec rm -rf {} + 2>/dev/null || true
rm -rf "$HOME/.local/share/Trash" 2>/dev/null || true

echo "Done. Exit any interactive shells, then snapshot from the host:"
echo "  make snapshot NAME=clean-base   (or: vagrant snapshot save <vm> <name>)"
