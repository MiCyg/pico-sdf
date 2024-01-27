#!/usr/bin/python
import os
from pathlib import Path
import serial.tools.list_ports
import argparse


COLOR='\033[0;35m'
NC='\033[0m' # No Color

CURRENTPATH = Path.cwd()
ENV_PATH	= 'PICO_SDK_PATH'
BUILDDIR	= 'build'
MOUNTPATH	= '/mnt'
DEVNAME		= 'RPI-RP2'


def pico_clear():
	print(COLOR, 'pico clear', NC)

	if os.path.exists(BUILDDIR):
		return os.system('rm -r %s'%BUILDDIR)
	else:
		return -1
	
def pico_build():
	if 'PICO_SDK_PATH' in list(os.environ.keys()):
		print(COLOR, 'Build binaries...', NC)
		return os.system('mkdir -p %s'%(CURRENTPATH/BUILDDIR) + ' && cd %s'%BUILDDIR + ' && cmake ..' + ' && make')
		
	else:
		print(COLOR, 'Cannot find \'PICO_SDK_PATH\' variable. Try \'get_pico\'', NC)
		return -1

def pico_swd_flash():
	print(COLOR, 'Flash program', NC)
	findFilename = [elfName for elfName in os.listdir(CURRENTPATH/BUILDDIR) if elfName.endswith('.elf')]
	if len(findFilename) == 1:
		command = 'sudo openocd -f interface/cmsis-dap.cfg -f target/rp2040.cfg -c \"adapter speed 5000\" -c \"program %s/%s verify reset exit\"'%(CURRENTPATH/BUILDDIR, findFilename[0])
		return os.system(command)
	elif len(findFilename) == 0:
		print(COLOR, 'Cannot find .elf file', NC)
		return -1
	else:
		print(COLOR, 'find other .elf file', NC)
		return -2

def pico_monitor():
	print(COLOR, 'pico monitor.', NC)
	ports = serial.tools.list_ports.comports()
	devicePath = None
	for port, desc, hwid in sorted(ports):
		if desc.startswith('Picoprobe'):
			devicePath = port

	if not devicePath:
		print('Can not find picoprobe path.')
		return -1
	
	print(COLOR, 'START MINICOM!', NC)
	return os.system('minicom --device %s --baudrate 115200'%devicePath)


def pico_create_project():
	print("function not work yet")



def runflow(clear, build, flash, monitor):
	err = 0
	if (clear):
		err = pico_clear()
		if err != 0:
			return err

	
	if (build):
		err = pico_build()
		if err != 0:
			return err
	
	if (flash):
		err = pico_swd_flash()
		if err != 0:
			return err
	
	if (monitor):
		err = pico_monitor()
		if err != 0:
			return err
		
	return 0
		


def config(create_proj):
	err = 0
	if create_proj:
		err = pico_create_project()
		if err != 0:
			return err
	return err



if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	
	parser.add_argument(
		"-b", "--build", help = "build program", 
		action='store_true', 
		required=False
		)
	
	parser.add_argument(
		"-f", "--flash", help = "flash program", 
		action='store_true', 
		required=False
		)
	
	parser.add_argument(
		"-m", "--monitor", help = "run monitor (MINICOM)",
		action='store_true', 
		required=False
		)
	parser.add_argument(
		"-c", "--clear", help = "clear project",
		action='store_true', 
		required=False
		)
	

	parser.add_argument(
		"-cp", "--create-project", help = "create init projest with specific name",
		nargs=1,
		required=False
		)
	
	# Read arguments from command line
	args = parser.parse_args()

	config(args.create_project)

	runflow(args.clear, args.build, args.flash, args.monitor)
