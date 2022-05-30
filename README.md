# private-poa-Blockchain :hammer:

Docker image for Ethereum testnet using proof-of-authority consensus protocol based on Geth's latest version. By default two accounts will be created, one serving as a signer and another one which holds all the coins on the testnet.

## Clone
Clone the repository

```console
git clone https://github.com/Ethereumx/private_poa_network.git && cd private_poa_network
```
## Building

```console
$ docker build -t poa/geth-poa:latest .
```



# test container alone
```console
$ docker run -p 8545:8545 -p 8456:8456 poa/geth-poa:latest
```
## Start peer
If test is ok you can start containers using

```console
$ docker-compose up -d
```
you can remove -d to get docker-comopse output

stop it using `docker-compose down`

## Bootstraping noodes

Add to static-nodes enodes strings separated by comma
````
enode://2f0802fddeeee8de3c20dbaff11f5cb8baf3abffe8a33a38f25767d2f727f7fb5fda8ac192b9823466c093dd84d78b6fd460c0add591518aaf772ba2b9f5b6a6@192.168.1.11:30301,enode://...
````

## Connect to peer Geth node
using the container_id connect to the running peer using
```console
docker exec -ti container_id bash
```
then run
```
geth attach http://localhost:8545
```
in the opened CLI run
```
> admin.nodeInfo.enode
```
The ouput will be like

```
enode://...@9[::]:30301
[::] will be parsed as localhost (127.0.0.1). If your nodes are on a local network check each individual host machine
```
# LOG
check container's log using :
`docker logs -f poadocker_geth_1`
# Upgrade

Blockscout doesn't support 1.10 (latest geth)
https://github.com/blockscout/blockscout/issues/4335

`--http.addr 0.0.0.0` and other http option, as described here https://hub.docker.com/r/ethereum/client-go/, are not suported by 1.9 but >=1.10

You'll need to use `--rpc.allow-unprotected-txs` to receive Nethereum transactions


## Tip:
Think of reseting Metamask account after each rebuild of the image
# Miscellaneous

when modify the config make sure you remove the docker volume and rebuild the container

you can use the option `--config <toml file>` instead putting the configuration options directly in geth command

to geenrate a toml file you can use :
` geth <with all needed options> dumpconfig > config.toml`

Remove all volumes and containers (Or just remove the volume and container created by the dockerfile)
- `docker rm $(docker ps -qa -f "status=exited")`
- `docker container prune`
- `docker volume rm $(docker volume ls -q)`

you can add the BootstrapNodes =["0x"....] to toml file
```console
BootstrapNodes = ["enode://d860a01f9722d78...051758@34.255.23.113:30303", "enode:"]
```

We set `clique.period` inside genesis.json file to zero, to ensure mining only when ever required with out empty block generation.

```console
clique": {
        "period": 0,
        "epoch": 30000
    },
```


You can override `genesis.json` by mounting your own at `/app`. Please bear in mind that `$ETH_ADDRESS` and `$ETH_BUFFER` strings will be replaced with the environment variables.

# Running a Bootnode
Generate a key and start the boot node on any random port
```
bootnode -genkey boot.key
bootnode -nodekey -addr :8009
```


## precompiled contract

geth attach http://localhost:8545
- check using inside peer
web3.eth.getCode("0x1000000000000000000000000000000000000920")
"0x"

# Info
note: ensure geth  "byzantiumBlock": 0 is set in the genesis.json file to enable status
