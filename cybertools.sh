#!/bin/bash

#####################################
#                                   #
#       By Anderson Ribeiro         #
#  https://github.com/tumilander/   #
#                                   #
#####################################

## Validacao se o usuario esta com root
if [ $UID -ne 0 ]; then
	echo -e "\e[1;31m\nVocê precisa ser root para executar este script!\e[0m"
    echo -e "\n"
	exit 1
fi

## Verifica se tem instalado dialog e instala caso nao tenha
dialog="$(whereis dialog | cut -d " " -f 2)"
    if [ $dialog ==  /usr/bin/dialog ];then
    echo ""
    else 
        dialoginstall
    fi
                                                                                     
echo -e "                                                                   "; 
echo -e "   ___          _                   _____                _         "; 
echo -e "  / __|  __ __ | | _    __    _ _  |_   _|    _     _   | |    _   "; 
echo -e " | (__  | || | | '_ \ / -_)  | '_|   | |    / _ \ / _ \ | |  (_-<  "; 
echo -e "  \___|  \_, | |_.__/ \___|  |_|     |_|    \___/ \___/ |_|  /__/  "; 
echo -e "         |__/                                                      "; 
echo -e "                                                           | v.1.1 "
echo ""
echo -e "\033[05;31mBy Tumil\033[00;37m"

## While true -- Menu que sempre ira retornar
while true
do
    echo -e "\n"
    echo "Escolha uma opção:"
    echo -e "\n"
    echo "1" " - Procura por Vulns                       " 
    echo "2" " - Recon automatico para XSS                     "
    echo -e "\n0" " - Sair                                     "

    echo -e "\n"
    read opcao

    ## case do menu
    case $opcao in
        1)
            echo "Recon de dominios e busca por vulns"
            sleep 2
            menu=$( dialog --menu "Escolha seu Sistema:" 0 0 0 1 Ubuntu 2 Kali --stdout)
            
            if [ $? != 1 ];then
                        
            ## Menu de escolha Ubuntu
            if [ $menu == 1 ]; then
                echo -e "\n"
                echo "Verificando sistema..."
                sleep 3
                com0="$(whereis amass | cut -d " " -f 2)" 
                com1="$(cat /etc/issue | cut -d " " -f 1)"
                com2="$(whereis nuclei | cut -d " " -f 2)"
                com3="$(whereis findomain | cut -d " " -f 2)"
                
                ## Inicio das funcoes
                function executa_vuln(){
                    echo -e "\n"
                    echo "Digite o dominio: "
                    read dominio
                    findomain --output -t $dominio
                    cat $dominio".txt" | httprobe > resolv.txt
                    cat resolv.txt | sort -u > param.txt
                    cat param.txt | httpx -mc 200 -o 200.txt
                    cat 200.txt | nuclei 
                    rm $dominio.txt
                    rm resolv.txt 
                    rm param.txt
                    rm 200.txt
                }

                ##Funcoes da Opcao Ubuntu
                function install_amass_ubuntu(){
                    echo "Instalando amass..."
                    snap install amass
                    export PATH=$PATH:/snap/bin
                    sudo snap refresh
                }

                function install_nuclei_ubuntu(){
                    echo "Instalando nuclei..."
                    git clone https://github.com/projectdiscovery/nuclei.git
                    go build ./nuclei/v2/cmd/nuclei/main.go
                    mv ./nuclei/v2/cmd/nuclei/main.go ./nuclei/v2/cmd/nuclei/nuclei
                    cp ./nuclei/v2/cmd/nuclei/nuclei /usr/local/bin/
                    rm -rf ./nuclei
                    install="#(nuclei)"
                    echo "Instalado com sucesso!"
                }

                ##Condicionais da opcao Ubuntu
                if [ $com3 == /usr/bin/findomain ]; then
                    echo -e "findomain ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_findomain
                fi

                if [ $com0 == /snap/bin/amass ] && [ $com1 == Ubuntu ]; then
                    echo -e "amass     ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_amass_ubuntu
                fi

                if [ $com2 == /usr/local/bin/nuclei ] || [ /usr/bin/nuclei ] && [ $com1 == Ubuntu ]; then
                    echo -e "nuclei    ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_nuclei_ubuntu
                fi

                executa_vuln
            fi

            ## Menu Opcao Kali
            if [ $menu == 2 ]; then
                echo -e "\n"
                echo "Verificando sistema..."
                sleep 3
                com0="$(whereis amass | cut -d " " -f 2)" 
                com1="$(cat /etc/issue | cut -d " " -f 1)"
                com2="$(whereis nuclei | cut -d " " -f 2)"
                
                ## Funcoes opcao Kali
                function install_amass_kali(){
                       echo "Instalando amass..."
                       sleep 2
                       apt-get install amass -y
                       echo "Amass instalado com sucesso!"
                }

                function install_nuclei_kali(){
                    echo "Instalando nuclei..."
                    go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
                    apt install nuclei -y
                }

                ## Condicionais Opcoes Kali
                if [ $com3 == /usr/bin/findomain ]; then
                    echo -e "findomain ====>" "\e[1;32mok\e[0m"
                    sleep 3

                else
                    install_findomain
                fi
                
                if [ $com0 == /usr/bin/amass ] && [ $com1 == kali ]; then
                    echo -e "amass     ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_amass_kali
                fi

                if [ $com2 == /usr/bin/nuclei ] && [ $com1 == kali ]; then
                    echo -e "nuclei    ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_nuclei_kali
                fi

                executa_vuln
            fi
            fi
            ;;
        
        2)  
            echo "Recon de subdomains com portas 80/443 ativos..."
            sleep 2
            dialog --title "Sera instalado os seguintes pacotes" --yesno "\nfindomain\ngolang\nhttprobe\ngau\nhttpx\ndalfox\n \
            \nEscolha 'Sim' para seguir ou 'Nao' para cancelar" 15 45 --stdout
            
            if [ $? == 0 ]; then
                echo -e "\n"
                echo "Verificando sistema..."
                sleep 3
                com0="$(whereis findomain | cut -d " " -f 2)"
                com1="$(whereis go | cut -d " " -f 2)"
                com2="$(whereis httpx | cut -d " " -f 2)"
                com3="$(whereis httprobe | cut -d " " -f 2)"
                com4="$(whereis dalfox | cut -d " " -f 2)"
                com5="$(whereis gau | cut -d " " -f 2)"

                function install_dialog(){
                    dialoginstall="$(apt-get install dialog -y)"
                }

                function install_findomain(){
                    echo "Baixando findomain..."
                    curl -# -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip
                    sleep 2
                    echo "Descompactando..."
                    sleep 2
                    descomp="$(unzip findomain-linux-i386.zip)"
                    sleep 2
                    chmod="$(chmod +x ./findomain)"
                    echo "Finalizando..."
                    final="$(sudo mv ./findomain /usr/bin/findomain)"
                    sleep 2
                    echo "Finalizado com sucesso!"
                }

                function install_golang(){
                    echo "Baixando Go..."
                    curl -# -LO https://go.dev/dl/go1.20.linux-amd64.tar.gz
                    sleep 2
                    descompactando="$(rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.linux-amd64.tar.gz)"
                    sleep 2
                    export="$(export PATH=$PATH:/usr/local/go/bin)"
                    echo "Finalizando..."
                    remove="$(rm -rf ./go1*)"
                    sleep 2
                    echo "Finalizado com sucesso!"
                    
                }

                function install_httpx(){
                    echo "Baixando httpx..."
                    sleep 3
                    githttpx="$(git clone https://github.com/projectdiscovery/httpx.git)"
                    sleep 2
                    echo "Instalando..."
                    insta="$(go build ./httpx/cmd/httpx/httpx.go)"
                    move="$(cp ./httpx/cmd/httpx/httpx /usr/local/bin)"
                    remove="$(rm -rf ./httpx)" 
                    sleep 3
                    echo "Finalizado com Sucesso!"
                }

                function install_httprobe(){
                    echo "Baixando httprobe..."
                    githttprobe="$(git clone https://github.com/tomnomnom/httprobe.git)"
                    sleep 3
                    echo "Instalando..."
                    sleep 2
                    echo "Instalando..."
                    insta="$(go build ./httprobe/main.go)"
                    move="$(mv ./httprobe/main ./httprobe/httprobe)"
                    copy="$(cp ./httprobe/httprobe /usr/local/bin)"
                    remove="$(rm -rf ./httprobe)"
                    echo "Instalado com sucesso!"
                }

                function install_dalfox(){
                    echo "Baixando dalfox..."
                    gitdalfox="$(git clone https://github.com/hahwul/dalfox.git)"
                    sleep 3
                    echo "Instalando..."
                    sleep 2
                    instal="$(go build ./dalfox/dalfox.go)"
                    copy="$(cp ./dalfox/dalfox /usr/local/bin)"
                    remove="$(rm -rf ./dalfox)"
                    echo "Instalado com sucesso!"
                }

                function install_gau(){
                    echo "Baixando gau..."
                    gitgau="$(git clone https://github.com/lc/gau.git)"
                    sleep 3
                    echo "Instalando..."
                    sleep 2
                    instal="$(go build ./gau/cmd/gau/main.go)"
                    rename="$(mv ./gau/cmd/gau/main.go ./gau/cmd/gau/gau)"
                    move="$(mv ./gau/cmd/gau/gau /usr/local/bin)"
                    chomd="$(chmod +x /usr/local/bin/gau)"
                    remove="$(rm -rf ./gau)"
                    echo "Finalizado com sucesso!"
                }

                function executa_xss(){
                    echo -e "\n"
                    echo "Digite o dominio: "
                    read domain
                    findomain --output -t $domain
                    cat $domain".txt" | httprobe > resolv.txt
                    cat resolv.txt | gau | grep "=" | sed 's/=.*/=/' | sort -u > param.txt
                    cat param.txt | httpx -mc 200 -o 200.txt
                    rm resolv.txt
                    rm $domain.txt
                    rm param.txt
                    cat 200.txt | dalfox pipe
                    rm 200.txt
                }


                if [ $com0 == /usr/bin/findomain ]; then
                    echo -e "findomain ====>" "\e[1;32mok\e[0m"
                    sleep 3

                else
                    install_findomain
                fi

                if [ $com1 == /usr/local/go/bin/go -o /usr/bin/go -o /usr/lib/go -o /usr/local/go -o /usr/share/go ]; then
                    echo -e "go        ====> ""\e[1;32mok\e[0m"
                    sleep 3
                else 
                    install_golang
                fi

                if [ $com2 == /usr/local/bin/httpx ]; then
                    echo -e "httpx     ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else 
                    install_httpx
                fi

                if [ $com3 == /usr/local/bin/httprobe ]; then
                    echo -e "httprobe  ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_httprobe
                fi 

                if [ $com4 == /usr/local/bin/dalfox ]; then
                    echo -e "Dalfox    ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_dalfox
                fi

                if [ $com5 == /usr/local/bin/gau ]; then
                    echo -e "gau       ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_gau
                fi

                executa_xss
            fi

            ;;

           0)  ## Verifica se o Sistem tem instalado o Fortune-br e o cowsay, caso nao, instala. 
               ## toda vez que o usuario sair do sistema, uma msg randomica com imagem do Tux ou vaca aparecera
            fortune="$(whereis fortune |cut -d " " -f 2)"
            com0="$(whereis cowsay | cut -d " " -f 2)"
            com3="$(apt-get install apt-utils -y)"
            if [ $com0 == /usr/games/cowsay -a fortune == /usr/games/fortune ]; then
                random=$(( $RANDOM % 2 ))
                if [ $random -eq 0 ]; then
                    fortune | cowsay
                else
                    fortune | cowsay -f tux
                fi
            else
                com1="$(apt-get install cowsay -y)"
                comfort="$(apt-get install fortunes-br -y)"
                random=$(( $RANDOM % 2 ))
                if [ $random -eq 0 ]; then
                    fortune | cowsay
                else
                    fortune | cowsay -f tux
                fi
            fi
            echo -e "\n\n\nSaindo...Beep! Beep!"
            echo -e "\n"
            break
            ;;
        *)
            echo "Opção inválida!"
            ;;
    esac
done