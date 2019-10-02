# ambrosus-node-setup

### [Note] The unofficial script for Onboarding An Ambrosus Atlas Masternodex.
### [Note] Please take responsibility for your actions.

### Aim of this repogitory
Onboarding An Ambrosus Atlas Masternodex, CentOS cannot be used officially.
(see https://medium.com/@delumigreen/the-nontechnical-guide-to-onboarding-an-ambrosus-masternode-a83d98493d3c)
So, I try to creating a script for CentOS 7 as a hobby.
The author does not guarantee the behavior of the script.

### How to use

Instead of procedure
```
wget https://nop.ambrosus.com/setup.sh
chmod +x setup.sh
```
, execute the follows.
```
yum install -y git
git clone https://github.com/nekokumapanda/ambrosus-node-setup.git
mv ambrosus-node-setup/setup.sh ./
chmod +x setup.sh
```
