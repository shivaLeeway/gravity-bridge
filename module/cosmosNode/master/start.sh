GRAVITY_GENESIS_FILE="/root/.gravity/config/genesis.json"
GRAVITY_SEED_FILE="/root/seed"
BUCKET_MASTER_GENESIS_FILE="master/genesis.json"
BUCKET_MASTER_SEED="master/seed"

GIT_HUB_USER=$1
GIT_HUB_PASS=$2
GIT_HUB_EMAIL=$3
echo "Get pull updates"
git pull origin config

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
git config --global user.email $GIT_HUB_EMAIL
git config --global user.name $GIT_HUB_USER
git remote set-url origin https://$GIT_HUB_USER:$GIT_HUB_PASS@github.com/sunnyk56/gravity-bridge.git

echo "git commit command"
git commit -m "add genesis file"

echo "git fetch command"
git fetch
echo "git push command"
git push origin config