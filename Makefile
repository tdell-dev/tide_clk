export TIDE_CLK_ROOT=.
export BOOST_ROOT= ${TIDE_CLK_ROOT}/lib/boost_1_66_0
export SRC_ROOT= ${TIDE_CLK_ROOT}/src

#Generated Directories
export BUILD_PROD_ROOT = ${TIDE_CLK_ROOT}/bin
export HIDDEN_DELME_ROOT = ${TIDE_CLK_ROOT}/.hidden_delme_tideclk
export CC= g++

MKDIR_P = mkdir -p

all: install_cpprestsdk directories display clear boost_example api_request_example test

display: directories
	${CC} -I ${BOOST_ROOT} ${SRC_ROOT}/display.cpp -o ${BUILD_PROD_ROOT}/display

clear: directories
	g++ -I ${BOOST_ROOT} ${SRC_ROOT}/clear.cpp -o ${BUILD_PROD_ROOT}/clear

boost_example: directories
	g++ -I ${BOOST_ROOT} ${SRC_ROOT}/example.cpp -o ${BUILD_PROD_ROOT}/example

api_request_example:
	g++ -std=c++11 ${SRC_ROOT}/requester_example.cpp -o ${BUILD_PROD_ROOT}/req_ex -lboost_system -lcrypto -lssl -lcpprest -lpthread

test: directories
	g++ -std=c++11 ${SRC_ROOT}/requester.cpp -o ${BUILD_PROD_ROOT}/req -lboost_system -lcrypto -lssl -lcpprest -lpthread

directories:
	${MKDIR_P} ${BUILD_PROD_ROOT}
	${MKDIR_P} ${HIDDEN_DELME_ROOT}

install_cpprestsdk:
	sudo apt-get install g++ git libboost-atomic-dev libboost-thread-dev libboost-system-dev libboost-date-time-dev libboost-regex-dev libboost-filesystem-dev libboost-random-dev libboost-chrono-dev libboost-serialization-dev libwebsocketpp-dev openssl libssl-dev ninja-build libcpprest-dev git vim --fix-missing

install_spi_disp: clean directories
	cd ${HIDDEN_DELME_ROOT} && git clone https://github.com/goodtft/LCD-show.git
	echo "Moving the overlay into /boot/overlays/tft35a.dtbo"
	sudo cp ${HIDDEN_DELME_ROOT}/LCD-show/usr/tft35a-overlay.dtb /boot/overlays/tft35a.dtbo
	echo "Please ensure that SPI, I2C, and Serial are enabled in raspi-config"
	echo "Enabling new overlay in /boot/config.txt"
	sudo cp /boot/config.txt /boot/config.txt.orig
	sudo echo "dtoverlay=tft35a:rotate=270" >> /boot/config.txt
	sudo echo "Setting new overlay settings in /boot/cmdline.txt"
	sudo cp /boot/cmdline.txt /boot/cmdline.txt.orig
	sudo echo "fbcon=map:10 fbcon=font:ProFont6x11" >> /boot/cmdline.txt
	echo "New display should be ready. Please reboot"

clean:
	rm -rf ${BUILD_PROD_ROOT} ${HIDDEN_DELME_ROOT}
