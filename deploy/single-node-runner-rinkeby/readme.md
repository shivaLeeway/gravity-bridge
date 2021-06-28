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

Address of the root validator (contract deployer)
```
name: test-chain-root
address: 0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0
private key: e0b21b1d80e53f38734a3ed395796956b50c637916ddbb6cedb096b848053d2d
```

```
name: test-chain-orchestrator-validator:  
address: 0x2d9480eBA3A001033a0B8c3Df26039FD3433D55d
private key: c40f62e75a11789dbaf6ba82233ce8a52c20efb434281ae6977bb0b3a69bf709
```