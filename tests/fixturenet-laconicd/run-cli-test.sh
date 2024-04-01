#!/usr/bin/env bash

set -e
if [ -n "$CERC_SCRIPT_DEBUG" ]; then
  set -x
fi

echo "$(date +"%Y-%m-%d %T"): Running stack-orchestrator Laconicd fixturenet test"
env
cat /etc/hosts
# Bit of a hack, test the most recent package
TEST_TARGET_SO=$( ls -t1 ./package/laconic-so* | head -1 )

echo "$(date +"%Y-%m-%d %T"): Starting stack"
TEST_AUCTION_ENABLED=true $TEST_TARGET_SO --stack fixturenet-laconicd deploy --cluster laconicd up
echo "$(date +"%Y-%m-%d %T"): Stack started"

# Verify that the fixturenet is up and running
$TEST_TARGET_SO --stack fixturenet-laconicd deploy --cluster laconicd ps

# Get the key from laconicd
laconicd_key=$(docker exec laconicd-laconicd-1 sh -c 'yes | laconicd keys export mykey --unarmored-hex --unsafe')

# Get the fixturenet account address
laconicd_account_address=$(docker exec laconicd-laconicd-1 laconicd keys list | awk '/- address:/ {print $3}')

# Set parameters for the test suite
cosmos_chain_id=laconic_9000-1
laconicd_rest_endpoint=http://laconicd:1317
laconicd_gql_endpoint=http://laconicd:9473/api

# Create the required config and copy it over inside the container
config_file="config.yml"
config=$(cat <<EOL
services:
  cns:
    restEndpoint: $laconicd_rest_endpoint
    gqlEndpoint: $laconicd_gql_endpoint
    userKey: $laconicd_key
    bondId:
    chainId: $cosmos_chain_id
    gas: 200000
    fees: 200000aphoton
EOL
)
echo "$config" > "$config_file"

docker cp $config_file laconicd-cli-1:laconic-registry-cli/config.yml

# Run the tests
docker exec -it -e TEST_ACCOUNT=$laconicd_account_address laconicd-cli-1 sh -c 'cd laconic-registry-cli && yarn test'

# Clean up
$TEST_TARGET_SO --stack fixturenet-laconicd deploy --cluster laconicd down --delete-volumes
echo "$(date +"%Y-%m-%d %T"): Test finished"
