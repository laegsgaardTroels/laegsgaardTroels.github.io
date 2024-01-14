---
author: "Troels L\xE6gsgaard"
category: Python
code: ''
content: ''
date: '2021-07-09'
day: 09
excerpt: Logging is a nice debugging tool in Python. [...]
image: /assets/images/base/python.svg
month: '07'
title: Python Logging
url: /posts/2021-07-09-python-logging.html
year: '2021'
---

Logging is a nice debugging tool in Python. <!--more--> A mimimal example would be:

```python
import logging

logger = logging.getLogger(__name__)


def download(filename):
  logger.info(f'Beginning download of {filename}')
  

if __name__ == '__main__':
    logging.basicConfig(
        format='%(asctime)s - %(message)s',
        filename='download.log',
        level=logging.INFO,
        datefmt='%d-%b-%y %H:%M:%S',
    )
    for filename in ['foo', 'bar']:
        download(filename)
```

The loggers are instantiated using `logging.getLogger(__name__)` in each script. You can then configure the log in a main script using `logging.basicConfig(...)`.
