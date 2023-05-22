#!/usr/bin/env python

from __future__ import print_function
import os
import re
import sys
import subprocess
import platform


def parse_modules(filename):
    modules = []
    with open(filename) as construct:
        start = False
        end = False
        for line in construct.readlines():
            if start:
                m = re.search('^  - ([\w\-]+)', line)
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
    package_import_map = {'ipython': 'IPython', 'scikit-learn': 'sklearn'}
    excludes = ['python', 'miniforge_console_shortcut']
    for mod in modules:
        if mod in excludes:
            continue
        print(mod.ljust(40), end='')
        try:
            imp = package_import_map.get(mod, mod)
            version = subprocess.check_output([sys.executable, '-c', 'import ' + imp +'; import sys; sys.stdout.write(' + imp + '.__version__)'], stderr=subprocess.STDOUT)
            print(version.decode())
        except subprocess.CalledProcessError as exc:
            n_fail += 1
            print('***Failed')
            print(exc.output.decode())
    return n_fail


if __name__ == '__main__':
    print('python'.ljust(40) + platform.python_version())
    modules = parse_modules(os.path.join('otconda', 'construct.yaml'))
    n_fail = check_modules(modules)
    sys.exit(n_fail)
