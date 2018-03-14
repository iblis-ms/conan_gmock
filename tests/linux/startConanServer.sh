#!/bin/bash

echo "------------------ start server conan ------------------"

callDir=`pwd`

conan remove -f GMock*

conan_server&
echo "Conan server 1st run: $?"
sleep 5
./stopConanServer.sh
echo "Conan server 1st run was stopped: $?"
sleep 5
cp ../server.conf $HOME/.conan_server/

conan_server&
echo "Conan server 2nd run: $?"

cd ../../

conan export . GMock/1.8.0@iblis_ms/stable

remote=`conan remote list | grep "http://localhost:9300"`
if [ -z "$remote" ]; then
  conan remote add local http://localhost:9300
fi

conan user -p demo -r local  demo

conan upload GMock/1.8.0@iblis_ms/stable --all -r=local --force

echo "GMock was uploaded: $?"

cd "$callDir"
