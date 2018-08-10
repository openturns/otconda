#!/bin/sh

# Explicitly move noarch packages into `lib/python?.?/site-packages` as a
# workaround to [this issue][i86] with lack of `constructor` support for
# `noarch` packages.
#
# [i86]: https://github.com/conda/constructor/issues/86#issuecomment-330863531
if [[ -e site-packages ]]; then
    for DIR in site-packages/*; do
        if [[ -d $DIR ]]; then
            mv $DIR $PREFIX/lib/python?.?/site-packages
        else
            filename=$(basename -- "$DIR")
            extension="${filename##*.}"
            if [[ $extension == 'py' ]]; then
                mv $DIR $PREFIX/lib/python?.?/site-packages
            fi
        fi
    done
    rm -r site-packages
fi
