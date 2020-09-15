LVM_operations
Create, Format, Mount, Extend and Reduce LVM partitions with a Shell Script

HD 2018

Valid options are:
--vgextend: Extend Volume Groups.

--lvcreate: Create Logical Volumes, format and mount it.

--lvextend: Extend mounted swap, xfs or ext4 Logcal Volumes.

--swapfile: Mount an existing Logical Volume as SWAP.

Reduce swap, xfs or ext4 Logical Volume feature is under development and rarely needed.

LVM Reminder
VOLUME GROUP NAME: Name of the volumegroup associate. For Example VolGroup001, vgroot.

LVM NAME: Logical Volume Group name. For example root, var_log, LogicalVolume01.

MOUNT POINT: Mountpoint for the existing and or future mountpoint.

SIZE: Size for the new or existing filesystem. Value on Gigabytes

DEVICE: Physical device to be added. Examples should be /dev/xvdf /dev/xvdf1.

SWAP FILE PATH: Swap File path.

This guide is just to explain the expected user inputs to the script, in order to make it run as expected. you can find this questions in any selected option.

#The questions that you will find when running the script are:

Volume Group (Existing Volume Group List)
Insert an existing Volume Group name from below list:

Please select a VG from the given list, respect letter case, wrong values will be ignored. Partition Type

Please select the partition type to create [ ext4 / xfs / swap ] For swap you can also use the option --swapfile The accepted options are ext4 xfs and swap, without uppercase, be careful with this option.

Logical Volume
(Existing Logical Volume List) Insert the required Logical Volume Name: For --lvextend option: Select a LV from the given list, respect letter case, wrong values will be ignored. For --swapfile option: Select a LV from the given list, respect letter case, the selected volume will be formatted later. wrong values will be ignored.

For --lvcreate option: Type a LV name different from the given list, the name should give a clue of the future content.

Extend size to add
Insert the size that you want to add to the Logical Volume

Should be $FREEVG or less, use the same format, input the letter: m or G :

For --swapfile option: $FREEVG shown the free space left in the Volume Group.

Input the letter without spaces, as 10000m , 10G.

The value can be rounded later by system. m for megabytes G for Gigabytes

Mount Point Path
Insert a new or existing Mount Point should be an empty folder that starts and ends with /

For --lvcreate option: Please instert the required full mount path, example: /media/lvol0/

If the folder does not exist, it will be created If the folder exist, it should be empty If the folder has files, can cause mount errors.

Add Logical Volume into a Volume Group (Partition List) Please select an empty lvm device to join it into the Volume Group The selected device will be added to the selected Volume Group The partition type should be lvm, you shoud part it manually before run the script.

#Action Confirmation (Action Warning)

Continue? Please be careful with these actions

To continue type y Other input will kill the script at in current step.
