#!/usr/bin/env bash


echo "************************"
echo "*    Building boost    *"
echo "************************"

cd ./vendor/boost_1_47_0/
# ./bootstrap.sh --prefix=$(PWD)
# ./b2 install

echo "************************"
echo "*      Boost done      *"
echo "************************"

echo "************************"
echo "* Building websocketpp *"
echo "************************"

cd ../zaphoyd-websocketpp-ec28725/
export CPLUS_INCLUDE_PATH=../boost_1_47_0/include:$CPLUS_INCLUDE_PATH
export DYLD_LIBRARY_PATH=../boost_1_47_0/lib:$DYLD_LIBRARY_PATH
make


echo "************************"
echo "*   websocketpp done   *"
echo "************************"
