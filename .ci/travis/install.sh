#!/bin/bash

set -e
set -x

. $(dirname $0)/common.sh

uname -a
python -c "import sys; print(sys.version)"

if [[ "$(uname -s)" == 'Darwin' ]]; then
    get_psutil_env_dir _psutil_env

    if [ ! -d $_psutil_env ]; then
        brew update || brew update
        brew outdated pyenv || brew upgrade pyenv
        brew install pyenv-virtualenv

        if which pyenv > /dev/null; then
            eval "$(pyenv init -)"
        fi

        get_required_python_version _python_version
        pyenv install $_python_version
        pyenv virtualenv $_python_version psutil
        pyenv rehash
        pyenv activate psutil
    else
        . $_psutil_env/bin/activate
    fi
fi

if [[ $TRAVIS_PYTHON_VERSION == '2.6' ]] || [[ $PYVER == 'py26' ]]; then
    pip install -U ipaddress unittest2 argparse mock==1.0.1
elif [[ $TRAVIS_PYTHON_VERSION == '2.7' ]] || [[ $PYVER == 'py27' ]]; then
    pip install -U ipaddress mock
elif [[ $TRAVIS_PYTHON_VERSION == '3.2' ]] || [[ $PYVER == 'py32' ]]; then
    pip install -U ipaddress mock
elif [[ $TRAVIS_PYTHON_VERSION == '3.3' ]] || [[ $PYVER == 'py33' ]]; then
    pip install -U ipaddress
fi

pip install -U coverage coveralls flake8 pep8 setuptools
