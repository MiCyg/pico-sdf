#!/bin/bash

pico_path=$(realpath "$0")
echo "Add PICO_SDK_PATH, PICO_EXAMPLES_PATH, PICO_EXTRAS_PATH, PICO_PLAYGROUND_PATH to env"
export PICO_SDK_PATH=${pico_path}/pico-sdk
export PICO_EXAMPLES_PATH=${pico_path}/pico-examples
export PICO_EXTRAS_PATH=${pico_path}/pico-extras
export PICO_PLAYGROUND_PATH=${pico_path}/pico-playground

echo "Add /home/mi/rp/pico to PATH"
export PATH="${pico_path}:$PATH"

echo -e "\033[0;35mEnvironment is ready. build your project using 'pico.sh build'.\033[0m"

