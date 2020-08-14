#!/bin/bash

DATE=`date`

SYSTEM_NAME=`uname -snrm`
SYSTEM_UPTIME=`uptime | awk '{print $3 " " $4}' | sed s'/.$//'`

PROCESSES_RUNNING=`ps aux | wc -l`

CPU_CORES=`nproc`
CPU_LOAD=`cat /proc/loadavg | awk '{print $1*100}'`
CPU_USAGE=$((CPU_LOAD / CPU_CORES))
CPU_MHZ=`cat /proc/cpuinfo | grep -m 1 "cpu MHz" | awk '{print $4}'`

MEMORY_TOTAL=`free -m | grep "Mem" | awk '{print $2}'`
MEMORY_USAGE=`free -m | grep "Mem" | awk '{print $3}'`
MEMORY_USAGE_PERCENT=`expr ${MEMORY_USAGE} \* 100 / ${MEMORY_TOTAL}`

SWAP_TOTAL=`free -m | grep "Swap" | awk '{print $2}'`
SWAP_USAGE=`free -m | grep "Swap" | awk '{print $3}'`
# SWAP space is optional, so it needs to be checked if it exist.
SWAP_USAGE_PERCENT=`if [[ "${SWAP_TOTAL}" -gt 0 ]] ; then expr ${SWAP_USAGE} \* 100 / ${SWAP_TOTAL} | awk '{print $1"%"}' ; else echo '-'; fi`

DISK_TOTAL=`df -h --total | grep "total" | awk '{print $2}'`
DISK_USAGE=`df -h --total | grep "total" | awk '{print $3}'`
DISK_USAGE_PERCENT=`df -h --total | grep "total" | awk '{print $5}'`

IP_ADDRESS=`ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`

COLOR_DEFAULT="\033[0m"
COLOR_INFO="\033[1;34m"
COLOR_VALUE="\033[1;32m"

printf "\n"
printf " ${COLOR_INFO}${SYSTEM_NAME}\n"
printf " ${COLOR_DEFAULT}"
printf "==============================================\n"
printf " ${COLOR_INFO}DATE          |${COLOR_VALUE} %s\n" "${DATE}"
printf " ${COLOR_INFO}SYSTEM UPTIME |${COLOR_VALUE} %s\n" "${SYSTEM_UPTIME}"
printf " ${COLOR_DEFAULT}"
printf "==============================================\n"
printf " ${COLOR_INFO}PROCESSES     |${COLOR_VALUE} %s\n" "${PROCESSES_RUNNING} (running)"
printf " ${COLOR_DEFAULT}"
printf "==============================================\n"
printf " ${COLOR_INFO}CPU USAGE     |${COLOR_VALUE} %s\n" "${CPU_USAGE}% (${CPU_CORES} cores at ${CPU_MHZ} MHz)"
printf " ${COLOR_INFO}MEMORY USAGE  |${COLOR_VALUE} %s\n" "${MEMORY_USAGE_PERCENT}% (${MEMORY_USAGE} MB of ${MEMORY_TOTAL} MB)"
printf " ${COLOR_INFO}SWAP_USAGE    |${COLOR_VALUE} %s\n" "${SWAP_USAGE_PERCENT} (${SWAP_USAGE} MB of ${SWAP_TOTAL} MB)"
printf " ${COLOR_INFO}DISK USAGE    |${COLOR_VALUE} %s\n" "${DISK_USAGE_PERCENT} (${DISK_USAGE} of ${DISK_TOTAL})"
printf " ${COLOR_DEFAULT}"
printf "==============================================\n"
printf " ${COLOR_INFO}IP ADDRESS    |${COLOR_VALUE} %s\n" "${IP_ADDRESS}"
printf " ${COLOR_DEFAULT}"
printf "\n"
