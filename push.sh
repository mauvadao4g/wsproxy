_push () 
{ 
    timestamp=$(date "+%Y%m%d%H%M%S");
    commit="Update: $timestamp";
    git add . && git commit -m "$commit" && git push origin main;
    if [ $? -eq 0 ]; then
        echo;
        echo -e "\e[1;32mCompletado com sucesso\e[0m";
    else
        echo;
        echo -e "\e[1;31mErro ao fazer o push dos arquivos.\e[0m";
        exit 1;
    fi
}

_push
