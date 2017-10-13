#!/bin/bash

set -e
set -x

uname -a
python -c "import sys; print(sys.version)"

if [[ "$(uname -s)" == 'Darwin' ]]; then
    case "${PYVER}" in
        py26)
            _python_version=2.6.9
            ;;
        py27)
            _python_version=2.7.10
            ;;
        py32)
            _python_version=3.2.6
            ;;
        py33)
            _python_version=3.3.6
            ;;
        py34)
            _python_version=3.4.3
            ;;
        *)
            echo Python version not set for "${PYVER}"
            exit 1
            ;;
    esac

    _psutil_env=$HOME/.pyenv/versions/$_python_version/envs/psutil

    if [ ! -d $_psutil_env ]; then
        brew update || brew update
        brew outdated pyenv || brew upgrade pyenv
        brew install pyenv-virtualenv

        if which pyenv > /dev/null; then
            eval "$(pyenv init -)"
        fi

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
