#!/bin/bash

# ==============================
# CONFIG
# ==============================
ARQUIVO_LISTA="vps.txt"
NOVA_SENHA="nova_senha"

# ==============================
# DEPENDENCIAS
# ==============================
command -v sshpass >/dev/null || {
    echo "[!] Instalando sshpass..."
    apt-get update -y && apt-get install -y sshpass
}

# ==============================
# LOOP NAS VPS
# ==============================
while IFS="|" read -r IP USUARIO SENHA PORTA
do
    echo "======================================"
    echo "[+] VPS: $IP"

    # Remove fingerprint antiga (evita erro)
    ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$IP" >/dev/null 2>&1

    # Troca senha
    sshpass -p"$SENHA" ssh -o IdentitiesOnly=yes -o PreferredAuthentications=password -o StrictHostKeyChecking=no -p "${PORTA:-22}" $USUARIO@$IP <<EOF
echo "$USUARIO:$NOVA_SENHA" | chpasswd
echo "[OK] Senha alterada"
EOF

    if [[ $? -eq 0 ]]; then
        echo "[✔] Sucesso: $IP"
    else
        echo "[✖] Falhou: $IP"
    fi

done < "$ARQUIVO_LISTA"
