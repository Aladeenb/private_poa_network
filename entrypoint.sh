#!/bin/sh
set -e

export ETH_VERBOSITY=6
export ETH_CHAIN_ID=1578
export ETH_ADDRESS="0x9855CC753029eF19071f2ceBC7Fdb6F99F986474"


# replace_env() {
#   for key in $(env | sed 's;=.*;;' | grep ETH_); do
#     val=$(eval echo \$$key)  # sh doesn't support indirect substitution
#     sed -i "s|\$$key|$val|g" $1
#   done
# }

# replace $ETH_... strings with env variable values without overwriting genesis.json
cp genesis.json .genesis.json
cp config.toml .config.toml
cp boot.key .boot.key
cp static-nodes.json .static-nodes.json
export BOOTNODE=`cat static-nodes.json`
# replace_env .genesis.json
# replace_env .config.toml
echo "----------------POA Node Configuration---------------------"
echo cmrAccount@724* > /tmp/eth_pass
echo a85c9e1ce557f963d221ae895ddfa3e3e7490f83d61ed3d56e2060a1d34cf61e > /tmp/eth_private_key
geth account new --datadir data --password /tmp/eth_pass
echo "----------------Init Genesis---------------------"
ls
geth --datadir /data init genesis.json
echo "----------------Import Accounts---------------------"

geth --datadir /data account import --password /tmp/eth_pass /tmp/eth_private_key || true
cp ./.boot.key /data/nodekey

# $# => contains the number of parameters for this shell is started
if [[ $# -eq 0 ]] ; then
  # exec geth --config .config.toml --nousb --verbosity $ETH_VERBOSITY --gcmode=archive --mine --miner.threads 1 --unlock $ETH_ADDRESS --password /tmp/eth_pass --miner.gasprice 0
exec geth --datadir /data --config config.toml --bootnodes="$BOOTNODE" --networkid $ETH_CHAIN_ID  --rpcvhosts=*   --allow-insecure-unlock --nousb --verbosity 3 --gcmode=archive --mine --miner.threads 1 --unlock $ETH_ADDRESS --password /tmp/eth_pass --miner.gasprice 0
else
  exec "$@"
fi

