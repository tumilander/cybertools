#!/bin/bash

## Validacao se o usuário está com root
if [ $UID -ne 0 ]; then
    echo -e "\e[1;31m\nVocê precisa ser root para executar este script!\e[0m"
    echo -e "\n"
    exit 1
fi

function check_instalacoes {
    command -v $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Instalando $2..."
        apt-get install -y $2
        echo "$2 instalado com sucesso!"
    else
        echo "$2 já está instalado."
    fi
}

check_instalacoes findomain findomain
check_instalacoes httprobe tomnomnom/httprobe
check_instalacoes httpx projectdiscovery/httpx/cmd/httpx@latest
check_instalacoes nuclei projectdiscovery/nuclei/v2/cmd/nuclei@latest
check_instalacoes dalfox hahwul/dalfox/v2@latest
check_instalacoes gau lc/gau/v2/cmd/gau@latest

echo -e "                                                                   ";
echo -e "   ___          _                   _____                _         ";
echo -e "  / __|  __ __ | | _    __    _ _  |_   _|    _     _   | |    _   ";
echo -e " | (__  | || | | '_ \ / -_)  | '_|   | |    / _ \ / _ \ | |  (_-<  ";
echo -e "  \___|  \_, | |_.__/ \___|  |_|     |_|    \___/ \___/ |_|  /__/  ";
echo -e "         |__/                                                      ";
echo -e "                                                           | v.1.2 "
echo ""
echo -e "\033[05;31mBy Tumil\033[00;37m"

## While true -- Menu que sempre irá retornar
while true; do
    echo -e "\n"
    echo "Escolha uma opção:"
    echo -e "\n"
    echo "1 - Procura por Vulns" 
    echo "2 - Recon automático para XSS" 
    echo -e "\n0 - Sair"
    echo -e "\n"

    read opcao
    case $opcao in
        1)
            echo "Recon de domínios e busca por vulns"
            sleep 2

            echo -e "\n"
            echo "Digite o domínio:"
            read dominio
            findomain --output -t $dominio
            cat $dominio".txt" | httprobe > resolv.txt
            cat resolv.txt | sort -u > param.txt
            cat param.txt | httpx -mc 200 -o 200.txt
            cat 200.txt | nuclei 
            rm $dominio.txt resolv.txt param.txt 200.txt
            ;;

        2)
            echo "Recon de subdomínios com portas 80/443 ativas..."
            sleep 2

            echo -e "\n"
            echo "Digite o domínio:"
            read domain
            findomain --output -t $domain
            cat $domain".txt" | httprobe > resolv.txt
            cat resolv.txt | gau | grep "=" | sed 's/=.*/=/' | sort -u > param.txt
            cat param.txt | httpx -mc 200 -o 200.txt
            cat 200.txt | dalfox pipe
            rm resolv.txt $domain.txt param.txt 200.txt
            ;;

        0)
            echo -e "\n\n\nSaindo...Beep! Beep!"
            echo -e "\n"
            break
            ;;

        *)
            echo "Opção inválida!"
            ;;
    esac
done
