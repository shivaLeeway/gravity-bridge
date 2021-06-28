# Single node runner rinkeby
**Build**
```
docker build -t onomy/gravity-bridge-single-node-runner-rinkeby:local  -f Dockerfile ../../
```

**Run**
```
docker-compose down && docker-compose up
```

**Ethereum**

Address of the root validator (contract deployer)  / Initial ETH amount - 18.75 ETH
```
name: test-chain-root
address: 0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0
private key: e0b21b1d80e53f38734a3ed395796956b50c637916ddbb6cedb096b848053d2d
```

Address of the orchestrator/validator
```
name: test-chain-orchestrator-validator:  
address: 0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d
private key: c40f62e75a11789dbaf6ba82233ce8a52c20efb434281ae6977bb0b3a69bf709
```

**Steps to rebuild from scratch**

***Prepare gravity (generate genesys and etc.)***
  
Run init-gravity.sh and copy $GRAVITY_HOME folder. This home contains teset chain settings and genesys file of the chain.

***Deploy Ethereum contact***

* edit contract-deployer.ts (add gasPrice and gasLimit)
```
// sets the gas price for all contract deployments
  const overrides = {
    gasPrice: 100000000000,
    gasLimit: 9000000
  }

  const gravity = (await factory.deploy(
    // todo generate this randomly at deployment time that way we can avoid
    // anything but intentional conflicts
    gravityId,
    vote_power,
    eth_addresses,
    powers,
    overrides
  )) as Gravity;
```
* run deploy-contract.sh to deploy contract to the ethereum, save contract address for the further usage

*** or deploy manually 

```
cd /go/src/github.com/onomyprotocol/gravity-bridge/solidity

npx ts-node \
contract-deployer.ts \
--cosmos-node="http://0.0.0.0:26657" \
--eth-node="http://0.0.0.0:8545" \
--eth-privkey="e0b21b1d80e53f38734a3ed395796956b50c637916ddbb6cedb096b848053d2d" \
--contract=artifacts/contracts/Gravity.sol/Gravity.json \
--test-mode=false
```

Example of already deployer contract.
```
Gravity deployed at Address -  0x18619DE15bDd14b0360e82e2746aAf77B17b3925
```

**Geth tools**

Connect to the container
```
docker exec -it gravity-bridge-single-node-runner-rinkeby bash
```
Attach console:
```
geth --rinkeby attach ipc:/root/.ethereum/rinkeby/geth.ipc console
```
Get current status os sync
```
eth.syncing
```
Get num of peers
```
net.peerCount
```
Show accounts
```
eth.accounts
```
Get balance (test root account)
```
web3.eth.getBalance('0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0')
```