function snapclean --description 'Run snapper timeline + number cleanup on the root config'
    sudo snapper -c root cleanup timeline
    and sudo snapper -c root cleanup number
end
