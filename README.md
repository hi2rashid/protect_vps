Run this script (For Ubuntu / Debian systems)

## Download Scripts for VPS Security

Run these commands on your VPS to download the latest scripts from the repository:

### Using wget

```bash
wget -O daily_malware_scan.sh https://raw.githubusercontent.com/hi2rashid/protect_vps/main/daily_malware_scan.sh && chmod +x daily_malware_scan.sh
wget -O system_basic_check.sh https://raw.githubusercontent.com/hi2rashid/protect_vps/main/system_basic_check.sh && chmod +x system_basic_check.sh
```
```bash
curl -o daily_malware_scan.sh https://raw.githubusercontent.com/hi2rashid/protect_vps/main/daily_malware_scan.sh
curl -o system_basic_check.sh https://raw.githubusercontent.com/hi2rashid/protect_vps/main/system_basic_check.sh
```

## How to run


## 1. System Check
```
./system_basic_check.sh
```
![system_basic_check sh](https://github.com/user-attachments/assets/6c8119c5-8273-4276-aa2d-879daa63f8d5)



## 2. Daily Scan


🕒 One-liner to add a daily cron job at 2:00 AM:
```
(crontab -l 2>/dev/null; echo "0 2 * * * /root/antivirus/daily_malware_scan.sh >> /root/antivirus/daily.log 2>&1") | crontab -
```













## System Basic Check Script — What It Checks

* **Operating System Detection** (Ubuntu only)
* **Hostname and Current Date/Time**
* **Memory Usage Overview**
* **Disk Usage on Root Partition**
* **Network Interface Summary**
* **Pending Package Updates**
* **UFW Firewall Status and Activity**
* **SSH Configuration:**

  * SSH port number
  * Root login permission
  * Password authentication status
* **Users with Shell Access**
* **Listening TCP/UDP Ports and Services**
* **Failed systemd Services**
* **Reboot Requirement Status**
* **Fail2ban Status (if installed)**
* **Automatic Cleanup of Unused Packages**
* **Listing of Large Files (>200 MB) for Review**


*daily_malware_scan.sh *
## Daily Malware Scan Script — What It Checks

* **Updates ClamAV Virus Definitions**
* **Runs ClamAV Scan (clamdscan) on System**
* **Runs chkrootkit Rootkit Detection**
* **Runs rkhunter Rootkit and Malware Check (with database update)**
* **Runs Lynis Security Audit**
* **Runs Linux Malware Detect (Maldet) Full Scan**
* **Summarizes Scan Results and Alerts**
* **Logs All Scan Outputs for Review**
* 
| Tool                              | Purpose / Function                                                                      | Installed via                           |
| --------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------- |
| **ClamAV**                        | Open-source antivirus engine to scan files and directories for malware                  | `clamav` package                        |
| **chkrootkit**                    | Detects known rootkits by scanning system binaries and configs                          | `chkrootkit` package                    |
| **rkhunter**                      | Rootkit Hunter scans for rootkits, suspicious files, backdoors, and vulnerabilities     | `rkhunter` package                      |
| **Lynis**                         | Security auditing and hardening tool that performs in-depth system checks               | `lynis` package                         |
| **Linux Malware Detect (Maldet)** | Malware scanner focused on Linux servers, good at detecting trojans, viruses, and worms | Installed manually from source via wget |



Someone else is doing it already https://github.com/vernu/vps-audit 
