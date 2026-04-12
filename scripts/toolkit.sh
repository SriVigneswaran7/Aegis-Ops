#!/bin/bash

# Main Menu
while true; do
    clear
    echo "============================================"
    echo "       LINUX ADMINISTRATION TOOLKIT v1.1    "
    echo "============================================"
    echo "1. System Info     2. Home Analysis  3. Process Analysis"
    echo "4. Backup Tool     5. Password Check 6. Disk Warning"
    echo "7. Log Analysis    8. File Renamer   9. User Activity"
    echo "10. Pass Gen       11. EXIT"
    echo "============================================"
    read -p "Select Task [1-11]: " opt

    case $opt in
        1) # I. System Information Report
            echo "User: $USER | Host: $HOSTNAME"
            echo "Date: $(date) | Uptime: $(uptime -p)"
            echo "Kernel: $(uname -r) | CPU: $(lscpu | grep 'Model name' | cut -d: -f2)"
            echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
            echo "Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2}')" ;;

        2) # II. Home Directory File Analysis
            echo "Files/Dirs: $(ls -A ~ | wc -l)"
            echo "Largest File: $(find ~ -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n 1)"
            echo "Total Usage: $(du -sh ~ 2>/dev/null | cut -f1)" ;;

        3) # III. Process Analysis
            echo "Total Processes: $(ps ax | wc -l)"
            echo "--- Top CPU ---"; ps -eo pcpu,comm --sort=-pcpu | head -n 4
            echo "--- Top Mem ---"; ps -eo pmem,comm --sort=-pmem | head -n 4 ;;

        4) # IV. Directory Backup Tool
            read -p "Enter dir to backup: " bdir
            mkdir -p ~/backups
            ts=$(date +%Y%m%d_%H%M%S)
            tar -czf ~/backups/backup_$ts.tar.gz "$bdir" 2>/dev/null
            echo "Backup created in ~/backups. Size: $(du -sh ~/backups/backup_$ts.tar.gz | cut -f1)" ;;

        5) # V. Password Strength Checker
            read -s -p "Enter password to check: " pass; echo
            if [[ ${#pass} -ge 8 && "$pass" == *[A-Z]* && "$pass" == *[0-9]* ]]; then
                echo "Strength: STRONG"
            else
                echo "Strength: WEAK (Needs 8+ chars, 1 Uppercase, 1 Number)"
            fi ;;

        6) # VI. Disk Usage Warning Tool
            usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//')
            if [ "$usage" -gt 80 ]; then echo "WARNING: Disk over 80%!"; else echo "Disk OK: $usage%"; fi
            echo "Largest Dirs:"; du -sh ~ 2>/dev/null | sort -rh | head -n 5 ;;

        7) # VII. Log File Analysis
            echo "Log Entries: $(wc -l < /var/log/syslog 2>/dev/null || echo 'Permission Denied')"
            echo "Errors/Warnings: $(grep -Ei 'error|warning' /var/log/syslog 2>/dev/null | wc -l)"
            tail -n 5 /var/log/syslog 2>/dev/null ;;

        8) # VIII. Batch File Renaming Tool
            read -p "Enter extension (e.g., txt): " ext
            for f in *."$ext"; do [ -e "$f" ] && mv "$f" "${f%.*}_$(date +%s).$ext"; done
            echo "Files renamed with timestamps." ;;

        9) # IX. User Activity Monitor
            echo "Current Users:"; who
            echo "Login History:"; last | head -n 5 ;;

        10) # X. Random Password Generator
            echo "Your Secure Password: $(openssl rand -base64 12)" ;;

        11) exit 0 ;;
        *) echo "Invalid Option" ;;
    esac

    read -p "Press Enter to continue..."
done