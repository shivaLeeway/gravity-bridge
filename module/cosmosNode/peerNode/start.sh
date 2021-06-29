GENTEX_FILE="/root/.gravity/config/gentx/."
VALIDATOR_FILE="/root/validator2.json"
BUCKET_MASTER_GENTEX_FILE="peerInfo/gentx"
BUCKET_MASTER_VALIDATOR_FILE="peerInfo"

echo "Gentx file moving"
rm -r master
mkdir peerInfo
mkdir peerInfo/gentx

echo "Copying validator file"
cp $VALIDATOR_FILE $BUCKET_MASTER_VALIDATOR_FILE

echo "Copying gentx file"
cp -R $GENTEX_FILE $BUCKET_MASTER_GENTEX_FILE

echo "git add command"
git add .

echo "git add git config command"
git config --global user.email "shiva@leewayhertz.com"
git config --global user.name "shivaLeeway"

echo "git commit command"
git commit -m "Gentx moved"

echo "git push command"
git push https://shivaLeeway:leeway%40123@github.com/shivaLeeway/gravity-bridge.git