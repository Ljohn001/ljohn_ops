## Check Existing Space

Before you can enlarge the disk, first you have to check to see if it is possible:

**Check physical disk size versus the LVM size (using \*fdisk\*):**

- Run fdisk, to see if there is more space available that could be added to the LVM:
  `sudo fdisk -l`
- In most of our basic images, this should show just a single physical device, such as:
  `Disk /dev/vda: 32 GiB, 34359738368 bytes, 67108864 sectors` – *32 GB physical disk*
- It will also show the partition being used for the LVM:
  `Device Boot Start End Sectors Size Id Type/dev/vda1 2048 16777215 16775168 8G 8e Linux LVM`
  In this case it is an 8 GB partition (`/dev/vda1`)
- And finally it will also show the LVM itself:
  `Disk /dev/mapper/COMPbase--vg-root: 8 GiB, 8585740288 bytes, 16769024 sectors`

- [See the full fdisk output](https://carleton.ca/scs/2019/extend-lvm-disk-space/#slideme-see-the-full-fdisk-output)

So in this case, the Physical disk is **32 GB**, but only **8 GB** are currently allocated to the LVM and no other partitions are using the rest of the space for anything else. So we can extend it!

## Extend LVM using the script

If you are using one of our standard SCS images, either for **openstack** or for **virtualbox virtual machines**, it usually comes with an small script called **extend-lvm.sh**. The script is found in the home directory of the **student** user.

**To run the script:**

- Open a terminal
- Go to the directory with the script, usually: `cd ~student`
- Enter: `sudo ./extend-lvm.sh /dev/vda` – *NOTE: the /dev/vda may be different on your system, it is the device you found in [Check Existing Space](https://carleton.ca/scs/2019/extend-lvm-disk-space/#check-existing-space) above*

That’s it! Now when you run *fdisk*, you should see the LVM partition is the full size of the physical disk: `sudo fdisk -l`

## Extend LVM manually

Here are the steps to manually extend the LVM.

*NOTE: We assume the same setup as the above [Check Existing Space](https://carleton.ca/scs/2019/extend-lvm-disk-space/#check-existing-space)*

- Extend the physical drive partition:
  - `sudo fdisk /dev/vda` – *Enter the fdisk tool to modify /dev/vda*
    NOTE: End each one letter command by pressing [Enter]; if the instructions do not specify a specific response to a question, just press [Enter] to accept the default
  - `p` – ***p** command prints the disk info, same as running `fdisk -l /dev/vda`*
  - `d` – ***d** command delete the last partition (in this case, /dev/vda1)*
  - `n` `e` ***n** command creates a new partition; **e** makes that an extended partition*
  - `t` – ***t** changes the type of partition*
    `8e` – *Enter **8e** (lvm) as the partition type*
    NOTE: In some cases the disk uses **GPT** signature rather than **DOS**. In that case, use the `31` (lvm) as the partition type
  - `w` – ***w** writes the changes to disk and exits fdisk*
- Modify (extend) the LVM:
  - Tell LVM the physical partition size has changed: `sudo pvresize /dev/vda1`
  - Find the actual path of the LVM logical volume: `sudo lvdisplay` – *The **LV Path** is value needed*
  - Tell LVM to extend the logical volume to use all of the new partition size: `sudo lvextend -l +100%FREE /dev/COMPbase-vg/root` – *Using the **LV Path** from above*
- **Resize the file system:**
  `sudo resize2fs /dev/COMPbase-vg/root`

That’s it! Now, when you run `sudo fdisk -l`, it will show the LVM is using all of the space of the physical disk!
