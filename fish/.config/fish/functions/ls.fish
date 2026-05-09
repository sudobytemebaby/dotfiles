function ls --wraps=eza --description 'List directory contents (eza)'
    eza --grid --icons --git --color=auto --all $argv
end
