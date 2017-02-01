@net file 1>nul 2>nul && (python -x "%~f0" "%~s1" & pause && goto :eof) || powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c ""%~fnx0"""" %~s1'" && goto :eof

# The above line elevates the script to admin rights and reruns itself 
# as a python script, ignoring the first line (-x argument).

# ------------------------------ BEGIN PYTHON ---------------------------------
import sys
import subprocess
import shutil
from pathlib import WindowsPath
import win32api

PRIMARY_DRIVE = 'C:'
SECONDARY_DRIVE = 'D:'

def move_and_link(path):

	# Sanity checks
	if not (path.exists() and path.is_dir() and path.is_absolute()):
		print("Invalid argument. Expected an absolute path to a directory.")
		print("Instead got [{}]".format(str(path)))
		sys.exit(1)

	target_drive = ''
	if path.drive == PRIMARY_DRIVE:
		target_drive = SECONDARY_DRIVE
	elif path.drive == SECONDARY_DRIVE:
		target_drive = PRIMARY_DRIVE
	else:
		print("Target is neither on primary nor secondary drive.")
		sys.exit(1)

	# Target path is on other drive
	target_path = WindowsPath(str(path).replace(path.drive, target_drive))

	# Check if path is a junction (and if so move the other way)
	command = 'dir "{}" | find "JUNCTION" | find "{}"'.format(path.parent, target_path)
	is_junction = (subprocess.call(command, shell=True) == 0)
	if is_junction:
		print("Target directory is a junction. Reversing the process.")
		path.unlink()
		(path, target_path) = (target_path, path)

	if target_path.exists():
		command = 'dir "{}" | find "JUNCTION" | find "{}"'.format(target_path.parent, path)
		is_junction = (subprocess.call(command, shell=True) == 0)
		if is_junction:
			# Remove junction and proceed
			target_path.unlink()
		else:
			print("Target exists and is not a junction. Aborting to prevent overwriting.")
			sys.exit(1)

	# Try creating the parent directory if it doesn't exist
	parent = target_path.parent
	if not parent.exists():
		parent.mkdir(parents = True)

	# Move using xcopy to ignore read onlys...
	command = 'xcopy /E /I /H /K /O "{}" "{}"'.format(path, target_path)
	exit_code = subprocess.call(command, shell=True)
	if exit_code != 0:
		print("Uh oh, xcopy exited unexpectedly with exit code " + exit_code)
		sys.exit(1)

	# Then delete the old one
	subprocess.call('rmdir /S /Q "{}"'.format(path), shell=True)

	# Create a junction back
	subprocess.call('mklink /J "{}" "{}"'.format(path, target_path), shell=True)



if __name__ == "__main__":
	path = WindowsPath(win32api.GetLongPathName(sys.argv[1]))
	move_and_link(path)
	print()
	print("DONE! No errors occurred.")
	print()
