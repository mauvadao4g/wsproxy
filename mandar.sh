#!/bin/bash
# BY: MAUVADAO
# VER: 1.5

set -e

BASE_DIR=$(basename "$PWD")
ARQ="${BASE_DIR}.zip"

# USER|HOST|SENHA|PORTA
SERVERS=(
    #"root|152.67.39.50|malvadao|22"
    #"root|142.44.232.37|hannah|22"
    "root|142.44.232.37|JP69pwsWYP9Q|22"
)

echo "[+] Compactando $ARQ..."

zip -rq "$ARQ" . \
    -x "*.git*" \
    -x "node_modules/*" \
    -x "$ARQ"

for SERVER in "${SERVERS[@]}"; do
(
    IFS='|' read -r USER HOST PASS PORT <<< "$SERVER"

    echo "[+] Enviando para $HOST"

    sshpass -p"$PASS" rsync \
        --progress \
        -avz \
        -e "ssh -p $PORT -o StrictHostKeyChecking=no" \
        "$ARQ" "$USER@$HOST:~/"

    echo "[+] Extraindo em $HOST"

    sshpass -p"$PASS" ssh \
        -p "$PORT" \
        -o StrictHostKeyChecking=no \
        "$USER@$HOST" "
            mkdir -p ~/$BASE_DIR &&
            unzip -o ~/$ARQ -d ~/$BASE_DIR >/dev/null 2>&1 &&
            rm -f ~/$ARQ
        "

    echo "[✓] Finalizado $HOST"

)&
done

wait

echo "[+] Limpando local..."
rm -f "$ARQ"

echo "[✓] Tudo concluído."