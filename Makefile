export TIDE_CLK_ROOT=.
export BOOST_ROOT= ${TIDE_CLK_ROOT}/lib/boost_1_66_0
export SRC_ROOT= ${TIDE_CLK_ROOT}/src
export BUILD_PROD_ROOT = ${TIDE_CLK_ROOT}/bin
export CC= g++

MKDIR_P = mkdir -p

all: directories display clear boost_example

display: directories
	${CC} -I ${BOOST_ROOT} ${SRC_ROOT}/display.cpp -o ${BUILD_PROD_ROOT}/display

clear: directories
	g++ -I ${BOOST_ROOT} ${SRC_ROOT}/clear.cpp -o ${BUILD_PROD_ROOT}/clear

boost_example: directories
	g++ -I ${BOOST_ROOT} ${SRC_ROOT}/example.cpp -o ${BUILD_PROD_ROOT}/example

directories:
	${MKDIR_P} ${BUILD_PROD_ROOT}
