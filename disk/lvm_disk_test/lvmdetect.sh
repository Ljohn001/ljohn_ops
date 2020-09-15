distro=$(cat /etc/issue | head -n 2 | tr -d "\n" | tr "[:upper:]" "[:lower:]")
device=$(fdisk -l | grep -w 8e | head -n 1 | cut -c-8)
partcount=$(fdisk -l | grep $device | sed 1d | grep -c $device)
newpartnum=$(($partcount+1))
startsector=$(fdisk -l | grep -w 8e | tail -1 | tr " " "\n" | sed "/^$/d" | head -n 3 | tail -1)
newstartsector=$(($startsector+1))
endsector=$(fdisk -l | grep sectors | head -n 1 | tr " " "\n" | tail -2 | head -n 1)
newendsector=$(($endsector-1))
fdisk $device <<EOF
n
p
$newpartnum
$newstartsector
$newendsector
t
$newpartnum
8e
w
EOF
