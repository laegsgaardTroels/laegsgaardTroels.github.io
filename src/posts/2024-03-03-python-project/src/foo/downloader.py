import logging

FILES = ['foo', 'bar']

logger = logging.getLogger(__name__)

  
def download_all():
    for filename in FILES:
        download_file(filename)


def download_file(filename):
    logger.info(f'Beginning download of {filename}')
