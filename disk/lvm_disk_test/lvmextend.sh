device=$(fdisk -l | grep -w 8e | head -n 1 | cut -c-8)
partnumber=$(fdisk -l | grep $device | sed 1d | grep -c $device)
pvcreate $device$partnumber
volgroupname=$(vgdisplay | grep -w "VG Name" | cut -b10- | tr -d " ")
vgextend $volgroupname $device$partnumber
volgroupchars=$(echo $volgroupname | wc --chars)
totalchars=$(($volgroupchars+13))
lvmname=$(df -h | grep -w $volgroupname | head -n 1 | cut -b$totalchars-)
set $lvmname
lvmname=$1
lvextend -l +100%FREE /dev/$volgroupname/$lvmname
resize2fs /dev/$volgroupname/$lvmname
