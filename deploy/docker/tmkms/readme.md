
Build bridge from master with cache reset
```
docker-compose build --force-rm --no-cache
```
Run the bridge
```
docker-compose up --force-rm --no-cache 
```
Run test inside the bridge
```
docker-compose exec gravity /bin/sh test_gravity.sh
```
