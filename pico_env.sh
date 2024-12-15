#!/bin/bash

pico_path=$HOME/rp/pico
pico_mdf_path=${pico_path}/pico-mdf

echo "Add PICO_SDK_PATH, PICO_EXAMPLES_PATH, PICO_EXTRAS_PATH, PICO_PLAYGROUND_PATH to env"
export PICO_SDK_PATH=${pico_path}/pico-sdk
export PICO_EXAMPLES_PATH=${pico_path}/pico-examples
export PICO_EXTRAS_PATH=${pico_path}/pico-extras
export PICO_PLAYGROUND_PATH=${pico_path}/pico-playground
export PICO_SDF_PATH=${pico_mdf_path}

echo "Add $pico_path to PATH"
export PATH="${pico_mdf_path}:$PATH"

echo -e "\033[0;35mEnvironment is ready. build your project using 'pico.py build'.\033[0m"

