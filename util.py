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


def index_md(args):
    index_md = {
        "title": "Machine Learning Notes",
        "post": [],
    }
    for path in sorted(args.path, reverse=True):
        post_metadata = yaml.safe_load(path.read_text())
        if post_metadata.get('category', 'Not Course') != 'Course':
            index_md["post"].append(post_metadata)
    print(f"---\n{yaml.dump(index_md)}---""")


def courses_md(args):
    courses_md = {
        "title": "Courses",
        "post": [],
    }
    for path in sorted(args.path, reverse=True):
        post_metadata = yaml.safe_load(path.read_text())
        if post_metadata.get('category', 'Not Course') == 'Course':
            courses_md["post"].append(post_metadata)
    print(f"---\n{yaml.dump(courses_md)}---""")


def metadata(args):
    metadata = yaml.safe_load(args.path.read_text())
    if metadata is None:
        metadata = {}
    metadata["year"], metadata["month"], metadata["day"] = args.path.parent.stem.split('-')[:3]
    metadata["date"] = '-'.join(args.path.parent.stem.split('-')[:3])
    metadata["author"] = "Troels Lægsgaard"
    metadata["url"] = str(args.path.relative_to("src").with_suffix(".html"))
    if "code" not in metadata:
        metadata["code"] = "https://github.com/laegsgaardTroels/laegsgaardTroels.github.io/tree/master/" + str(args.path.parent)
    if "chat" not in metadata:
        metadata["chat"] = True
    yaml.dump(metadata, sys.stdout)


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

    index_md_parser = subparsers.add_parser(
        'index_md', help='Build the index.md.'
    )
    index_md_parser.add_argument(
        'path', type=pathlib.Path, nargs='+',
    )
    index_md_parser.set_defaults(func=index_md)

    courses_md_parser = subparsers.add_parser(
            'courses_md', help='Build the courses.md.'
    )
    courses_md_parser.add_argument(
        'path', type=pathlib.Path, nargs='+',
    )
    courses_md_parser.set_defaults(func=courses_md)

    metadata_parser = subparsers.add_parser(
        'metadata', help='Build metadata'
    )
    metadata_parser.add_argument(
        'path', type=pathlib.Path,
    )
    metadata_parser.set_defaults(func=metadata)

    args = parser.parse_args()
    args.func(args)
