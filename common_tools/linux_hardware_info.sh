#!/bin/sh
#主机名
hostname=`hostname`
#电脑型号
ComputerModel=`/usr/bin/sudo /usr/sbin/dmidecode | grep -A2 "System Information" | awk -F ':' '{print $2}' | grep -v '^$' |sed -e 's/Inc//g' -e 's/ //g' -e ':a;N;s/\n/ /g;ta' -e 's/.//g'`
x86_64=`getconf LONG_BIT`
#系统版本
SystemVersion=`cat /etc/redhat-release`
#内核版本
KernelVersion=`uname -r`
#内核参数
KernelPara=`cat /proc/cmdline`

#raid信息
RaidInfo=`lspci |grep -i raid`
if [ -z "$RaidInfo" ];then
RaidInfo='None'
fi

#电梯算法
IOScheduler=`cat /sys/block/sda/queue/scheduler`

#qemu信息
QemuInfo=`/usr/libexec/qemu-kvm -version | grep -i version`
#libvirtd信息
LibvirtdInfo=` libvirtd -V`
#guest list
GuestList=`virsh list`


#CPU信息
CPUNum=`cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l`
CPUNucleusNum=`cat /proc/cpuinfo| grep "cpu cores"| uniq | awk -F ':' '{print $2}' | sed 's/ //g'`
CPUThreadNum=`cat /proc/cpuinfo| grep "processor"| wc -l`
CPUmodel=`cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq | sed 's/ //g'`
CPUTotalnuclearNum=$[$CPUNum*$CPUNucleusNum]

#内存
MemoryNominalSpeed=`/usr/bin/sudo /usr/sbin/dmidecode -t memory | grep 'Speed:' |head -1|awk '{print $2}' `
MemoryConfiguredSpeed=`/usr/bin/sudo /usr/sbin/dmidecode -t memory | grep 'Configured Clock Speed' |head -1|awk '{print $4}' `
MemoryNameDDR=`/usr/bin/sudo /usr/sbin/dmidecode -t memory | grep 'DDR' |head -1 | awk '{print $2}' `


MemoryUsedSlot=`/usr/bin/sudo /usr/sbin/dmidecode -t memory | grep -E Size | grep -Ev  'Installed Size|Maximum Memory Module Size|Maximum Total Memory Size:|Enabled Size:|No' | wc -l`
MemorySum=`/usr/bin/sudo /usr/sbin/dmidecode -t memory | grep Size | awk '{print $2}' | grep -v 'No' | awk '{sum +=$1};END{print sum/1024}'`
MemoryTotalSlotNum=`/usr/bin/sudo /usr/sbin/dmidecode -t memory | grep "Number Of Devices:" |head -1| awk -F':' '{print $2}' | sed 's/ //g'`
MemoryMaximumCapacity=`/usr/bin/sudo /usr/sbin/dmidecode -t memory | grep "Maximum Capacity:"|head -1 | awk -F':' '{print $2}' | sed 's/ //g'`


#显卡
VGA=`/usr/bin/sudo /sbin/lspci |grep VGA | awk -F ':' '{print $3}' | awk -F '.' '{print $1$2}'| sed -e 's#^ ##g'`
#网卡
network=`/usr/bin/sudo /sbin/lspci | grep Ethernet | awk -F ':' '{print $3}' | uniq | sed 's/^ //g'`
#系统序列号
SystemSerialNum=`/usr/bin/sudo /usr/sbin/dmidecode -s system-serial-number`
#磁盘信息
disk=`lsblk`


#打印
echo -e "主机名  "'\t'$hostname
echo -e "电脑型号"'\t'$ComputerModel
echo -e "序列号  "'\t'$SystemSerialNum
echo -e "发行版本"'\t'$SystemVersion"X"$x86_64
echo -e "CPU "'\t\t'$CPUmodel"(*"$CPUNum") "$CPUTotalnuclearNum"cores" $CPUThreadNum"threads"
echo -e '\n'

echo -e "内核版本"'\t'$KernelVersion
echo -e "内核参数"'\t'$KernelPara
echo -e '\n'

echo -e "单内存  "'\t'"Type:"$MemoryNameDDR" Nominal_Speed:"$MemoryNominalSpeed"MHz(MT/s) "" Configured_Clock_Speed:"$MemoryConfiguredSpeed"MHz(MT/s) "
echo -e "总内存   "'\t'"Sum_Size:"$MemorySum"GB ""Sum_Slot:"$MemoryTotalSlotNum "Used_Slot:"$MemoryUsedSlot" Maximum_memory_support:"$MemoryMaximumCapacity
echo -e '\n'

echo -e "显卡    "'\t'$VGA
echo -e '\n'

echo -e "QEMU_KVM"'\t'$QemuInfo
echo -e "Libvirt"'\t\t'$LibvirtdInfo
echo -e '\n'
echo -e "Guest List"'\t\n'"${GuestList}"
echo -e '\n'

echo -e "网卡"'\t\t'$network | sed 's/) [A-Z a-z 1-9]/)\n &/g' | sed -e 's/^ /\t\t/g' -e 's/\t) /\t/g' | grep -v '^$'
echo -e '\n'

echo -e "RAID"'\t\t'$RaidInfo
echo -e "IOScheduler:"'\t'$IOScheduler

echo -e '\n'
echo -e "磁盘"'\t\t\n'"${disk}"