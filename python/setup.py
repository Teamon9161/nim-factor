from pathlib import Path

from nimporter import build_nim_extensions
from setuptools import setup

setup(
    name="pyfactor",
    py_modules=["pyfactor"],
    ext_modules=build_nim_extensions(Path()),
)
