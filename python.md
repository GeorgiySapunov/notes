### Update all packages using pip
```zsh
pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
```

### Show outdated packages
```zsh
pip list -o
```

### Package upgrade
```zsh
pip install -U package_name
```

### Make a requirements.txt
```zsh
pip freeze > requirements.txt
```

### Install from requirements.txt
```zsh
pip install -r requirements.txt
```

### Make virtual environment
```zsh
python -m venv env
```

### Activate an environment
```zsh
source env\bin\activate
```

### Deactivate an environment
```zsh
deactivate
```

### Make a virtual environment with system packages
```zsh
python -m venv env --system-site-packages
```
