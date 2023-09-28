FROM ubuntu:22.04
RUN apt update
RUN apt -y upgrade

RUN apt -y install sed wget unzip usbutils

# Install and setting Japanese font and locale
RUN apt -y install fonts-vlgothic locales
RUN sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen
RUN locale-gen
RUN update-locale LANG=ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

# Arduino IDE 2.x.x needs these packages
RUN apt -y install librust-gobject-sys-dev libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libgtk-3-0 libgbm1 libasound2 libsecret-1-0 python3-pip libx11-xcb1

# For using usb device
RUN apt -y --fix-missing install linux-tools-generic hwdata
RUN update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/*-generic/usbip 20


# For using serial port
RUN pip install pyserial

# Add group and user that execute Arduino IDE 2.x.x
ARG USERNAME=user
ARG GROUPNAME=user
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $GROUPNAME 
RUN useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

# Add write permission of serial port
RUN usermod -aG dialout $USERNAME

# Swith user to "user" that added.
USER $USERNAME
WORKDIR /home/$USERNAME/

# Download and unzip Arduino IDE 2.2.1
RUN wget https://downloads.arduino.cc/arduino-ide/arduino-ide_2.2.1_Linux_64bit.zip
RUN unzip arduino-ide_2.2.1_Linux_64bit.zip

# arduino-cli config start
ARG ARDUINOCLI=./arduino-ide_2.2.1_Linux_64bit/resources/app/lib/backend/resources/arduino-cli
RUN $ARDUINOCLI config init

# Add urls what you want to use
RUN $ARDUINOCLI config add board_manager.additional_urls https://dl.espressif.com/dl/package_esp32_index.json

# Update core(board) index
RUN $ARDUINOCLI core update-index
# Add core(board) what you want to user
RUN $ARDUINOCLI core install esp32:esp32

# Now, M5Stack and M5Atom library install make failure
# But, library install from .zip is successful
# I don't know why
#
# Set unsafe mode and install M5 libraries.
# After install, return safe mode.
RUN $ARDUINOCLI config set library.enable_unsafe_install true
RUN $ARDUINOCLI lib install --git-url https://github.com/m5stack/M5Stack.git https://github.com/m5stack/M5Atom.git
RUN $ARDUINOCLI config set library.enable_unsafe_install false

# Add libraries what you want to use
RUN $ARDUINOCLI lib install ESP32-Chimera-Core mcp_can
CMD ["./arduino-ide_2.2.1_Linux_64bit/arduino-ide"]
