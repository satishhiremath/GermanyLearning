import os
import shutil
import re
import datetime
import errno
import sys
from subprocess import call
import yaml
import subprocess
import getpass

if(len(sys.argv) != 2 or sys.argv[1].startswith("-h") or sys.argv[1].startswith("--h")):
    print("Usage: export_datacollection_binaries.py /PATH/FOR/EXPORT")
    quit()

#creating debian package
os.chdir("/home/satish/Desktop/try/")
call("mkdir -p Debian/sampleDebian-1.0.0", shell=True)
call("sudo chmod +x -R Debian", shell=True)
call("cd Debian/sampleDebian-1.0.0/", shell=True)
os.chdir("/home/satish/Desktop/try"+"/Debian/sampleDebian-1.0.0")
call("sudo apt-get install build-essential dh-make --assume-yes", shell=True)
call("dh_make --native --single --packagename sampleDebian-1.0.0 --yes", shell=True)
call("dpkg-buildpackage -S -uc -d -nc", shell=True)
call("mkdir -p files/usr/bin", shell=True)
call("chmod +x -R files/usr/bin/", shell=True)

#copy out export folderrfakeroot
try:
    call("sudo chmod -R  777 " + sys.argv[1], shell=True)
    call("cp -rf "+"/home/satish/Desktop/try"+"/output_release-20180802-1638/ " + "files/usr/bin", shell=True)
except:
    print("Failed to move:")
    print("mv "+"/home/qxv7210/Desktop/try"+"/release-20180802-1638 " + sys.argv[1])
    print()

call("cp -rf output_release-20180802-1638/ files/usr/bin/output", shell=True)


# Create a new link "latest" which points to latest release folder (release-yyyymmdd-hhmm)
try:
    if os.path.exists("files/usr/bin/latest"):
        call("sudo rm -r latest", shell=True)

    os.symlink(os.path.join("/home/tager_user/releases", "output"), "files/usr/bin/latest")
except OSError, e:
    if e.errno == errno.EEXIST:
        os.remove("files/usr/bin/latest")
        os.symlink(os.path.join("/home/tager_user/releases", "output"), "files/usr/bin/latest")
    else:
        print("Failed to create a sym.link \"latest\" to folder " + os.path.join("/home/tager_user/releases", "output"))
        print()

call('touch debian/install ', shell=True)
call('echo "files/usr/bin/* /home/tager_user/releases" > debian/install', shell=True)
call("chmod -x -R files/usr/bin/", shell=True)
call("sudo dpkg-buildpackage -uc -us", shell=True)
call("chmod +x -R files/usr/bin/", shell=True)

copy_deb_path_command = "sudo cp -rf ../sampleDebian-1.0.0_1.0.0_amd64.deb " + sys.argv[1]
