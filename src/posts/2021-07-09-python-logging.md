---
image: /assets/images/base/python.svg
category: Python
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
