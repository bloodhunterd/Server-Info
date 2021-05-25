#!/bin/bash

# This file ist part of the MotD project, see https://github.com/bloodhunterd/MotD.
# © 2021 BloodhunterD <bloodhunterd@bloodhunterd.com>

# ===================================================
# Script directory path
# ===================================================

if [ -n "${BASH_SOURCE[0]}" ]; then
  DIR=$(dirname "${BASH_SOURCE[0]}")
elif [ -n "${0}" ]; then
  DIR=$(dirname "$(readlink -f "$0")")
fi

# ===================================================
# Configuration file and fallbacks
# ===================================================

CONFIG_FILE="${DIR}/motd.system-info.conf"

if test -f "${CONFIG_FILE}"; then
  . "${DIR}/motd.system-info.conf"
fi

if [ -z ${DATE_FORMAT+x} ]; then
  DATE_FORMAT="%x %X"
fi

# ===================================================
# Colors
# ===================================================

COLOR_DEFAULT="\033[0m"
COLOR_INFO="\033[1;34m"
COLOR_VALUE="\033[1;32m"
COLOR_HEAD="\033[1;33m"
COLOR_HEADLINE="\033[1;31m"

# ===================================================
# OS
# ===================================================

if [ -z ${SYSTEM_NAME+x} ]; then
  SYSTEM_NAME=$(hostname)
else
  SYSTEM_NAME+=" ($(hostname))"
fi

DATE=$(date +"${DATE_FORMAT}")
TIMEZONE=$(timedatectl | grep "Time" | awk '{print $3" "$4" UTC"$5}')

DISTRIBUTION_NAME=$(lsb_release -si)
DISTRIBUTION_VERSION=$(lsb_release -sr)
DISTRIBUTION_CODENAME=$(lsb_release -sc)

UPTIME=$(uptime | awk '{print $3 " " $4}' | sed s'/.$//')

PROCESSES_RUNNING=$(ps aux | wc -l)

# ===================================================
# CPU
# ===================================================

CPU_MODEL=$(cat /proc/cpuinfo | grep -m 1 "model name" | awk '{a="";for (i=4;i<=NF;i++){a=a$i" "}print a}')
CPU_LOAD=$(cat /proc/loadavg | awk '{print $1*100}')
CPU_LOAD_AVG=$(cat /proc/loadavg | awk '{print $1" "$2" "$3}')
CPU_CORES=$(nproc)
CPU_USAGE=$((CPU_LOAD / CPU_CORES))
CPU_SPEED=$(lscpu | grep -m 1 "MHz" | awk '{for(i=NF;i>=1;i--) printf "%s ", $i;print ""}' | awk '{print $1}' | cut -f1 -d".")

# ===================================================
# Memory
# ===================================================

MEMORY_TOTAL=$(free -m | grep "Mem" | awk '{print $2}')
MEMORY_USAGE=$(free -m | grep "Mem" | awk '{print $3}')
MEMORY_USAGE_PERCENT=$(expr "${MEMORY_USAGE}" \* 100 / "${MEMORY_TOTAL}")

# ===================================================
# Swap
# ===================================================

SWAP_TOTAL=$(free -m | grep "Swap" | awk '{print $2}')
SWAP_USAGE=$(free -m | grep "Swap" | awk '{print $3}')
# SWAP space is optional, so it needs to be checked if it exist.
SWAP_USAGE_PERCENT=$(if [[ "${SWAP_TOTAL}" -gt 0 ]] ; then expr "${SWAP_USAGE}" \* 100 / "${SWAP_TOTAL}" | awk '{print $1"%"}' ; else echo '-'; fi)

# ===================================================
# Disk
# ===================================================

DISK_TOTAL=$(df -h --total | grep "total" | awk '{print $2}')
DISK_USAGE=$(df -h --total | grep "total" | awk '{print $3}')
DISK_USAGE_PERCENT=$(df -h --total | grep "total" | awk '{print $5}')

# ===================================================
# Network
# ===================================================

mapfile -t INTERFACES < <(ip -o link show | awk -F': ' '{print $2}' | grep -v -E "lo|veth")

# IP V4
for INTERFACE in "${INTERFACES[@]}"
do
  if [[ "${INTERFACE}" != "${INTERFACES[0]}" ]] ; then
    IP_V4_ADDRESSES="${IP_V4_ADDRESSES}\n              ${COLOR_DEFAULT}|${COLOR_VALUE} "
  fi

  IP_V4_ADDRESSES="${IP_V4_ADDRESSES}${INTERFACE} $(ip addr show "${INTERFACE}" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"
done

# IP V6
for INTERFACE in "${INTERFACES[@]}"
do
  if [[ "${INTERFACE}" != "${INTERFACES[0]}" ]] ; then
    IP_V6_ADDRESSES="${IP_V6_ADDRESSES}\n              ${COLOR_DEFAULT}|${COLOR_VALUE} "
  fi

  IP_V6_ADDRESSES="${IP_V6_ADDRESSES}${INTERFACE} $(ip addr show "${INTERFACE}" | grep -oP '(?<=inet6\s)\w+(:?:\w+){4}')"
done

# ===================================================
# Output
# ===================================================

printf "\n"
printf " %b%b\n\n" "${COLOR_HEAD}" "${SYSTEM_NAME}"
printf " %bSYSTEM %b=======================================================================\n" "${COLOR_HEADLINE}" "${COLOR_DEFAULT}"
printf " ${COLOR_INFO}DISTRIBUTION ${COLOR_DEFAULT}|${COLOR_VALUE} %s\n" "${DISTRIBUTION_NAME} ${DISTRIBUTION_VERSION} (${DISTRIBUTION_CODENAME})"
printf " ${COLOR_INFO}CPU          ${COLOR_DEFAULT}|${COLOR_VALUE} %s\n" "${CPU_MODEL}- ${CPU_CORES} cores @ ${CPU_SPEED} MHz"
printf " ${COLOR_INFO}DATE         ${COLOR_DEFAULT}|${COLOR_VALUE} %s\n" "${DATE}"
printf " ${COLOR_INFO}TIMEZONE     ${COLOR_DEFAULT}|${COLOR_VALUE} %s\n" "${TIMEZONE}"
printf " ${COLOR_INFO}UPTIME       ${COLOR_DEFAULT}|${COLOR_VALUE} %s\n" "${UPTIME}"
printf " ${COLOR_INFO}PROCESSES    ${COLOR_DEFAULT}|${COLOR_VALUE} %s\n" "${PROCESSES_RUNNING} (running)"
printf " %bUSAGE %b========================================================================\n" "${COLOR_HEADLINE}" "${COLOR_DEFAULT}"
printf " ${COLOR_INFO}CPU          ${COLOR_DEFAULT}|${COLOR_VALUE} %s\n" "${CPU_USAGE}% (${CPU_LOAD_AVG})"
printf " ${COLOR_INFO}MEMORY       ${COLOR_DEFAULT}|${COLOR_VALUE} %s\n" "${MEMORY_USAGE_PERCENT}% (${MEMORY_USAGE} MB of ${MEMORY_TOTAL} MB)"
printf " ${COLOR_INFO}SWAP         ${COLOR_DEFAULT}|${COLOR_VALUE} %s\n" "${SWAP_USAGE_PERCENT} (${SWAP_USAGE} MB of ${SWAP_TOTAL} MB)"
printf " ${COLOR_INFO}DISK         ${COLOR_DEFAULT}|${COLOR_VALUE} %s\n" "${DISK_USAGE_PERCENT} (${DISK_USAGE} of ${DISK_TOTAL})"
printf " %bNETWORKS %b=====================================================================\n" "${COLOR_HEADLINE}" "${COLOR_DEFAULT}"
printf " ${COLOR_INFO}IPv4         ${COLOR_DEFAULT}|${COLOR_VALUE} %b\n" "${IP_V4_ADDRESSES}"
printf " ${COLOR_INFO}IPv6         ${COLOR_DEFAULT}|${COLOR_VALUE} %b\n" "${IP_V6_ADDRESSES}"
printf " %b" "${COLOR_DEFAULT}"
printf "\n"
