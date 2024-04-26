# Pico Small Framework
Raspberry pi pico framework for build, programming and monitor.

# Configure
Project should be in this same folder as pico-sdk, example tree:
```
./
├── pico-sdk/
├── pico-examples/
├── pico-extras/
├── pico-playground/
└── pico-mdf/
```

First thing you must do is set path in `pico_env.sh` script. Next, you should edit `.bashrc` and optional `.zshrc` use commands:
```bash
echo "alias get_pico='. /path/to/pico_env.sh'" >> ~/.bashrc
echo "alias get_pico='. /path/to/pico_env.sh'" >> ~/.zshrc
source ~/.bashrc
```

Now, when you want to use pico framework use command `get_pico`. Next, type `pico.py -h` for additional information about framework options and usage.
