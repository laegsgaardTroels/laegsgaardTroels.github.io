import argparse
import sys
import pathlib
import json
import re

TITLE_PATTERN = re.compile(r'-?(\D+)$')
DATE_PATTERN = re.compile(r'^\d{4}-\d{2}-\d{2}')

def parse_stem(stem):
    try:
        title = None
        year = None
        month = None
        day = None
        title_match = TITLE_PATTERN.search(stem)
        date_match = DATE_PATTERN.match(stem)
        if title_match is None:
            raise ValueError(f"Missing Title in {stem}")
        else:
            title = ' '.join(title_match.group(1).split('-')).title()
        if date_match is None:
            pass
        else:
            year, month, day = date_match.group(0).split('-')
        return title, year, month, day
    except Exception as exception:
        raise ValueError(f"Cannot parse {stem}") from exception


def post_conf(path):
    try:
        title, year, month, day = parse_stem(path.stem)
        _, header, content = path.read_text().split('---\n')
        header = dict(map(lambda x: x.split(': '), header.splitlines()))
        kwargs = {
            'title': title,
            'date': f'{year}-{month}-{day}',
            'year': year,
            'month': month,
            'day': day,
            'content': '',
            'excerpt': content.split('<!--more-->')[0].strip() + ' [...]',
            'url': '/posts/' + path.stem + '.html',
            'image': header['image'],
            'category': header.get('category', 'Uncategorized'),
            'code': header.get('code', ''),
            'author': header.get('author', 'Troels Lægsgaard')
        }
        return kwargs
    except Exception as exception:
        raise ValueError(f"Cannot make a post from {path}") from exception


def index(args):
    try:
        conf = {'post': []}
        for path in sorted(list(args.inputs), reverse=True):
            conf['post'].append(post_conf(path))
        with open(args.output, 'w') as f:
            json.dump(conf, f, indent=4)
    except Exception as exception:
        raise ValueError(f"Cannot parse {args}") from exception


def post(args):
    try:
        with open(args.output[0], 'w') as f:
            json.dump(post_conf(args.inputs[0]), f, indent=4)
    except Exception as exception:
        raise ValueError(f"Cannot parse {args}") from exception


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Builds metadata.')
    subparsers = parser.add_subparsers(help='sub-command help')

    post_parser = subparsers.add_parser(
        'post', help='Build a configuration file for a post.'
    )
    post_parser.add_argument(
        '-i', '--inputs', metavar='inputs', type=pathlib.Path, nargs=1,
        help='The post one wants to create a config for.'
    )
    post_parser.add_argument(
        '-o', '--output', metavar='output', type=pathlib.Path, nargs=1, default='index.json',
        help='The output destination of the json config.'
    )
    post_parser.set_defaults(func=post)

    index_parser = subparsers.add_parser(
        'index', help='Build an index configuration file.'
    )
    index_parser.add_argument(
        '-i', '--inputs', metavar='inputs', type=pathlib.Path, nargs='+',
        help='The posts one wants to create a config for.'
    )
    index_parser.add_argument(
        '-o', '--output', metavar='output', type=pathlib.Path, nargs='?', default='index.json',
        help='The output destination of the json config.'
    )
    index_parser.set_defaults(func=index)

    args = parser.parse_args()
    args.func(args)
