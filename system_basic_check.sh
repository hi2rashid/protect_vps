#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

log() {
  echo -e "\n[$(date +"%H:%M:%S")] $1"
}

trap 'echo "❌ Script interrupted." && exit 1' INT TERM

log "🔍 Detecting OS..."
os_name=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
os_version=$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

if [[ "$os_name" != "ubuntu" ]]; then
  echo "❌ This script supports Ubuntu only. Detected: $os_name"
  exit 1
fi

log "✅ OS is Ubuntu $os_version"

# === System Info ===
log "🧾 Hostname: $(hostname)"
log "📅 Date: $(date)"
log "🧠 Memory:"
free -h

log "💽 Disk Usage:"
df -h /

log "🔌 Network Info:"
ip -brief address show

# === Check for Package Updates ===
log "🔄 Checking for pending package updates..."
sudo apt update > /dev/null
sudo apt list --upgradable || echo "✅ No pending upgrades."

# === Firewall Check (UFW) ===
log "🛡️ Checking UFW Firewall..."
if ! command -v ufw &>/dev/null; then
  echo "❌ UFW is not installed. Run: sudo apt install ufw"
else
  sudo ufw status verbose
fi

# === SSH Security Check ===
log "🔒 SSH Config Check..."
ssh_config="/etc/ssh/sshd_config"
grep -Ei "^Port|^PermitRootLogin" "$ssh_config" | grep -v '^#' || echo "⚠️ Using default SSH settings. Check $ssh_config."

# === Users with Shell Access ===
log "👥 Users with shell access:"
getent passwd | grep -E '/bin/(bash|sh)' | cut -d: -f1,7

# === Listening Ports ===
log "🌐 Listening Services:"
sudo ss -tuln

# === Failed Services ===
log "⚙️ Failed systemd services:"
systemctl --failed || echo "✅ No failed services."

# === Reboot Required? ===
if [ -f /var/run/reboot-required ]; then
  echo "⚠️ Reboot is required."
else
  echo "✅ No reboot required."
fi

# === Cleanup ===
log "🧹 Removing unused packages..."
sudo apt autoremove -y
sudo apt autoclean -y
log "✅ Cleanup done."

# === Large Files Advisory ===
log "🔎 Checking for large files (> 200 MB)..."
sudo find / -xdev -type f -size +200M -exec du -h {} + 2>/dev/null | sort -hr | head -n 20 || echo "✅ No large files found."

log "📌 Review above files for potential cleanup."
log "✅ System basic check finished successfully."

