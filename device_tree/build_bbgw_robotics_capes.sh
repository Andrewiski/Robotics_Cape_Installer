#!/bin/bash


TREE_BBGW_RC=am335x-bonegreen-wireless-roboticscape.dtb
UENV=/boot/uEnv.txt

KERNEL="$(uname -r)"
UNAME="$(sed -n -e '/uname_r=/ s/.*\= *//p' /boot/uEnv.txt)"



################################################################################
# Sanity Checks
################################################################################

# make sure the user is root
if [ `whoami` != 'root' ]; then
	echo "You must be root to run this."
	exit 1
fi

# make sure the release is really jessie
if ! grep -q "8." /etc/debian_version ; then
	echo "ERROR: This is not Debian Jessie."
	echo "Flash the latest Jessie image to your BBB"
	echo "or use the Wheezy branch of this installer."
	exit 1
fi


echo "Building Beagle Bone Green Wireless Robotics Cape Device Tree"
cp device_tree/am335x-roboticscape-bbgw.dtsi /opt/source/dtb-4.4-ti/src/arm/am335x-roboticscape-bbgw.dtsi
cp device_tree/am335x-bonegreen-wireless-roboticscape.dts /opt/source/dtb-4.4-ti/src/arm/am335x-bonegreen-wireless-roboticscape.dts
make -C /opt/source/dtb-4.4-ti src/arm/am335x-bonegreen-wireless-roboticscape.dtb
cp /opt/source/dtb-4.4-ti/src/arm/am335x-bonegreen-wireless-roboticscape.dtb "/boot/dtbs/$UNAME/am335x-bonegreen-wireless-roboticscape.dtb" 

cp device_tree/RoboticsCapeBBGW-00A0.dts /opt/source/bb.org-overlays/src/arm/RoboticsCapeBBGW-00A0.dts
make -C /opt/source/bb.org-overlays src/arm/RoboticsCapeBBGW-00A0.dtbo
cp /opt/source/bb.org-overlays/src/arm/RoboticsCapeBBGW-00A0.dtbo "/lib/firmware/RoboticsCapeBBGW-00A0.dtbo"    
echo "Finished Building Beagle Bone Green Wireless Robotics Cape Device Tree"
exit 0
