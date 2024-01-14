---
author: "Troels L\xE6gsgaard"
category: Python
code: https://github.com/laegsgaardTroels/autoreload
content: ''
date: '2021-05-23'
day: '23'
excerpt: When making stuff in a Jupyter Notebook I often find it usefull to refactor
  stuff I use across notebooks into a Python module. To do this smoothly I install
  the module in editable mode and use the awesome Jupyter autoreload magic. [...]
image: /assets/images/base/python.svg
month: '05'
title: Autoreload
url: /posts/2021-05-23-autoreload.html
year: '2021'
---

When making stuff in a Jupyter Notebook I often find it usefull to refactor stuff I use across notebooks into a Python module. To do this smoothly I install the module in editable mode and use the awesome Jupyter autoreload magic. <!--more-->

A minimal example is a project:

```
.
├── foo
│   └── __init__.py
├── notebooks
│   └── example.ipynb
├── README.md
└── setup.py
```

Now we create a virtual environment:

```bash
~$ virtualenv .venv
~$ source .venv/bin/activate
~$ pip install jupyterlab
~$ pip install -e .
```

The `-e` flag installs the module in editable mode, meaning that you can modify your source code in `foo/` and have the changes take effect without you having to rebuild and reinstall, see [3].

```bash
~$ pip install -h
-e, --editable <path/url>   Install a project in editable mode (i.e. setuptools "develop mode") from a local project path or a VCS url.
```

## Jupyter magic

`autoreload` is an IPython extension to reload modules before executing user code.

`autoreload` reloads modules automatically before entering the execution of code typed at the IPython prompt.

This makes for example the following workflow possible:

```python
%load_ext autoreload
%autoreload 2
from foo import some_function
some_function()
# 42
```

Open `foo/__init__.py` in an editor and change `some_function` to return 43.

```python
some_function()
# 43
```
The module was reloaded without reloading it explicitly, and the object imported with `from foo import some_function` was also updated.

# References

[1] https://pip.pypa.io/en/latest/cli/pip_install/#editable-installs

[2] https://ipython.org/ipython-doc/3/config/extensions/autoreload.html

[3] https://setuptools.readthedocs.io/en/latest/userguide/quickstart.html#development-mode
