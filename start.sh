#!/bin/bash

ws_raw="https://raw.githubusercontent.com/mauvadao4g/wsproxy/refs/heads/main/proxy.py"
PROXY="$HOME/PROXY"
SESSION="ws_proxy"

if ! screen -list | grep -q "[.]$SESSION"; then

    clear
    echo -e "\033[1;32mINICIANDO WEBSOCKET\033[0m"
    echo

    mkdir -p "$PROXY"
    cd "$PROXY" || exit 1

    rm -f "$PROXY/wsproxy.py"

    echo "Baixando wsproxy.py..."

    if wget -q -O "$PROXY/wsproxy.py" "$ws_raw"; then

        chmod +x "$PROXY/wsproxy.py"

        echo "Iniciando WebSocket..."
        sleep 1

        screen -dmS "$SESSION" python2 "$PROXY/wsproxy.py" -p 80

        sleep 1

        if screen -list | grep -q "[.]$SESSION"; then
            clear
            echo "WEBSOCKET ATIVADO"
        else
            clear
            echo "ERRO AO INICIAR WEBSOCKET"
        fi

    else
        echo "ERRO: não foi possível baixar wsproxy.py"
        exit 1
    fi

else

    screen -S "$SESSION" -X quit

    clear
    echo "WEBSOCKET DESATIVADO"

fi
