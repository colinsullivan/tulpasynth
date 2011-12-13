#!/usr/bin/env bash


echo "************************"
echo "*    Building boost    *"
echo "************************"

cd ./vendor/boost/
./bootstrap.sh --prefix=$(PWD)
./b2 install
cd ../../
ln -s ./vendor/boost/lib/libboost_system.dylib ./libboost_system.dylib
ln -s ./vendor/boost/lib/libboost_date_time.dylib ./libboost_date_time.dylib
ln -s ./vendor/boost/lib/libboost_regex.dylib ./libboost_regex.dylib
ln -s ./vendor/boost/lib/libboost_random.dylib ./libboost_random.dylib
ln -s ./vendor/boost/lib/libboost_program_options.dylib ./libboost_program_options.dylib

echo "************************"
echo "*      Boost done      *"
echo "************************"

echo "************************"
echo "* Building websocketpp *"
echo "************************"

cd ./vendor/zaphoyd-websocketpp-ec28725/
export CPLUS_INCLUDE_PATH=../boost/include:$CPLUS_INCLUDE_PATH
export DYLD_LIBRARY_PATH=../boost/lib:$DYLD_LIBRARY_PATH
make

echo "************************"
echo "*   websocketpp done   *"
echo "************************"

echo "**********************"
echo "*    Building STK    *"
echo "**********************"

# In the stk folder
cd ../stk-4.4.3/

# If a makefile already exists
if [ -e ./Makefile ]; then
    # If DLL doesn't exist
    if [ ! -e ./src/libstk.a ]; then
        make
    fi

# Makefile doesn't exist, assume DLL doesn't either.
else
    ./configure
    make
fi
cd ../../
echo "**********************"
echo "*      STK done      *"
echo "**********************"

echo "************************"
echo "*   Building jsoncpp   *"
echo "************************"

cd ./vendor/jsoncpp-src-0.6.0-rc2

python scons.py platform=linux-gcc

cd ../../

echo "************************"
echo "*     jsoncpp done     *"
echo "************************"

echo "************************"
echo "*    Building TCLAP    *"
echo "************************"

cd ./vendor/tclap-1.2.1/

if [ -e ./Makefile ]; then
    make
else
    ./configure
    make
fi  

echo "************************"
echo "*      TCLAP Done      *"
echo "************************"
