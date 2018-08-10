#!/usr/bin/env python
from __future__ import print_function
import re
import sys
import subprocess

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
            subprocess.check_output([sys.executable, '-c', 'import ' + mod], stderr=subprocess.STDOUT)
            print('OK')
        except subprocess.CalledProcessError as exc:
            n_fail += 1
            print('***Failed')
            print(exc.output.decode())
    return n_fail


if __name__ == '__main__':
    modules = parse_modules('construct.yaml')
    n_fail = check_modules(modules)
    sys.exit(n_fail)
