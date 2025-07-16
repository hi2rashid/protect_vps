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
log "🧠 Memory Usage:"
free -h

log "💽 Disk Usage (root partition):"
df -h /

log "🔌 Network Interfaces (brief):"
ip -brief address show

# === Check for Package Updates ===
log "🔄 Checking for pending package updates..."
sudo apt update -qq
upgradable=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." || true)
if [[ -z "$upgradable" ]]; then
  echo "✅ No pending upgrades."
else
  echo "$upgradable"
fi

# === Firewall Check (UFW) ===
log "🛡️ Checking UFW Firewall status..."
if ! command -v ufw &>/dev/null; then
  echo "❌ UFW is not installed. You can install it with: sudo apt install ufw"
else
  sudo ufw status verbose
  # Quick firewall status
  status=$(sudo ufw status | head -1)
  echo " - UFW status: $status"
  if [[ "$status" == "Status: active" ]]; then
    echo " ✅ Firewall is active."
  else
    echo " ⚠️ Firewall is inactive! Consider enabling UFW."
  fi
fi

# === SSH Config Check ===
log "🔒 SSH Config Check (/etc/ssh/sshd_config):"
if [[ -f /etc/ssh/sshd_config ]]; then
  ssh_port=$(grep -Ei "^Port" /etc/ssh/sshd_config | grep -v '^#' || echo "Port 22 (default)")
  permit_root=$(grep -Ei "^PermitRootLogin" /etc/ssh/sshd_config | grep -v '^#' || echo "PermitRootLogin yes (default)")
  pass_auth=$(grep -Ei "^PasswordAuthentication" /etc/ssh/sshd_config | grep -v '^#' || echo "PasswordAuthentication yes (default)")

  echo "Port setting: $ssh_port"
  echo "PermitRootLogin: $permit_root"
  echo "PasswordAuthentication: $pass_auth"

  # Quick SSH security check
  if [[ "$permit_root" =~ no ]]; then
    echo " ✅ Root login is disabled."
  else
    echo " ⚠️ Root login is enabled. Consider disabling it for better security."
  fi

  if [[ "$pass_auth" =~ no ]]; then
    echo " ✅ Password authentication is disabled (using keys only)."
  else
    echo " ⚠️ Password authentication is enabled. Consider disabling to enforce key-based auth."
  fi

  if [[ "$ssh_port" != "Port 22"* ]]; then
    echo " ✅ SSH is running on non-default port."
  else
    echo " ⚠️ SSH is running on default port 22. Consider changing to reduce automated attacks."
  fi
else
  echo "❌ SSH config file not found."
fi

# === Users with Shell Access ===
log "👥 Users with shell access:"
getent passwd | grep -E '/bin/(bash|sh)' | cut -d: -f1,7 || echo "No users with standard shell access found."

# === Listening Services and Ports ===
log "🌐 Listening TCP/UDP Ports & Services:"
sudo ss -tuln

# === Failed systemd services ===
log "⚙️ Checking for failed systemd services:"
failed_services=$(systemctl --failed --no-legend)
if [[ -z "$failed_services" ]]; then
  echo "✅ No failed services."
else
  echo "$failed_services"
fi

# === Reboot Required Check ===
if [[ -f /var/run/reboot-required ]]; then
  echo "⚠️ Reboot is required."
else
  echo "✅ No reboot required."
fi

# === Fail2ban Status ===
log "🚨 Checking Fail2ban status:"
if command -v fail2ban-client &>/dev/null; then
  sudo fail2ban-client status || echo " ⚠️ Fail2ban not running or no jails configured."
else
  echo " ⚠️ Fail2ban not installed."
fi

# === Cleanup unused packages ===
log "🧹 Cleaning up unused packages..."
sudo apt autoremove -y
sudo apt autoclean -y
log "✅ Cleanup complete."

# === Large Files Advisory ===
log "🔎 Searching for large files (> 200 MB)..."
large_files=$(sudo find / -xdev -type f -size +200M -exec du -h {} + 2>/dev/null | sort -hr | head -n 20 || true)
if [[ -z "$large_files" ]]; then
  echo "✅ No large files found."
else
  echo "$large_files"
  echo -e "\n📌 Please review these large files to decide if cleanup is needed."
fi

log "✅ System basic check finished successfully."
