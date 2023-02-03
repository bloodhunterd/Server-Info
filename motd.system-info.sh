#!/bin/bash

# This file ist part of the MotD project, see https://github.com/bloodhunterd/MotD.
# © 2023 by BloodhunterD <bloodhunterd@bloodhunterd.com>

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

CD="\033[0m"     # Default
CRB="\033[1;31m" # Red bold
CG="\033[0;32m"  # Green
CYB="\033[1;33m" # Yellow bold
CYL="\033[3;33m" # Yellow light
CBB="\033[1;34m" # Blue bold
CML="\033[3;35m" # Magenta light
CCL="\033[3;36m" # Cyan light

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

mapfile -t SPACE < <(df -hx devtmpfs -x tmpfs -x overlay -x squashfs | sed 1d)

for DRIVE in "${SPACE[@]}"
do
  if [[ "${DRIVE}" != "${SPACE[0]}" ]] ; then
    DRIVES="${DRIVES}\n                ${CG}"
  fi

  DRIVE_SOURCE=$(echo "${DRIVE}" | awk '{print $1}')
  DRIVE_MOUNT_PATH=$(echo "${DRIVE}" | awk '{print $6}')
  DRIVE_USAGE=$(echo "${DRIVE}" | awk '{print $3}')
  DRIVE_USAGE_PERCENT=$(echo "${DRIVE}" | awk '{print $5}')
  DRIVE_SIZE=$(echo "${DRIVE}" | awk '{print $2}')
  DRIVES="${DRIVES}${CYL}${DRIVE_SOURCE}${CD} → ${CCL}${DRIVE_MOUNT_PATH} ${CG}${DRIVE_USAGE_PERCENT} (${DRIVE_USAGE} of ${DRIVE_SIZE})"
done

# ===================================================
# Network
# ===================================================

mapfile -t INTERFACES < <(ip -o link show | awk -F': ' '{print $2}' | grep -v -E "lo|veth")

# IP V4
for INTERFACE in "${INTERFACES[@]}"
do
  if [[ "${INTERFACE}" != "${INTERFACES[0]}" ]] ; then
    IP_V4="${IP_V4}\n                ${CG}"
  fi

  mapfile -t IPS < <(ip addr show "${INTERFACE}" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

  INTERFACE_IPS=""
  for IP in "${IPS[@]}"
  do
    INTERFACE_IPS="${INTERFACE_IPS} ${IP}"
  done

  IP_V4="${IP_V4}${INTERFACE}${INTERFACE_IPS}"
done

# IP V6
for INTERFACE in "${INTERFACES[@]}"
do
  if [[ "${INTERFACE}" != "${INTERFACES[0]}" ]] ; then
    IP_V6="${IP_V6}\n                ${CG}"
  fi

  mapfile -t IPS < <(ip addr show "${INTERFACE}" | grep -oP '(?<=inet6\s)\w+(:?:\w+){4}')

  INTERFACE_IPS=""
  for IP in "${IPS[@]}"
  do
    INTERFACE_IPS="${INTERFACE_IPS} ${IP}"
  done

  IP_V6="${IP_V6}${INTERFACE}${INTERFACE_IPS}"
done

# ===================================================
# Output
# ===================================================

printf "\n"
printf " %b%b\n\n" "${CYB}" "${SYSTEM_NAME}"
printf " %bSYSTEM %b\n" "${CRB}" "${CD}"
printf "${CD} ➤ ${CBB}DISTRIBUTION ${CG}%s\n" "${DISTRIBUTION_NAME} ${DISTRIBUTION_VERSION} (${DISTRIBUTION_CODENAME})"
printf "${CD} ➤ ${CBB}CPU          ${CG}%s\n" "${CPU_MODEL}x ${CPU_CORES} cores"
printf "${CD} ➤ ${CBB}TIMEZONE     ${CG}%s\n" "${TIMEZONE}"
printf "${CD} ➤ ${CBB}DATE         ${CG}%s\n" "${DATE}"
printf "${CD} ➤ ${CBB}UPTIME       ${CG}%s\n" "${UPTIME}"
printf " %bUSAGE %b\n" "${CRB}" "${CD}"
printf "${CD} ➤ ${CBB}CPU          ${CG}%s\n" "${CPU_USAGE}% (${CPU_LOAD_AVG}) @ ${CPU_SPEED} MHz"
printf "${CD} ➤ ${CBB}MEMORY       ${CG}%s\n" "${MEMORY_USAGE_PERCENT}% (${MEMORY_USAGE} MB of ${MEMORY_TOTAL} MB)"
printf "${CD} ➤ ${CBB}SWAP         ${CG}%s\n" "${SWAP_USAGE_PERCENT} (${SWAP_USAGE} MB of ${SWAP_TOTAL} MB)"
printf "${CD} ➤ ${CBB}DISK         ${CG}%s\n" "${DISK_USAGE_PERCENT} (${DISK_USAGE} of ${DISK_TOTAL})"
printf "${CD} ➤ ${CBB}PROCESSES    ${CG}%s\n" "${PROCESSES_RUNNING} (running)"
printf " %bSPACE %b\n" "${CRB}" "${CD}"
printf "${CD} ➤ ${CBB}DRIVES       ${CG}%b\n" "${DRIVES}"
printf " %bNETWORK %b\n" "${CRB}" "${CD}"
printf "${CD} ➤ ${CBB}IPv4         ${CG}%b\n" "${IP_V4}"
printf "${CD} ➤ ${CBB}IPv6         ${CG}%b\n" "${IP_V6}"
printf " %b" "${CD}"
printf "\n"