#!/bin/bash

# Load environment variables from .env file
source .env

# Set variables
RPC_URL=$POLYGON_AMOY_RPC_URL
VERIFIER_URL="https://www.oklink.com/api/explorer/v1/matic"
CONTRACT_FILE="src/WalletRegistry.sol"
CONTRACT_NAME="WalletRegistry"
OKLINK_API_KEY=$OKLINK_API_KEY

# Function to deploy the contract using forge script
deploy_script() {
  echo "Deploying contract using forge script..."
  echo "RPC URL: $RPC_URL"
  echo "Contract File: $CONTRACT_FILE"
  echo "Contract Name: $CONTRACT_NAME"
  echo "Verifier URL: $VERIFIER_URL"

  forge script script/WalletRegistry.s.sol:DeployWalletRegistry \
    --rpc-url $RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --gas-price 50000000000 \


  if [ $? -ne 0 ]; then
    echo "Error: Contract deployment using forge script failed."
    exit 1
  fi
}

# Function to verify the contract using forge verify-contract
verify_contract() {
  CONTRACT_ADDRESS=$(jq -r '.transactions[0].contractAddress' /Users/liam/dev/GateSync/foundry/broadcast/WalletRegistry.s.sol/80002/run-latest.json)
  
  if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "Error: Failed to retrieve contract address from deployment."
    exit 1
  fi

  echo "Verifying contract at address $CONTRACT_ADDRESS..."
  echo "RPC URL: $RPC_URL"
  echo "Contract File: $CONTRACT_FILE"
  echo "Contract Name: $CONTRACT_NAME"
  echo "Verifier URL: $VERIFIER_URL"

  forge verify-contract \
    --rpc-url $RPC_URL \
    $CONTRACT_ADDRESS \
    $CONTRACT_FILE:$CONTRACT_NAME \
    --verifier oklink \
    --verifier-url $VERIFIER_URL \
    --verifier-api-key $OKLINK_API_KEY \
    -vvv

  if [ $? -ne 0 ]; then
    echo "Error: Contract verification failed."
    exit 1
  fi
}

# Deploy the contract using forge script
deploy_script

# Verify the contract using forge verify-contract
# verify_contract

echo "Deployment and verification completed successfully."