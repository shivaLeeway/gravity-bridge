echo "Docker running"
docker run -d -p 26656:26656 -p 26657:26657 -p 1317:1317 -p 9090:9090 leeway321/cosmos-full-node /bin/sh -c "sleep infinite | gravity --home /root/.gravity/ --address tcp://0.0.0.0:26655 --rpc.laddr tcp://0.0.0.0:26657 --grpc.address 0.0.0.0:9090 --log_level error --p2p.laddr tcp://0.0.0.0:26656 --rpc.pprof_laddr 0.0.0.0:6060 start"

echo "waiting for container to start"
sleep 10

echo "get the container ID"
container=$(docker ps -q)

echo "get inside the container"
docker exec -t $container sh module/cosmosNode/fullNode/start.sh 2>&1 >/dev/null
