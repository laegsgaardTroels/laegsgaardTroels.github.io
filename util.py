import argparse
import sys
import pathlib
import yaml


def print_yaml_header(args):
    headers = []
    for path in sorted(args.path, reverse=True):
        if path.suffix == '.md':
            _, header, content = path.read_text().split('---\n')
            headers.append(yaml.safe_load(header))
        else:
            raise NotImplementedError
    yaml.dump(headers, sys.stdout)


def build_index_md(args):
    index_md = {
        "title": "Machine Learning Notes",
        "post": [],
    }
    for path in sorted(args.path, reverse=True):
        post_metadata = yaml.safe_load(path.read_text())
        post_metadata["author"] = "Troels Lægsgaard"
        post_metadata["url"] = str(path.relative_to("src").with_suffix(".html"))
        post_metadata["code"] = "https://github.com/laegsgaardTroels/laegsgaardTroels.github.io/tree/master/" + str(path.parent)
        index_md["post"].append(post_metadata)
    print(f"---\n{yaml.dump(index_md)}---""")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Utilities.'
    )
    subparsers = parser.add_subparsers(help='Utilities')

    print_yaml_header_parser = subparsers.add_parser(
        'print_yaml_header', help='Print yaml header of md files.'
    )
    print_yaml_header_parser.add_argument(
        'path', type=pathlib.Path, nargs='+',
    )
    print_yaml_header_parser.set_defaults(func=print_yaml_header)

    build_index_md_parser = subparsers.add_parser(
        'build_index_md', help='Build the index.md.'
    )
    build_index_md_parser.add_argument(
        'path', type=pathlib.Path, nargs='+',
    )
    build_index_md_parser.set_defaults(func=build_index_md)

    args = parser.parse_args()
    args.func(args)
