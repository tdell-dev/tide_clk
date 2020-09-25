export TIDE_CLK_ROOT=.
export BOOST_ROOT= ${TIDE_CLK_ROOT}/lib/boost_1_66_0
export SRC_ROOT= ${TIDE_CLK_ROOT}/src
export BUILD_PROD_ROOT = ${TIDE_CLK_ROOT}/bin
export CC= g++

MKDIR_P = mkdir -p

all: install_cpprestsdk directories display clear boost_example

display: directories
	${CC} -I ${BOOST_ROOT} ${SRC_ROOT}/display.cpp -o ${BUILD_PROD_ROOT}/display

clear: directories
	g++ -I ${BOOST_ROOT} ${SRC_ROOT}/clear.cpp -o ${BUILD_PROD_ROOT}/clear

boost_example: directories
	g++ -I ${BOOST_ROOT} ${SRC_ROOT}/example.cpp -o ${BUILD_PROD_ROOT}/example

api_request_example:
	g++ -std=c++11 ${SRC_ROOT}/requester_example.cpp -o req_ex -lboost_system -lcrypto -lssl -lcpprest -lpthread

directories:
	${MKDIR_P} ${BUILD_PROD_ROOT}

install_cpprestsdk:
	sudo apt-get update && sudo apt-get upgrade
	sudo apt-get install g++ git libboost-atomic-dev libboost-thread-dev libboost-system-dev libboost-date-time-dev libboost-regex-dev libboost-filesystem-dev libboost-random-dev libboost-chrono-dev libboost-serialization-dev libwebsocketpp-dev openssl libssl-dev ninja-build libcpprest-dev git vim --fix-missing
