#!/bin/bash
set -e
# Version:0.0.2
# shellcheck source=.envrc
clear
source "${scripts_dir}/support/support-Banner_func.sh"
source ${scripts_dir}/.envrc
source ${scripts_dir}/support/.whoami.sh
# shellcheck source=support-Banner_func.sh
cpu_info=$(lscpu | grep "Model name" | awk '{print $3 $4 $5 $6 $7 $8}')
# Display hostname and username
printf "${CY}TZ: ${WT}$(timedatectl | grep "Time zone:" | awk '{print $3}')            ${CY}Time: ${WT}$(date +%I:%M:%S\ ${GN}%p)        ${CY}Username: ${GN}$(whoami)""${WT}@""${GN}$(hostname)${NC}\\n"

printf "\\n${CY}System information for computer, ${WT}$(hostname) ${CY} on Date: ${WT}$(timedatectl | grep "Local time" | awk '{print $3", " $4}')\\n"
echo
printf "${GN}  Distro: ${WT}$OS${GN}    |    Ver: ${WT}$VER${GN}     |    Kernel: ${WT}$KERN\\n  "
printf "${GN}Proccessor: ${WT}${cpu_info}\\n" 
#battery="$(acpi -b | awk '/Battery 0/ {print $3 $4 $5}')"
batt_per="$(acpi -b | awk '/Battery 0/ {gsub(/,|%/, ""); print $4}')"
battery_state="$(acpi -b | awk '/Battery 0/ {gsub(/,$/,"",$3); print $3}')"
# Display Battery info
printf "\\n${CY}Battery state: ${battery_state}"
printf "         ${CY}Battery Percentage remaining: ${WT}$batt_per"
echo "%   "

# Display disk usage
disk_usage="$(df -h | awk '{if($NF=="/") print $5}')"
# Display CPU temperature in Fahrenheit
cpu_temp=$(sensors | awk '/^Package/{printf("%.0f°F\n", $4*1.8+32)}')
# Display IP address
ip_address=$(hostname -I | awk '{print $1}')
# Display CPU load
cpu_load=$(uptime | awk '{print $10,$11,$12}')
printf "${CY}Disk Usage: ${WT}${disk_usage}%   ${CY}IP:${WT} ${ip_address}    ${CY}CPU Load: ${WT}$cpu_load      ${CY}CPU Temp: ${WT}${cpu_temp} \\n"


# Display total number of updates and security updates available
updates=$(apt list --upgradable 2>/dev/null | wc -l)
security_updates=$(apt list --upgradable 2>/dev/null | grep -E '\[security|critical\]' | wc -l)
security_pct=$(echo "scale=2; ($security_updates/$updates)*100" | bc)
total_pct=$(echo "scale=2; (($updates-$security_updates)/$updates)*100" | bc)
security_updates_age=$(sudo apt-get -s dist-upgrade | grep "^Inst" | grep -i securi | awk '{print $4}' | sort -u | head -n1)
printf " \\n"
printf "${CY}# Updates Avail: ${WT}$updates    |    ${CY}Non-Critical Percent: ${GN}$total_pct    |    ${CY}Grand Tot: ${WT}$tot_pkgs\\n"
printf "# Critical Updates: ${RED}$security_updates     |     ${YW}   Critical Update Percent-${RED}$security_pct\\n"
echo
printf "${GN}Uptime: ${OG}$(uptime)\\n"

printf "\\n\\n    ${CY}Press ${WT}any ${CY}key to return to the Main Easy Linux menu."
  read -r -n 1 -s -t 300
source ${scripts_dir}/menu-master.sh
