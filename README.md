Run this script (For Ubuntu / Debian systems)

## Download Scripts for VPS Security

Run these commands on your VPS to download the latest scripts from the repository:

### Using wget

```bash
wget -O daily_malware_scan.sh https://raw.githubusercontent.com/hi2rashid/protect_vps/main/daily_malware_scan.sh && chmod +x daily_malware_scan.sh
wget -O system_health_check.sh https://raw.githubusercontent.com/hi2rashid/protect_vps/main/system_health_check.sh && chmod +x system_health_check.sh
```
```bash
curl -o daily_malware_scan.sh https://raw.githubusercontent.com/hi2rashid/protect_vps/main/daily_malware_scan.sh
curl -o system_health_check.sh https://raw.githubusercontent.com/hi2rashid/protect_vps/main/system_health_check.sh
```

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
