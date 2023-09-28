# Dockerized Arduino IDE 2.2.1
Arduino IDE 2.2.1 in docker container.
 
Arduino IDE 2.2.1 from:

https://downloads.arduino.cc/arduino-ide/arduino-ide_2.2.1_Linux_64bit.zip

# Build docker image
Download Dockerfile:
```
$ git clone https://github.com/kz1000a1/DockerizedArduinoIDE2.2.1.git
or download .zip and unzip
```
On windows terminal or WSL(Ubuntu-22.04):
```
cd DockerizedArduinoIDE2.2.1
docker build -t arduino-ide .
```
# Before using
Read this tutorial and attach USB device:

https://learn.microsoft.com/windows/wsl/connect-usb

Modify .env and compose.yml file:

${SKETCH_PATH} is where you want to save Arduino IDE sketch file.

${SKETCH_PATH} must be out of docker container.

# Execute Arduino-ide
Windows:
```
> docker compose run arduino-ide
```
WSL(Ubuntu-22.04):
```
$ ls /dev/ttyACM0
$ docker compose run arduino-ide
```
If /dev/ttyACM0 is not exist.Read this tutrial again.

https://learn.microsoft.com/windows/wsl/connect-usb
