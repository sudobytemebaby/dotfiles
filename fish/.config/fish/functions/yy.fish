function yy --wraps=yazi --description 'Open yazi and cd into its last directory on exit'
    set -l tmp (mktemp -t yazi-cwd.XXXXXX)
    yazi $argv --cwd-file=$tmp
    if read -z cwd <$tmp
        and test -n "$cwd"
        and test "$cwd" != "$PWD"
        builtin cd -- $cwd
    end
    rm -f -- $tmp
end
