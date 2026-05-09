function proxy
    set PROXY_HOST "127.0.0.1"
    set PROXY_PORT "10808"
    set PROXY_URL "http://$PROXY_HOST:$PROXY_PORT"

    if test "$argv[1]" = "on"
        set -gx http_proxy $PROXY_URL
        set -gx https_proxy $PROXY_URL
        set -gx HTTP_PROXY $PROXY_URL
        set -gx HTTPS_PROXY $PROXY_URL
        set -gx all_proxy "socks5://$PROXY_HOST:$PROXY_PORT"
        echo (set_color green)"[Proxy ON]:"(set_color normal) $PROXY_URL

    else if test "$argv[1]" = "off"
        set -ge http_proxy
        set -ge https_proxy
        set -ge HTTP_PROXY
        set -ge HTTPS_PROXY
        set -ge all_proxy
        echo (set_color red)"[Proxy OFF]"(set_color normal)

    else
        echo "Usage: proxy on | proxy off"
    end
end
