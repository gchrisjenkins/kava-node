#!/bin/bash

if [ ! -d "${HOME}/.kvd" ]
then

  rm -rf ~/.kvd ~/.kvcli

  kvd init kava-test --chain-id "Kava-Test-Chain"
  cp /kava/contrib/current/wip_genesis.json ~/.kvd/config/genesis.json

  echo "Add deputy key..."
  kvcli keys add deputy
  # enter a new password
  # kvcli will print the deputy's mnemonic phrase, we'll need this later

  echo "Add deputy genesis account..."
  kvd add-genesis-account $(kvcli keys show deputy -a) 1000000000000bnb

  echo "Add user key..."
  kvcli keys add user
  # enter a new password

  echo "Add user genesis account..."
  kvd add-genesis-account $(kvcli keys show user -a) 1000000000000bnb

  jq '.app_state.bep3.params.bnb_deputy_address="'$(kvcli keys show deputy -a)'"' ~/.kvd/config/genesis.json|sponge ~/.kvd/config/genesis.json

  echo "Add validator key..."
  kvcli keys add validator

  echo "Add validator genesis account..."
  kvd add-genesis-account $(kvcli keys show validator -a) 5000000000000ukava

  echo "genesis transaction for validator..."
  kvd gentx --name validator --amount 100000000ukava

  echo "collect genesis transactions..."
  kvd collect-gentxs
  kvcli config trust-node true

  kvcli config chain-id "Kava-Test-Chain"
  kvd validate-genesis

  sed 's/pruning = "syncable"/pruning = "nothing"/' ~/.kvd/config/app.toml | sponge ~/.kvd/config/app.toml

  kvd unsafe-reset-all
fi