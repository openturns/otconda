#!/usr/bin/env python
from __future__ import print_function
import re
import importlib
import sys
import traceback


def parse_modules(filename):
    modules = []
    with open(filename) as construct:
        start = False
        end = False
        for line in construct.readlines():
            if start:
                m = re.search('^  - ([\w]+)$', line)
                if m is not None:
                    modules.append(m.group(1))
                else:
                    m = re.search('license_file:', line)
                    if m is not None:
                        end = True
            else:
                m = re.search('specs:', line)
                if m is not None:
                    start = True
            if end:
                break
    return modules



def check_modules(modules):
    n_fail = 0
    for mod in modules:
        print(mod.ljust(40), end='')
        try:
            importlib.import_module(mod)
            print('OK')
        except ImportError as exc:
            n_fail += 1
            print('***Failed')
            traceback.print_exc()
    return n_fail


if __name__ == '__main__':
    modules = parse_modules('construct.yaml')
    n_fail = check_modules(modules)
    sys.exit(n_fail)
