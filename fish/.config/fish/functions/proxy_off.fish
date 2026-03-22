function proxy_off
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy
    echo "Proxy OFF"
end
