function snapnow --description 'Create a manual snapper snapshot with a timestamped description'
    if test (count $argv) -eq 0
        echo "usage: snapnow <description>" >&2
        return 1
    end
    sudo snapper -c root create --description "$argv - "(date '+%Y-%m-%d %H:%M')
end
