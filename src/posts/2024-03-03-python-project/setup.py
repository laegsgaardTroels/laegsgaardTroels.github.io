
from setuptools import setup, find_packages


setup(
    name="foo",
    version="0.0.1",
    description="A package illustrating editable install.",
    url="https://github.com/laegsgaardTroels/autoreload",
    package_dir={"": "src"},
    packages=find_packages(
        where="src",
        include=["foo*"],
    ),
)
