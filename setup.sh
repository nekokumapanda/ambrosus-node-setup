#!/bin/bash

yum update -y
yum install -y curl
yum install -y wget

# install node js
curl -sL https://rpm.nodesource.com/setup_10.x | bash -
yum groupinstall 'Development Tools'
yum install -y gcc-c++ make
yum install -y nodejs


# install docker
yum install -y git
yum remove -y docker docker-common docker-selinux docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-"$(uname -s)"-"$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# install jq
yum install -y epel-release
yum install -y jq

# install yarn
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
yum install -y yarn

# ambrosus-nop
git clone https://github.com/ambrosus/ambrosus-nop.git
wget https://nop.ambrosus.com/setup2.sh
chmod +x setup2.sh
cd ambrosus-nop || exit
yarn install
yarn build
yarn start

getvar() {
 jq -r ".$2" < "$1" | tr '[:upper:]' '[:lower:]'
}

email=$(getvar state.json email)
role=$(getvar state.json role)
address=$(getvar state.json address)
network=$(getvar state.json network.name)
TOS=$(tail -n 1 ./output/TOS.txt)
tosHash=$(getvar state.json termsOfServiceHash)
tosSignature=$(getvar state.json termsOfServiceSignature)

if [ "$email" == "" ] || [ "$role" == "" ] || [ "$address" == "" ] || [ "$network" == "" ] || [ "$TOS" == "" ] || [ "$tosH
ash" == "" ] || [ "$tosSignature" == "" ]; then
cd ..
echo "One or more mandatory parameters has not been set."
echo "Please restart process and fill all required information."
exit
fi

if [ "$email" == "null" ] || [ "$role" == "null" ] || [ "$address" == "null" ] || [ "$network" == "null" ] || [ "$TOS" == 
"null" ] || [ "$tosHash" == "null" ] || [ "$tosSignature" == "null" ]; then
cd ..
echo "One or more mandatory parameters has not been set."
echo "Please restart process and fill all required information."
exit
fi

{
 echo Address: "$address"
 echo Network: "$network"
 echo Role: "$role"
 echo Email: "$email"
 echo TOS: "$TOS"
 echo tosHash: "$tosHash"
 echo tosSignature: "$tosSignature"
} >> info.txt

role=$(echo "$role" | awk -F " " '{ print $1 }')

if [ "$role" == "apollo" ]; then
 {
  echo IP: "$(getvar state.json ip)"
  echo Stake: "$(getvar state.json apolloMinimalDeposit)"
 } >> info.txt;
fi

if [ "$role" == "atlas" ] || [ "$role" == "hermes" ]; then
 {
  echo URL: "$(getvar state.json url)"
 } >> info.txt;
fi

curl -X POST --data-urlencode "payload={\"attachments\": [{\"title\":\"$email-request\",\"text\":\"$(cat info.txt)\"},]}" https://hooks.slack.com/services/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
