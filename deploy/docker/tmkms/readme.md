Build bridge from master with cache reset

```
docker-compose build --force-rm --no-cache
```

Run the bridge

```
docker-compose up
```

Run dummy transfer (inside the chain) inside the gravity bridge

```
docker-compose exec gravity /bin/sh test_gravity.sh
```
