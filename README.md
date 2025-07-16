Run this script (For Ubuntu / Debian systems)
## 1. System Check
```
**./system_basic_check.sh**
```
![system_basic_check sh](https://github.com/user-attachments/assets/6c8119c5-8273-4276-aa2d-879daa63f8d5)



## 2. Daily Scan


🕒 One-liner to add a daily cron job at 2:00 AM:
```
(crontab -l 2>/dev/null; echo "0 2 * * * /root/antivirus/daily_malware_scan.sh >> /root/antivirus/daily.log 2>&1") | crontab -
```
