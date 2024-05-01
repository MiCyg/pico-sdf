#!/usr/bin/python
import os
import shutil
from pathlib import Path
import serial.tools.list_ports
import argparse
import serial.tools.miniterm


COLOR='\033[0;35m'
NC='\033[0m' # No Color

CURRENTPATH 	= Path.cwd()
PICO_MDF_PATH	= Path(os.environ['PICO_MDF_PATH'])
PICO_STDPROJ	= PICO_MDF_PATH/'stdproj'
BUILDDIR		= 'build'
PICO_VID		= 0x11914
# MOUNTPATH		= '/mnt'
# DEVNAME			= 'RPI-RP2'


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

def pico_swd_flash(args):
	speed = 5000
	if len(args) != 0:
		speed = int(args[0])


	print(COLOR, 'Flash program', NC)
	findFilename = [elfName for elfName in os.listdir(CURRENTPATH/BUILDDIR) if elfName.endswith('.elf')]
	if len(findFilename) == 1:
		command = 'sudo openocd -f interface/cmsis-dap.cfg -f target/rp2040.cfg -c \"adapter speed %d\" -c \"program %s/%s verify reset; exit;\"'%(speed, CURRENTPATH/BUILDDIR, findFilename[0])
		return os.system(command)
	elif len(findFilename) == 0:
		print(COLOR, 'Cannot find .elf file', NC)
		return -1
	else:
		print(COLOR, 'find other .elf file', NC)
		return -2


def pico_monitor():
	# print(COLOR, 'pico monitor.', NC)
	
	ports = serial.tools.list_ports.comports()

	devicePath = None

	findDevices = 0
	for port in sorted(ports):
		if port.vid == PICO_VID:
			findDevices+=1
			devicePath = port
	
	# must choose port if is more than one picoprobe
	if findDevices>1:
		devicePath = None

	if not devicePath:
		print(COLOR, 'Choose port', NC)

		devicePath = serial.tools.miniterm.ask_for_port()
		if not devicePath:
			print("Port is not choosen.")
			return -1

	ser = serial.Serial(port=devicePath, baudrate=115200)
	miniterm = serial.tools.miniterm.Miniterm(
		serial_instance=ser,
		echo=False,
		filters=[]
		)

	miniterm.exit_character = chr(0x1d) # GS/CTRL+]
	miniterm.menu_character = chr(0x14) # Menu: CTRL+T
	miniterm.raw = False

	miniterm.set_rx_encoding('UTF-8')
	miniterm.set_tx_encoding('UTF-8')

	# if not args.quiet:
	print(COLOR, '--- Miniterm on {p.name}  {p.baudrate},{p.bytesize},{p.parity},{p.stopbits} ---'.format(p=miniterm.serial), NC)
	print(COLOR, '--- Quit: {} | Menu: {} | Help: {} followed by {} ---'.format(
		serial.tools.miniterm.key_description(miniterm.exit_character),
		serial.tools.miniterm.key_description(miniterm.menu_character),
		serial.tools.miniterm.key_description(miniterm.menu_character),
		serial.tools.miniterm.key_description('\x08')), NC)

	miniterm.start()
	try:
		miniterm.join(True)
	except KeyboardInterrupt:
		pass

	print(COLOR, '\n--- exit ---', NC)
	miniterm.join()
	miniterm.close()



def pico_create_project(projectName:str):
	if projectName in os.listdir():
		print('Folder %s is already exist here.'%projectName)
		return 
	
	shutil.copytree(PICO_STDPROJ, CURRENTPATH/projectName)
	
	print(COLOR, 'Project is created.', NC)



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
		err = pico_swd_flash(flash)
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
		err = pico_create_project(create_proj[0])
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
		# action='store_true', 
		nargs=1,
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
