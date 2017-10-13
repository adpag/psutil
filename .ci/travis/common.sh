
function get_required_python_version() {
    local __return_variable=$1
    local __version

    case "${PYVER}" in
        py26)
            __version=2.6.9
            ;;
        py27)
            __version=2.7.10
            ;;
        py32)
            __version=3.2.6
            ;;
        py33)
            __version=3.3.6
            ;;
        py34)
            __version=3.4.3
            ;;
        *)
            echo Python version not set for "${PYVER}"
            exit 1
            ;;
    esac

    eval $__return_variable=\$__version
}

function get_psutil_env_dir() {
    local __return_variable=$1
    local __python_version
    local __env_dir

    get_required_python_version __python_version
    __env_dir=$HOME/.pyenv/versions/$__python_version/envs/psutil

    eval $__return_variable=\$__env_dir
}

