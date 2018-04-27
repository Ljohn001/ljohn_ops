#!/bin/bash

# Check CPU Usage via /proc/stats

########################
# DECLARATIONS
########################

PROGNAME=`basename $0`
REVISION=`echo '$Revision: 1.0 $' | sed -e 's/[^0-9.]//g'`

DEBUG=0

exitstatus=0
result=""
perfdata=""
scale=2
show_all=0
warning=999
critical=999

TMPFILE="/tmp/check_cpu.tmp"

status[0]="OK: "
status[1]="WARNING: "
status[2]="CRITICAL: "
status[3]="UNKNOWN: "

########################
# FUNCTIONS
########################

print_usage() {
  echo "Usage: $PROGNAME [options]"
  echo "  e.g. $PROGNAME -w 75 -c 90 -s 2 --all"
  echo
  echo "Options:"
  echo -e "\t --help    | -h       print help"
  echo -e "\t --version | -V       print version"
  echo -e "\t --verbose | -v       be verbose (debug mode)"
  echo -e "\t --scale   | -s [int] decimal precision of results"
  echo -e "\t                        default=2"
  echo -e "\t --all     | -a       return values for all cpus individually"
  echo -e "\t                        default= summary data only"
  echo -e "\t -w [int]             set warning value"
  echo -e "\t -c [int]             set critical value"
  echo
  echo
}

print_help() {
#  print_revision $PROGNAME $REVISION
  echo "${PROGNAME} Revision: ${REVISION}"
  echo
  echo "This plugin checks local cpu usage using /proc/stat"
  echo
  print_usage
  echo
# support
  exit 3
}

parse_options() {
# parse cmdline arguments
  (( DEBUG )) && echo "Parsing options $1 $2 $3 $4 $5 $6 $7 $8"
  if [ "$#" -gt 0 ]; then
    while [ "$#" -gt 0 ]; do
      case "$1" in
        '--help'|'-h')
          print_help
          exit 3
          ;;
        '--version'|'-V')
          #print_revision $PROGNAME $REVISION
          echo "${PROGNAME} Revision: ${REVISION}"
          exit 3
          ;;
        '--verbose'|'-v')
          DEBUG=1
          shift 1
          ;;
        '--scale'|'-s')
          scale="$2"
          shift 2
          ;;
        '--all'|'-a')
          show_all=1
          shift 1
          ;;
        '-c')
          critical="$2"
          shift 2
          ;;
        '-w')
          warning="$2"
          shift 2
          ;;
        *)
          echo "Unknown option!"
          print_usage
          exit 3
          ;;
      esac
    done
  fi
}

write_tmpfile() {
  echo "old_date=$(date +%s)" > ${TMPFILE}
  for a in $(seq 0 1 ${cpucount} ); do
    echo "old_system[${a}]=${system[${a}]}" >> ${TMPFILE}
    echo "old_user[${a}]=${user[${a}]}" >> ${TMPFILE}
    echo "old_nice[${a}]=${nice[${a}]}" >> ${TMPFILE}
    echo "old_iowait[${a}]=${iowait[${a}]}" >> ${TMPFILE}
    echo "old_irq[${a}]=${irq[${a}]}" >> ${TMPFILE}
    echo "old_softirq[${a}]=${softirq[${a}]}" >> ${TMPFILE}
    echo "old_idle[${a}]=${idle[${a}]}" >> ${TMPFILE}
    echo "old_used[${a}]=${used[${a}]}" >> ${TMPFILE}
    echo "old_total[${a}]=${total[${a}]}" >> ${TMPFILE}
  done
}

read_tmpfile() {
  if [ -e ${TMPFILE} ]; then
    source ${TMPFILE}			# include the vars from the tmp file
  fi
  (( DEBUG )) && cat ${TMPFILE}
}

########################
# MAIN
########################

parse_options $@

read_tmpfile

procstat=$(cat /proc/stat 2>&1)
 (( DEBUG )) && echo "$procstat"
cpucount=$(( $(grep -i cpu <<< "${procstat}" | tail -n 1 | cut -d' ' -f 1 | grep -Eo [0-9]+) + 1 ))
  (( DEBUG )) && echo "cpucount=${cpucount}"

for a in $(seq 0 1 ${cpucount} ); do
  if [ $a -eq ${cpucount} ]; then
    cpu[$a]=$(head -n 1 <<< "${procstat}" | sed 's/  / /g')
  else
    cpu[$a]=$(grep cpu${a} <<< "${procstat}")
  fi
  user[$a]=$(cut -d' ' -f 2 <<< ${cpu[$a]})
  nice[$a]=$(cut -d' ' -f 3 <<< ${cpu[$a]})
  system[$a]=$(cut -d' ' -f 4 <<< ${cpu[$a]})
  idle[$a]=$(cut -d' ' -f 5 <<< ${cpu[$a]})
  iowait[$a]=$(cut -d' ' -f 6 <<< ${cpu[$a]})
  irq[$a]=$(cut -d' ' -f 7 <<< ${cpu[$a]})
  softirq[$a]=$(cut -d' ' -f 8 <<< ${cpu[$a]})
  used[$a]=$((( ${user[$a]} + ${nice[$a]} + ${system[$a]} + ${iowait[$a]} + ${irq[$a]} + ${softirq[$a]} )))
  total[$a]=$((( ${user[$a]} + ${nice[$a]} + ${system[$a]} + ${idle[$a]} + ${iowait[$a]} + ${irq[$a]} + ${softirq[$a]} )))

  [ -z ${old_user[${a}]} ] && old_user[${a}]=0
  [ -z ${old_nice[${a}]} ] && old_nice[${a}]=0
  [ -z ${old_system[${a}]} ] && old_system[${a}]=0
  [ -z ${old_idle[${a}]} ] && old_idle[${a}]=0
  [ -z ${old_iowait[${a}]} ] && old_iowait[${a}]=0
  [ -z ${old_irq[${a}]} ] && old_irq[${a}]=0
  [ -z ${old_softirq[${a}]} ] && old_softirq[${a}]=0
  [ -z ${old_used[${a}]} ] && old_used[${a}]=0
  [ -z ${old_total[${a}]} ] && old_total[${a}]=0

  diff_user[$a]=$(((${user[$a]}-${old_user[${a}]})))
  diff_nice[$a]=$(((${nice[$a]}-${old_nice[${a}]})))
  diff_system[$a]=$(((${system[$a]}-${old_system[${a}]})))
  diff_idle[$a]=$(((${idle[$a]}-${old_idle[${a}]})))
  diff_iowait[$a]=$(((${iowait[$a]}-${old_iowait[${a}]})))
  diff_irq[$a]=$(((${irq[$a]}-${old_irq[${a}]})))
  diff_softirq[$a]=$(((${softirq[$a]}-${old_softirq[${a}]})))
  diff_used[$a]=$(((${used[$a]}-${old_used[${a}]})))
  diff_total[$a]=$(((${total[$a]}-${old_total[${a}]})))
 
  pct_user[$a]=$(bc <<< "scale=${scale};${diff_user[$a]}*100/${diff_total[$a]}")
  pct_nice[$a]=$(bc <<< "scale=${scale};${diff_nice[$a]}*100/${diff_total[$a]}")
  pct_system[$a]=$(bc <<< "scale=${scale};${diff_system[$a]}*100/${diff_total[$a]}")
  pct_idle[$a]=$(bc <<< "scale=${scale};${diff_idle[$a]}*100/${diff_total[$a]}")
  pct_iowait[$a]=$(bc <<< "scale=${scale};${diff_iowait[$a]}*100/${diff_total[$a]}")
  pct_irq[$a]=$(bc <<< "scale=${scale};${diff_irq[$a]}*100/${diff_total[$a]}")
  pct_softirq[$a]=$(bc <<< "scale=${scale};${diff_softirq[$a]}*100/${diff_total[$a]}")
  pct_used[$a]=$(bc <<< "scale=${scale};${diff_used[$a]}*100/${diff_total[$a]}")
done

write_tmpfile

[ $(cut -d'.' -f 1 <<< ${pct_used[${cpucount}]}) -ge ${warning} ] && exitstatus=1
[ $(cut -d'.' -f 1 <<< ${pct_used[${cpucount}]}) -ge ${critical} ] && exitstatus=2

result="CPU=${pct_used[${cpucount}]}"
if [ $show_all -gt 0 ]; then
  for a in $(seq 0 1 $(((${cpucount} - 1)))); do
    result="${result}, CPU${a}=${pct_used[${a}]}"
  done
fi

if [ "${warning}" = "999" ]; then
  warning=""
fi
if [ "${critical}" = "999" ]; then
  critical=""
fi

perfdata="used=${pct_used[${cpucount}]};${warning};${critical};; system=${pct_system[${cpucount}]};;;; user=${pct_user[${cpucount}]};;;; nice=${pct_nice[${cpucount}]};;;; iowait=${pct_iowait[${cpucount}]};;;; irq=${pct_irq[${cpucount}]};;;; softirq=${pct_softirq[${cpucount}]};;;;"
if [ $show_all -gt 0 ]; then
  for a in $(seq 0 1 $(((${cpucount} - 1)))); do
    perfdata="${perfdata} used${a}=${pct_used[${a}]};;;; system${a}=${pct_system[${a}]};;;; user${a}=${pct_user[${a}]};;;; nice${a}=${pct_nice[${a}]};;;; iowait${a}=${pct_iowait[${a}]};;;; irq${a}=${pct_irq[${a}]};;;; softirq${a}=${pct_softirq[${a}]};;;;"
  done
fi

echo "${status[$exitstatus]}${result} | ${perfdata}"
exit $exitstatus

