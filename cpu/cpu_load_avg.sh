
#!/bin/bash
LANG=C
PATH=/sbin:/usr/sbin:/bin:/usr/bin
interval=1
length=86400
for i in $(seq 1 $(expr ${length} / ${interval}))
do
  date
  LANG=C ps -eTo stat,pid,tid,ppid,comm  --no-header | sed -e 's/^ \*//' | perl -nE 'chomp;say if (m!^\S*[RD]+\s*!)'
  date
  cat /proc/loadavg
  echo -e "\n"
  sleep ${interval}
done
