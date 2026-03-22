function proxy_on
    set -gx http_proxy "http://127.0.0.1:10808"
    set -gx https_proxy "http://127.0.0.1:10808"
    set -gx all_proxy "socks5h://127.0.0.1:10808"
    echo "Proxy ON (127.0.0.1:10808)"
end
