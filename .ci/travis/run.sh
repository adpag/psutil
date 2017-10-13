#!/bin/bash

set -e
set -x

. $(dirname $0)/common.sh

# setup OSX
if [[ "$(uname -s)" == 'Darwin' ]]; then
    get_psutil_env_dir _psutil_env
    . $_psutil_env/bin/activate
fi

PYVER=`python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))'`

# install psutil
make clean
python setup.py build
python setup.py develop

# run tests (with coverage)
if [[ $PYVER == '2.7' ]] && [[ "$(uname -s)" != 'Darwin' ]]; then
    PSUTIL_TESTING=1 python -Wa -m coverage run psutil/tests/__main__.py
else
    PSUTIL_TESTING=1 python -Wa psutil/tests/__main__.py
fi

if [ "$PYVER" == "2.7" ] || [ "$PYVER" == "3.6" ]; then
    # run mem leaks test
    PSUTIL_TESTING=1 python -Wa psutil/tests/test_memory_leaks.py
    # run linter (on Linux only)
    if [[ "$(uname -s)" != 'Darwin' ]]; then
        python -Wa -m flake8
    fi
fi
