The instruction is tested on ubuntu 20.10

1. build gravity artifact/binary (we need it to generate genesis files for the containers in start-testnet.sh)
```
make -C module
```
check build result
```
gravity version
```

2. install utils (jp, sponge):
```
- sudo apt-get install jq
- sudo apt install moreutils
```

4. Run test net script
```
bash start-testnet.sh
```
3. Swagger http://localhost:1317/swagger/#/