#!/usr/bin/env bash


echo "************************"
echo "*    Building boost    *"
echo "************************"

cd ./vendor/boost_1_47_0/
./bootstrap.sh --prefix=$(PWD)
./b2 install
cd ../../
ln -s ./vendor/boost_1_47_0/lib/libboost_system.dylib ./libboost_system.dylib
ln -s ./vendor/boost_1_47_0/lib/libboost_date_time.dylib ./libboost_date_time.dylib
ln -s ./vendor/boost_1_47_0/lib/libboost_regex.dylib ./libboost_regex.dylib
ln -s ./vendor/boost_1_47_0/lib/libboost_random.dylib ./libboost_random.dylib
ln -s ./vendor/boost_1_47_0/lib/libboost_program_options.dylib ./libboost_program_options.dylib

echo "************************"
echo "*      Boost done      *"
echo "************************"

echo "************************"
echo "* Building websocketpp *"
echo "************************"

cd ./vendor/zaphoyd-websocketpp-ec28725/
export CPLUS_INCLUDE_PATH=../boost_1_47_0/include:$CPLUS_INCLUDE_PATH
export DYLD_LIBRARY_PATH=../boost_1_47_0/lib:$DYLD_LIBRARY_PATH
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
