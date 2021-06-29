GRAVITY_GENESIS_FILE="/root/.gravity/config/genesis.json"
GRAVITY_SEED_FILE="/root/seed"
BUCKET_MASTER_GENESIS_FILE="master/genesis.json"
BUCKET_MASTER_SEED="master/seed"

echo "Get pull updates"
RUN git pull origin config

echo "add master genesis,json file"
rm -r master
mkdir master
touch $BUCKET_MASTER_GENESIS_FILE
touch $BUCKET_MASTER_SEED
echo "Copying genesis file"
cp $GRAVITY_GENESIS_FILE $BUCKET_MASTER_GENESIS_FILE
cp $GRAVITY_SEED_FILE $BUCKET_MASTER_SEED
echo "git add command"
git add .
echo "git add git config command"
git config --global user.email "sunnyk@leewayhertz.com"
git config --global user.name "sunnyk56"
git remote set-url origin https://sunnyk56:Leeway321@github.com/sunnyk56/gravity-bridge-1.git

echo "git commit command"
git commit -m "add genesis file"

echo "git fetch command"
git fetch
echo "git push command"
git push origin config
