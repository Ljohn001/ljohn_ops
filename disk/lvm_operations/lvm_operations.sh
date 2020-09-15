#!/bin/bash

#Hernán De León

NUMARGS=$#
OPTION="$1"

VOLUMEGROUP="0"
FREEVG="0"
DUMPPATH="/recovery"

#Colors
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'


LVreduce(){

    printf " $cyn The actual FREE space inside $VOLUMEGROUP is:  $end"
    vgs --units m | grep $VOLUMEGROUP | awk '{print $7}'
   
    printf "\n\n $cyn Available Logical Volumes inside $VOLUMEGROUP are: \n $end"
   
    printf "LV       LSize\n"
    lvs | grep $VOLUMEGROUP | awk {'print $1 "    " $4'}
  
    printf "\n $cyn Insert the LV Name: $end "
    read VOLUMENAME

  #check if Volume Name exist
    lvdisplay | grep 'LV Name' | grep $VOLUMENAME || clear
    lvdisplay | grep 'LV Name' | grep $VOLUMENAME || printf "\n\nLogical Volume does not exist inside $VOLUMEGROUP, please put another name:  \n\n\n\n" 
    lvdisplay | grep 'LV Name' | grep $VOLUMENAME || LVreduce
        
    USED=$(df -h | grep $VOLUMENAME | awk '{print $3}')
    AVAILABLE=$(df -h | grep $VOLUMENAME | awk '{print $4}')
   
  ###
 
    #LOGICAL VOLUME PATH = /dev/VolumeGroup/Volumename
    DEV="/dev/$VOLUMEGROUP/$VOLUMENAME"
  
    # equivale a 
    #DEVICE MAPPER LV PATH = /dev/mapper/VolumeGroup-Volumename 
    DEV_MAP="/dev/mapper/$VOLUMEGROUP-$VOLUMENAME"
  
    #PHYSICAL DEVICE PATH = /dev/mapper/VolumeGroup-Volumename 
    # PV_DEV=$(/dev/sdb1) 
  
    clear
  
    # exit if the device is not mounted  
        mount | grep $VOLUMENAME || printf "$red \n\n The selcted device is not mounted." &&
        mount | grep $VOLUMENAME || printf "$red Please MOUNT $VOLUMENAME before run this script \n\n." &&
        lsblk | grep $VOLUMENAME | grep SWAP || mount | grep $VOLUMENAME || exit 0 
        clear
        
    ###### GET THE PARTITION TYPE ! SWAP - EXT4 - XFS 
    #swap or no swap
    lsblk | grep $VOLUMENAME | grep SWAP && TYPE="swap"

    if [[ "$TYPE" = "swap" ]]; then
        clear
        printf "$yel The device is mounted as SWAP $end"
        USED=$(lvdisplay $VOLUMEGROUP/$VOLUMENAME | grep Size | awk '{print $3}')
        printf "\n $cyn Insert the final size that you want to achieve in $VOLUMENAME"
        printf "\n $yel Please also type the letter
            $blu m $end or $blu G $end : "   
            read NEWSIZE
    else   
        
        # GET MOUNT POINT
        MOUNTPOINT=$(df | grep "$VOLUMENAME" | awk '{print $6}')
        
        #GET PARTITION TYPE 
        type=$(mount | grep $MOUNTPOINT | awk '{printf $5}')
        df -h | grep --color Used &&  
        df -h | grep $VOLUMENAME | grep --color "$USED"
        
          printf "\n $cyn Partition type is $type "
          printf "\n $cyn Insert the final size that you want to achieve in $VOLUMENAME"
          printf "\n $yel Should be more than used $USED, also type the letter
            $blu m $end or $blu G $end : "   
            read NEWSIZE
    fi
   
 #    check required size 
 #    if [ $USED -gt $NEWSIZE ]; then
 #       echo "The final scope $NEWSIZE is smaller than $USED, that is acctually used by $VOLUMENAME "
 #       LVreduce
 #   fi   

}



generate_dump(){ 
    ## Generate dump from existing filesystem

    ##################################################install required

    printf "\n $mag Creating Dump path in $DUMPPATH $end"

    if [ ! -d "$DUMPPATH" ]; then
      mkdir -p $DUMPPATH && printf "\n $mag Creating Dump path in $DUMPPATH $end"
    fi

    DUMMPATH=$("$DUMPPATH"/"$VOLUMENAME"_FILESYSTEM_DUMP_`date +%F`.dump)

    printf "The mount point of $VOLUMENAME is $MOUNTPOINT "

  #ext4 - xfs health check
   if [[ "$TYPE" = "ext4" ]]; then
                
            printf "\n $mag Installing required dump \n " 

            # REDHAT xfsdump -I || yum -y install xfsdump >/dev/null 2>&1
            #SUSE zypper
                xfsdump -I || zypper install dump
            
                if [ $? -eq 0 ]; then
                echo "Package xfsdump exist \n $end"
                else
                echo " $red Canceling as cannot install dump $end"
                exit 1
                fi
                
                dump -0uf $DUMPPATH $DEV_MAP
      
                if [ $? -eq 0 ]; then
                echo "$grn Succesful dump generated  at "$DUMPPATH"/"$VOLUMENAME"_FILESYSTEM_DUMP.dump $end"
                else
                echo "$red Canceling, dump incorrect $end"
                exit 1
                fi
   else  if [[ "$TYPE" = "xfs" ]]; then
      
      
            printf "\n $mag Installing required xfsdump \n " 

            # REDHAT 
            xfsdump -I || yum -y install xfsdump >/dev/null 2>&1
            #SUSE - zypper xfsdump -I || zypper install xfsdump
            
                if [ $? -eq 0 ]; then
                echo "Package xfsdump exist \n $end"
                else
                echo " $red Canceling as cannot install xfsdump $end"
                exit 1
                fi
                
                 xfsdump -J - $MOUNTPOINT > $DUMPPATH >/dev/null 2>&1
                if [ $? -eq 0 ]; then
                echo "$grn Succesful dump generated  at "$DUMPPATH"/"$VOLUMENAME"_FILESYSTEM_DUMP.dump $end"
                else
                echo "$red Canceling, dump incorrect $end"
                exit 1
                fi

  
         fi
   fi
   
   
 }


resize_force_umount(){
 ## Umount current filesystem
    
  printf "\n $yel The used space in $VOLUMENAME is $USED Used and the size scope is $NEWSIZE \n"

  #ext4 - xfs health check
   if [[ "$TYPE" = "ext4" ]]; then
       fsck -f $DEV || printf "$red The device selected has errors.\n $end" && exit 1
   else  if [[ "$TYPE" = "xfs" ]]; then
       xfs_check $DEV fsck -f $DEV || printf "$red The device selected has errors.\n $end" && exit 1
         fi
   fi
   
  
  printf " $yel We are about to umount, reduce and mount the $VOLUMENAME in $MOUNTPOINT $end \n "
    are_you_sure

    fuser -ck $MOUNTPOINT && >/dev/null 2>&1 
    umount $MOUNTPOINT >/dev/null 2>&1
     if [ $? -eq 0 ]; then
      printf "$grn Succesful umount $end \n\n"
     else
      printf "$red Unsuccesful umount.\n"
      printf " trying to remount the $VOLUMENAME in $MOUNTPOINT $end "
      mount $DEV $MOUNTPOINT  #To try to remount if issue
      df | grep $DEV_MAP | awk '{print $6}' &&  printf "$grn Succesfully Re-mounted $end \n\n"
      exit 1 
     fi
}

## Destroy previous filesystem
# resize_destroy_lvm(){
#    printf "$yel Removing previous filesystem $end "
# lvremove -f $DEV  >/dev/null 2>&1
#  if [ $? -ne 0 ]; then
#   printf "$red Error on removal. Please check $VOLUMENAME status . $end"
#   lvdisplay $VOLUMENAME
#   exit 1
#  fi
#}

## Check that there-s enought space free on the volumegrup previous to create any new per requirement

LVreduce2(){

    # mountpoint
    printf "The used space in $VOLUMENAME is $USED and the Available is $AVAILABLE \n"
                
    #ext4 - xfs health check
   if [[ "$TYPE" = "ext4" ]]; then
       fsck -f $DEV || printf "$red The device selected has errors.\n $end" && exit 1
   else  if [[ "$TYPE" = "xfs" ]]; then
       xfs_check $DEV fsck -f $DEV || printf "$red The device selected has errors.\n $end" && exit 1
         fi
   fi
   
   
               # e2fsck -f $DEV &&
               # resize2fs $DEV $NEWSIZE &&  
               # fsck -f $DEV && 
                lvreduce --size $NEWSIZE $DEV
                mount $DEV_MAP $MOUNTPOINT 
                lvdisplay $VOLUMEGROUP/$VOLUMENAME
                printf "\n The used space in $VOLUMENAME is $USED Used and the Available is $AVAILABLE \n"
                printf  "\n --> NEW $VOLUMENAME size"
                lvdisplay $DEV | grep "LV Size"
                df | grep $DEV_MAP | awk '{print $6}' &&  printf "$grn Succesfully Re-mounted $end \n\n"
                
}


check_vg_free_space()
    {
            vgdisplay | grep 'VG Name' | awk '{print $3}'
            printf "\n $cyn Insert an existing Volume Group name from below list: $end "
            read VOLUMEGROUP
                
        #checking if VG Name is wrong
            vgdisplay | grep $VOLUMEGROUP >/dev/null 2>&1 || check_vg_free_space  
        
        # if VG Name is ok 
            FREEVG=$(vgdisplay --noheadings --columns $VOLUMEGROUP |awk '{print $7}')    
    }

## Create lvm 
LVcreate(){

    printf "\n $cyn Please select the partition type to create [ ext4 / xfs / swap ] \n "
    read -p "\n For swap you can also use the option --swapfile : $end" TYPE
    
    echo $TYPE | grep -E 'ext4|xfs|swap' || printf " $yel Please insert a valid option $end \n " 
    echo $TYPE | grep -E 'ext4|xfs|swap' || LVcreate
      
    printf "$yel The actual FREE space inside $VOLUMEGROUP is: $end "
    vgs --units m | grep $VOLUMEGROUP | awk '{print $7}'
   
    printf "\nAvailable Logical Volumes inside $VOLUMEGROUP are: \n"
    printf "LV    LSize\n"
    lvs | grep $VOLUMEGROUP | awk {'print $1 "    " $4'}
  
    printf "\n$cyn Insert the required Logical Volume Name: $end "
    read VOLUMENAME

    # if $VOLMENAME already exist in LVcreate and lvextend
        if [[ "$STEP" = "lvextend" ]]; then
        lvdisplay | grep 'LV Name' | grep $VOLUMENAME ||  printf "\n\n $yel Logical Volume to extend does not exist, please put a name from the list:  \n $end "
        
        lvdisplay | grep 'LV Name' | grep $VOLUMENAME  || LVcreate
        
        fi
           if [[ "$STEP" = "lvcreate" ]]; then
        lvdisplay | grep 'LV Name' | grep $VOLUMENAME &&
        printf "\n\n $yel Logical Volume already exist, please put another name:  \n\n\n\n $end"
        
        
        lvdisplay | grep 'LV Name' | grep $VOLUMENAME && LVcreate
        
        fi
  
  clear
  
  ###
  
    #LOGICAL VOLUME PATH = /dev/VolumeGroup/Volumename
    DEV="/dev/$VOLUMEGROUP/$VOLUMENAME"
    
    # equivale a 
     #DEVICE MAPPER LV PATH = /dev/mapper/VolumeGroup-Volumename 
    DEV_MAP="/dev/mapper/$VOLUMEGROUP-$VOLUMENAME"
    
    #PHYSICAL DEVICE PATH = /dev/mapper/VolumeGroup-Volumename 
    # PV_DEV=$(/dev/sdb1) 
  
        # for CREATE SWAP option  --createswap  
    if [[ "$TYPE" = "swap" ]]; then
        echo ""
        else
        
        printf "\n $cyn Insert the size that you want to add to the Logical Volume $VOLUMENAME \n "
        printf " $cyn Should be $FREEVG or less, use the same format, input the letter \n: 
            $blu m $end or $blu G  :$end "
            
            read NEWSIZE
            echo " newsize $NEWSIZE - freevg $FREEVG "
                
            # m as egabytes
            # G as Gigabytes   
                lvcreate -L "$NEWSIZE" --yes -n $VOLUMENAME $VOLUMEGROUP
            # printf "\n Succesful create $VOLUMENAME in $VOLUMEGROUP with $NEWSIZE \n"
    fi 
      
}

   


cleandumps(){
    ## Restore lvm data

    cat $DUMPPATH/FILESYSTEM_DUMP.dump | xfsrestore -J - $MOUNTPOINT >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Dump restore succesful"
        rm -rf $DUMPPATH/FILESYSTEM_DUMP.dump
    else
        echo "Dump generation incorrect"
    fi
}


mountpoint(){
    
    if [[ "$STEP" = "lvreduce" ]]; then 
            are_you_sure
            mount $DEV $MOUNTPOINT >/dev/null 2>&1
        if [ $? -ne 0 ]; then
          echo "$grn Failed to mount $VOLUMENAME in $MOUNTPOINT $end"
          exit 1
        else   
           "\n $grn Logical Filesystem $VOLUMENAME has been succesfully re-mounted in $MOUNTPOINT \n $end "
        fi 
    fi 
        
   
    # for ext4 LVcreate option 
    if [[ "$TYPE" = "xfs" ]]; then
        printf "\n We are about to MOUNT this $VOLUMENAME, "
        are_you_sure
    
        printf "\n Insert a new or existing Mount Point \n "
        printf "should be an empty folder that starts and ends with / :  "
        read MOUNTPOINT 
    
        ls $MOUNTPOINT || mkdir -p $MOUNTPOINT ## only create the folder if it does not exist. 
        
            printf "\n The Volume $DEV  will be formatted as XFS and all the data inside will be lost. \n "
            are_you_sure

            mkfs.xfs $DEV &&
            mount $DEV $MOUNTPOINT >/dev/null 2>&1
        if [ $? -ne 0 ]; then
          echo "Failed to mount $VOLUMENAME in $MOUNTPOINT"
          exit 1
        fi 
    printf "\n Logical Filesystem $VOLUMENAME has been Mounted in $MOUNTPOINT \n "
    fi 
    
    
    
        # for xfs LVcreate option 
    if [[ "$TYPE" = "ext4" ]]; then
        printf "\n We are about to MOUNT this $VOLUMENAME, "
        are_you_sure
    
        printf "\n Insert a new or existing Mount Point \n "
        printf "should be an empty folder that starts and ends with / :  "
        read MOUNTPOINT 
    
        ls $MOUNTPOINT || mkdir -p $MOUNTPOINT ## only create the folder if it does not exist. 
    
        printf "\n The Volume $DEV  will be formatted as EXT4 and all the data inside will be lost!!. \n "
        are_you_sure

        mkfs.ext4 $DEV &&
        mount $DEV $MOUNTPOINT >/dev/null 2>&1
        
        if [ $? -ne 0 ]; then
          echo "Failed to mount $VOLUMENAME in $MOUNTPOINT"
          exit 1
        fi 
    printf "\n Logical Filesystem $VOLUMENAME has been Mounted in $MOUNTPOINT \n "
    fi 
    
        # for LVcreate and SWAP option  
    if [[ "$TYPE" = "swap" ]]; then
             printf "\n The Volume $DEV will be formatted as SWAP and all the data inside will be lost. \n "
            are_you_sure
            mkswap $DEV &&
            
#            echo "$DEV swap swap defaults 0 0  #added by script" >> /etc/fstab
            
            printf "\n  Old swap size \n"
            cat /proc/swaps
            
            echo ""
            #Enable the extended logical volume:
            swapon $DEV_MAP
            
            #Test that the logical volume has been extended properly:
            printf "\n\n\n  NEW swap size \n"
            cat /proc/swaps
        
    fi     
    
}


are_you_sure()
{
    y=0
  read -p "Continue? [y/n/]   (y)  " y
      
    # echo "${y,,}" #converto string to lowercase
    
        if [[ "${y,,}" != "y" ]]; then
            echo ""
            exit 1
        fi
}

############################################ MENU
menu(){
case "$OPTION" in 

  --lvcreate)
        STEP=lvcreate
    clear
    check_vg_free_space
        LVcreate
        mountpoint
    ;;
     
     
  --swapfile)
  
  # --swapfile \e[96mDEVICE \e[97mSWAPFILEPATH \e[95mSIZE\033[0m \033[0m
        
        TYPE="swap"
        clear
            check_vg_free_space
            LVcreate
            mountpoint 
            lsblk | grep $VOLUMENAME                
    ;;
     

  --vgextend)
    clear
    echo -en "\e[1m resize provided VolumeGroup with the selected space \033[0m\n"
               
    check_vg_free_space
    
    lsblk | grep part | grep -v sda
        printf "\n Please select an empty lvm device to join it into the Volume Group $VOLUMEGROUP : "
        read DEVICE   
        printf "\n Old "
        vgdisplay | grep "VG Size"
        echo ""
    vgextend $VOLUMEGROUP /dev/$DEVICE
    
    printf  "\n NEW "
        vgdisplay | grep "VG Size"
    
    ;;
    
  --lvextend)
        clear
        STEP=lvextend
    check_vg_free_space
    LVcreate
    # lvextend -l +$FREEVG $VOLUMENAME 
    
    clear 
    printf  "\n --> Old $VOLUMENAME size"
    lvdisplay $DEV | grep "LV Size"
    printf  "\n"
    lvextend -L+"$NEWSIZE" $DEV
    printf  "\n"
    resize2fs $DEV >/dev/null 2>&1
    xfs_growfs $DEV >/dev/null 2>&1
    
    printf  "\n --> NEW $VOLUMENAME size"
    lvdisplay $DEV | grep "LV Size"
    ;;
   
    --lvreduceTEST) #COMMENTED FOR TEST, 
        clear 
        STEP="lvreduce"
        
        printf " \n\n\n $red  Shrinking a logical volume is likely to destroy any filesystem
located on that volume if you do not make appropriate preparations. 
If you want to preserve existing files then you will need to: 
\n   1. Reduce the size of the filesystem by the required amount, then
\n   2. Reduce the size of the underlying block device (the logical volume) 
      to match that of the filesystem. 
          
This script will support you to reduce a Logical Volume safetly. $end \n\n "
        are_you_sure
        clear
        check_vg_free_space
        LVreduce 
        
        if [[ "$TYPE" = "swap" ]]; then
            printf "There is no data in a SWAP partition"
            swapoff $DEV
            lvreduce --size $NEWSIZE $DEV
            mkswap $DEV
            swapon $DEV
            
            else
                generate_dump
                resize_force_umount
                LVreduce2
            fi
          
          
     ;;
     
    --cleandumps)
    check_vg_free_space
    
      printf " $yel We are about to delete the dump file in "$DUMPPATH"/"$VOLUMENAME"_FILESYSTEM_DUMP.dump  "
      are_you_sure
      resize_destroy_lvm
    
    ;;
  --help)
     echo -en "\e[1mSelected option $OPTION is not valid \033[0m\n"
     menu_help
    ;;

   *)
  menu_help
   
   esac 
  }

  
## Help Menu
menu_help(){
  clear
  echo -en "\e[1mValid options are: \033[0m

 \e[94m --vgextend :\033[0m Resize Volume Group to a bigger size.
 \e[94m --lvcreate :\033[0m Create an LVM device that belongs to the provided volumegroup to an specific size.
 \e[94m --lvextend :\033[0m Resize the provided LUN to a bigger size.
 \e[94m --swapfile :\033[0m Create a swapfile from an existing Logical Volume
 \e[94m --cleandumps :\033[0m Clean all dumps. Used in case of not enought space available.


\e[1m Reminder :\033[0m
 \e[92mVOLUME GROUP NAME\033[0m Name of the volumegroup associate. For Example VolGroup001, vgroot.
 \e[93mLVM NAME\033[0m Logical Volume Group name. For example root, var_log, LogicalVolume01.
 \e[94mMOUNT POINT\033[0m Mountpoint for the existing and or future mountpoint.
 \e[95mSIZE\033[0m Size for the new or existing filesystem. Value on Gigabytes
 \e[96mDEVICE\033[0m Physical device to be added. Examples should be /dev/xvdf /dev/xvdf1.
 \e[97mSWAP FILE PATH\033[0m Swap File path.

"
exit 2
}


#########BEGIN
menu

