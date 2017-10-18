#!/bin/sh

# Bash colors 
red=`tput setaf 1`
blue=`tput setaf 4`
green=`tput setaf 2`
reset=`tput sgr0`

NODE_DIND_VERSION=test
EXPECTED_NODE_VERSION=v8.5.0
EXPECTED_DOCKER_VERSION=17.10.0-ce-rc2
EXPECTED_DOCKER_COMPOSE_VERSION=1.16.1
CONTAINER=$(docker run --privileged -d redpandaci/node-dind:$NODE_DIND_VERSION sleep 300)

echo "\n --${blue}TEST node-dind:$NODE_DIND_VERSION${reset}-- \n"

# Test node version
echo "## Node version ##"

NODE_VERSION=$(docker exec $CONTAINER node --version)
if [ $NODE_VERSION = $EXPECTED_NODE_VERSION ]; then
  echo "${green}SUCCES node version: $NODE_VERSION${reset}"
else
  echo "${red}ERROR:  expected version $EXPECTED_NODE_VERSION is different to $NODE_VERSION${reset}"
  docker kill $CONTAINER
  exit 1
fi

# Test Docker wrap
echo "## Docker dind version ##"

DOCKER_VERSION=$(docker exec $CONTAINER docker --version | cut -d "," -f 1 | cut -d " " -f 3)
if [ $EXPECTED_DOCKER_VERSION = $DOCKER_VERSION ]; then
  echo "${green}SUCCES wrapdocker available for docker version: $DOCKER_VERSION${reset}"
else
  echo "${red}ERROR: expected version $EXPECTED_DOCKER_VERSION is different to $DOCKER_VERSION${reset}"
  docker kill $CONTAINER
  exit 1
fi

# Test Docker compose
echo "## docker-compose version ##"
DOCKER_COMPOSE_VERSION=$(docker exec $CONTAINER docker-compose --version | cut -d "," -f 1 | cut -d " " -f 3)
if [ $EXPECTED_DOCKER_COMPOSE_VERSION = $DOCKER_COMPOSE_VERSION ]; then
  echo "${green}SUCCES docker-compose available version: $DOCKER_COMPOSE_VERSION${reset}"
else
  echo "${red}ERROR: expected version $EXPECTED_DOCKER_COMPOSE_VERSION is different to $DOCKER_COMPOSE_VERSION${reset}"
  docker kill $CONTAINER
  exit 1
fi

DESTROY=$(docker rm -f $CONTAINER)
echo "Destroy container $DESTROY"
exit 0