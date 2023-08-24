# Lotus Fixturenet Test

Instructions for running tests on a local and mainnet Lotus (Filecoin) chain

## 1. Clone required repositories
```bash
$ laconic-so --stack fixturenet-lotus-test setup-repositories
```
## 2. Build the stack's packages and containers
```bash
$ laconic-so --stack fixturenet-lotus-test build-containers
```
## 3. Deploy the stack
```bash
$ laconic-so --stack fixturenet-lotus-test deploy --cluster lotus up
```

Note: When running for the first time (or after clean up), the services will take some time to start properly as the Lotus nodes download the proof params (which are persisted to volumes)

## 4. Clean up

Stop all the services running in background:
```bash
$ laconic-so --stack fixturenet-lotus-test deploy --cluster lotus down
```

Clear volumes created by this stack:
```bash
# List all relevant volumes
$ docker volume ls -q --filter "name=lotus"

# Remove all the listed volumes
docker volume rm $(docker volume ls -q --filter "name=lotus")

# WARNING: After removing volumes with Lotus params
# They will be downloaded again on restart

# To remove volumes that do not contain Lotus params
docker volume rm $(docker volume ls -q --filter "name=lotus" | grep -v "params$")
```
