#!/opt/homebrew/bin/fish

if test -n "$VIRTUAL_ENV"
    set python_path "$VIRTUAL_ENV/bin/python"
else if test -n "$CONDA_PREFIX"
    set python_path "$CONDA_PREFIX/bin/python"
else
    set python_path "python"
end

set -x PYTHONPATH $python_path
basedpyright-langserver --stdio
