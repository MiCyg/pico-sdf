# Pico Small Framework
Raspberry pi pico framework for build, programming and monitor.

# Configure
Scripts should be in this same folder as pico-sdk, example tree:

	./
	├── pico-sdk/
	├── pico-examples/
	├── pico-extras/
	├── pico-playground/
	├── pico.sh
	└── pico_env.sh

You should edit .bashrc and optional .zshrc use commands:
```bash
echo "alias get_pico='. /path/to/pico_env.sh'" >> ~/.bashrc
echo "alias get_pico='. /path/to/pico_env.sh'" >> ~/.zshrc
source ~/.bashrc
```

Now, when you want to use pico framework use command below, next type `pico.sh help` for additional information about framework.

```bash
get_pico
```
