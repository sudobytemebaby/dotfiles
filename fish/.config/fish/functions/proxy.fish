function proxy --description 'Toggle HTTP/HTTPS/SOCKS5 proxy environment variables'
    set -l host 127.0.0.1
    set -l port 10808
    set -l http_url  http://$host:$port
    set -l socks_url socks5://$host:$port

    switch "$argv[1]"
        case on
            set -gx http_proxy  $http_url
            set -gx https_proxy $http_url
            set -gx HTTP_PROXY  $http_url
            set -gx HTTPS_PROXY $http_url
            set -gx all_proxy   $socks_url
            set -gx ALL_PROXY   $socks_url
            set -gx no_proxy    'localhost,127.0.0.1,::1'
            set -gx NO_PROXY    $no_proxy
            echo (set_color green)'[proxy on]'(set_color normal) $http_url

        case off
            set -e http_proxy https_proxy HTTP_PROXY HTTPS_PROXY \
                   all_proxy ALL_PROXY no_proxy NO_PROXY
            echo (set_color red)'[proxy off]'(set_color normal)

        case status ''
            if set -q http_proxy
                echo (set_color green)'[proxy on]'(set_color normal) $http_proxy
            else
                echo (set_color red)'[proxy off]'(set_color normal)
            end

        case '*'
            echo "usage: proxy on | off | status" >&2
            return 1
    end
end
