### Development Setup

```shell
# Frontend
export REACT_APP_API_URL=192.168.99.100
export REACT_APP_WEBSOCKET_SERVER=192.168.99.100

yarn && yarn run start

# Backend, add host entries, env vars don't work for kafka
192.168.99.100 kafka

# API
export MARKET_URL=192.168.99.100
export DB_HOST=192.168.99.100
export KAFKA_HOST=192.168.99.100

# Market consumer
export KAFKA_HOST=192.168.99.100
export MARKET_URL=192.168.99.100
```
