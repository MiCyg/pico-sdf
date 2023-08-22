#!/bin/bash

CURRENTPATH=`pwd`
BUILDDIR=build
MOUNTPATH="/mnt"
DEVNAME="RPI-RP2"


COLOR='\033[0;35m'
NC='\033[0m' # No Color

# make dir 'build'

# some functonalies
pico_build () {
	# build binaries
	isPicoEnvironment=`env | grep PICO_SDK_PATH`
	if [ $isPicoEnvironment ] ; then
		echo -e "${COLOR}Build binaries...${NC}"
		mkdir -p ${CURRENTPATH}/${BUILDDIR}
		cd ${BUILDDIR}
		cmake ..
		make
	else
		echo -e "${COLOR}Cannot find 'PICO_SDK_PATH' variable. Try 'get_pico'${NC}"

	fi

}


flashSuccess=0
pico_flash () {
	# 1. find mounted storages 
	# 2. if not find storages on name "RPI-RP2" echo "not find pico on boot mode enter pico on bot mode" and wait
	# 3. mount rpi and copy u2f file
	# findDevice=`lsblk -d -o +VENDOR,MODEL | grep RPI`
	pathToDisk="/dev/disk/by-label"
	
	# if exist disk directory
	if [ -d $pathToDisk ]; then
		
		# check name of finding disk
		findDevice=`ls $pathToDisk/`
		if [ $findDevice = $DEVNAME ]; then

			echo -e "${COLOR}Programming $findDevice...${NC}"

			# find link directory
			# mountSource=`readlink -f /dev/disk/by-label/$DEVNAME` 

			sudo mount -m LABEL=$DEVNAME $MOUNTPATH/$DEVNAME
			binName=`ls $CURRENTPATH/$BUILDDIR/ | grep "\.uf2"`
			# ls $CURRENTPATH/build/*.uf2
			sudo cp $CURRENTPATH/$BUILDDIR/$binName $MOUNTPATH/$DEVNAME/
			
			sudo umount $MOUNTPATH/$DEVNAME/
			sudo rmdir  $MOUNTPATH/$DEVNAME/

			flashSuccess=1
			echo -e "${COLOR}Programming success!${NC}"

		else
			echo "ERROR: cannot find device. Enter your raspberry pico into boot mode."
		fi



	else
		echo "ERROR: cannot find device. Enter your raspberry pico into boot mode."
	fi

}

pico_monitor () {
	pathToSerial="/dev/serial/by-id/"

	# if exist disk directory
	if [ -d $pathToSerial ]; then
		
		# check name of finding disk
		findDevice=`ls $pathToSerial/`

		# echo "Find following devices:"
		# iter=0
		# for dev in $findDevice
		# do
		# 	echo "  $iter) $dev"
		# 	(( iter++ ))
		# done
		
		if [ $findDevice ] ; then

			# find link directory
			serialDevicePath=`readlink -f $pathToSerial/$findDevice` 
			echo -e "${COLOR}START MINICOM!${NC}"
			
			minicom --device $serialDevicePath --baudrate 115200

		else
			echo "ERROR: cannot connect to serial port open you must open serial port on your device."
		fi



	else
		echo "ERROR: cannot connect to serial port open you must open serial port on your device."
	fi	


}

pico_clear(){
	buildDirExist=`ls | grep $BUILDDIR`
	if [ $buildDirExist ] ; then
		rm -r $BUILDDIR
		echo -e "${COLOR}Clean completed.${NC}"

	else
		echo -e "${COLOR}'$BUILDDIR' folder not find. Nothing to do.${NC}"

	fi

}

projectName=""
pico_create_project(){
	
	isPicoEnvironment=`env | grep PICO_SDK_PATH`
	if [ $isPicoEnvironment ] ; then

		# echo $projectName

		echo -e "${COLOR}Start to create project '$projectName'.${NC}"
		
		
		cp $PICO_SDK_PATH/external/pico_sdk_import.cmake ./

		# create CMakeLists.txt file
		echo "cmake_minimum_required(VERSION 3.13)"		 > CMakeLists.txt
		echo "include(pico_sdk_import.cmake)" 			>> CMakeLists.txt
		echo "project($projectName C CXX ASM)" 			>> CMakeLists.txt
		echo "set(CMAKE_C_STANDARD 11)" 				>> CMakeLists.txt
		echo "" 										>> CMakeLists.txt
		echo "set(CMAKE_CXX_STANDARD 17)" 				>> CMakeLists.txt
		echo "pico_sdk_init()" 							>> CMakeLists.txt
		echo "add_executable(main" 						>> CMakeLists.txt
		echo "main.c" 									>> CMakeLists.txt
		echo ")" 										>> CMakeLists.txt
		echo "" 										>> CMakeLists.txt
		echo "pico_enable_stdio_usb(main 1)" 			>> CMakeLists.txt
		echo "pico_enable_stdio_uart(main 1)" 			>> CMakeLists.txt
		echo "pico_add_extra_outputs(main)" 			>> CMakeLists.txt
		echo "target_link_libraries(main pico_stdlib)" 	>> CMakeLists.txt


		# create main.c file
		echo "#include \"pico/stdlib.h\""	 > main.c
		echo ""								>> main.c
		echo "int main() {"					>> main.c
		echo "	stdio_init_all();"			>> main.c
		echo ""								>> main.c
		echo "	while(1);"					>> main.c
		echo "}"							>> main.c

		# create file for vscode 
		mkdir -p .vscode
		echo "{"														 > .vscode/c_cpp_properties.json
		echo "    \"configurations\": ["								>> .vscode/c_cpp_properties.json
		echo "        {"												>> .vscode/c_cpp_properties.json
		echo "            \"name\": \"Linux\","							>> .vscode/c_cpp_properties.json
		echo "            \"includePath\": ["							>> .vscode/c_cpp_properties.json
		echo "                \"\${workspaceFolder}/**\","				>> .vscode/c_cpp_properties.json
		_path=$PICO_SDK_PATH
		echo "                \"$_path/**\","				 			>> .vscode/c_cpp_properties.json
		_path=$PICO_EXTRAS_PATH
		echo "                \"$_path/**\","				 			>> .vscode/c_cpp_properties.json
		_path=$PICO_PLAYGROUND_PATH
		echo "                \"$_path/**\","				 			>> .vscode/c_cpp_properties.json
		echo "            ],"											>> .vscode/c_cpp_properties.json
		echo "            \"intelliSenseMode\": \"windows-msvc-x64\","	>> .vscode/c_cpp_properties.json
		echo "        }"												>> .vscode/c_cpp_properties.json
		echo "    ],"													>> .vscode/c_cpp_properties.json
		echo "    \"version\": 4"										>> .vscode/c_cpp_properties.json
		echo "}"														>> .vscode/c_cpp_properties.json




	else
		echo -e "${COLOR}Cannot find 'PICO_SDK_PATH' variable. Try 'get_pico'${NC}"

	fi
}

case $1 in

	create_project)
		projectName=$2
		if [ $projectName ] ; then
			projectExist=`ls`
			if [[ ! $projectExist ]] ; then
				pico_create_project
			else
				echo -e "${COLOR}Folder must be empty!${NC}"
			fi
		else
			echo -e "${COLOR}You must type name of project${NC}"
		fi	
		;;

	clean)
		pico_clear
		;;

	build)
		pico_build
		;;

	flash)
		pico_build
		pico_flash
		;;

	flash_monitor)
		pico_build
		pico_flash

		if [ $flashSuccess -eq 1 ] ; then
			pico_monitor
		fi
		;;

	monitor)
			pico_monitor
		;;

	help)
		echo "pico.sh parameters:"
		echo "  create_project - create start project on specific name"
		echo "  clean          - clear build folder"
		echo "  build          - build application"
		echo "  flash          - build and flash to device (device must be in boot mode)"
		echo "  flash_monitor  - build, flash and open serial monitor (minicom)"
		echo "  help           - shows this information"
		;;

	*)
		echo "Command not found. Type 'help' to show parameters"
		;;
esac
