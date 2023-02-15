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
    ########################################################################################
    ##FUNCOES##
    ########################################################################################
    function install_dialog(){
        dialoginstall="$(apt-get install dialog -y)"
    }
    
    #########################################################################################################
    ##Funcoes da Opcao Ubuntu##
    #########################################################################################################
    function executa_vuln_ubuntu(){
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

    function executa_xss_ubuntu(){
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

    function install_amass_ubuntu(){
        echo "Instalando amass..."
        sleep 2
        install="$(go install -v github.com/OWASP/Amass/v3/...@master)"
        cp="$(cp /root/go/bin/amass  /usr/bin)"
        echo "Amass instalado com sucesso!"
    }
    
    function install_nuclei_ubuntu(){
        echo "Instalando nuclei..."
        install="$(go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest)"
        copy="$(cp /root/go/bin/nuclei /usr/bin)"
        echo "Instalado com sucesso!"
    }

    function install_golang_ubuntu(){
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

    function install_httprobe_ubuntu(){
        echo "Baixando httprobe..."
        sleep 3
        echo "Instalando..."
        githttprobe="$(go install github.com/tomnomnom/httprobe@latest)"
        copy="$(cp /root/go/bin/httprobe /usr/bin)"
        echo "Instalado com sucesso!"
    }

    function install_httpx_ubuntu(){
        echo "Baixando httpx..."
        sleep 3
        githttpx="$(go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest)"
        sleep 2
        echo "Instalando..."
        cp="$(cp /root/go/bin/httpx /usr/bin)"
        sleep 3
        echo "Finalizado com Sucesso!"
    }
    
    function install_dalfox_ubuntu(){
        echo "Baixando dalfox..."
        gitdalfox="$(go install github.com/hahwul/dalfox/v2@latest)"
        sleep 3
        echo "Instalando..."
        sleep 2
        copy="$(cp /root/go/bin/dalfox /usr/bin)"
        echo "Instalado com sucesso!"
    }

    function install_gau_ubuntu(){
        echo "Baixando gau..."
        gitgau="$(go install github.com/lc/gau/v2/cmd/gau@latest)"
        sleep 3
        echo "Instalando..."
        sleep 2
        instal="$(cp /root/go/bin/gau /usr/bin)"
        echo "Finalizado com sucesso!"
    }

    ##########################################################################################
    ## Funcoes opcao Kali##
    ##########################################################################################
    function executa_vuln_kali(){
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

    function executa_xss_kali(){
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


    function install_golang_kali(){
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
    
    function install_amass_kali(){
        echo "Instalando amass..."
        sleep 2
        install="$(go install -v github.com/OWASP/Amass/v3/...@master)"
        cp="$(cp /root/go/bin/amass  /usr/bin)"
        echo "Amass instalado com sucesso!"
    }   

    function install_nuclei_kali(){
        echo "Instalando nuclei..."
        install="$(go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest)"
        copy="$(cp /root/go/bin/nuclei /usr/bin)"
        echo "Instalado com sucesso!"
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

    function install_httprobe_kali(){
        echo "Baixando httprobe..."
        sleep 3
        echo "Instalando..."
        githttprobe="$(go install github.com/tomnomnom/httprobe@latest)"
        copy="$(cp /root/go/bin/httprobe /usr/bin)"
        echo "Instalado com sucesso!"
    }

    function install_httpx_kali(){
         echo "Baixando httpx..."
        sleep 3
        githttpx="$(go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest)"
        sleep 2
        echo "Instalando..."
        cp="$(cp /root/go/bin/httpx /usr/bin)"
        sleep 3
        echo "Finalizado com Sucesso!"
    }

    function install_dalfox_kali(){
        echo "Baixando dalfox..."
        gitdalfox="$(go install github.com/hahwul/dalfox/v2@latest)"
        sleep 3
        echo "Instalando..."
        sleep 2
        copy="$(cp /root/go/bin/dalfox /usr/bin)"
        echo "Instalado com sucesso!"
    }

    function install_gau_kali(){
        echo "Baixando gau..."
        gitgau="$(go install github.com/lc/gau/v2/cmd/gau@latest)"
        sleep 3
        echo "Instalando..."
        sleep 2
        instal="$(cp /root/go/bin/gau /usr/bin)"
        echo "Finalizado com sucesso!"
    }

    #####################
    ##  case do menu   ##
    #####################
    read opcao
    case $opcao in
        1)
            echo "Recon de dominios e busca por vulns"
            sleep 2
            ## Verifica se tem instalado dialog e instala caso nao tenha
            comdia="$(whereis dialog | cut -d " " -f 2)"
            if [ $comdia ==  /usr/bin/dialog ];then
                echo ""
            else 
               install_dialog
            fi
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
                com4="$(whereis httpx | cut -d " " -f 2)"
                com5="$(whereis httprobe | cut -d " " -f 2)"
                com6="$(whereis go | cut -d " " -f 2)"

                ##Condicionais da opcao Ubuntu
                if [ $com3 == /usr/bin/findomain ]; then
                    echo -e "findomain ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_findomain
                fi

                if [ $com6 == /usr/local/go/ -o /usr/local/go/bin/go ]; then
                    echo -e "go        ====> ""\e[1;32mok\e[0m"
                    sleep 3
                else 
                    install_golang_ubuntu
                fi

                if [ $com0 == /usr/bin/amass ] ; then
                    echo -e "amass     ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_amass_ubuntu
                fi

                if [ $com2 == /usr/local/bin/nuclei ] || [ /usr/bin/nuclei ] ; then
                    echo -e "nuclei    ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_nuclei_ubuntu
                fi

                if [ $com4 == /usr/bin/httpx ]; then
                    echo -e "httpx     ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else 
                    install_httpx_ubuntu
                fi

                if [ $com5 == /usr/bin/httprobe ]; then
                    echo -e "httprobe  ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_httprobe_ubuntu
                fi 

                executa_vuln_ubuntu
            fi

            ## Menu Opcao Kali
            if [ $menu == 2 ]; then
                echo -e "\n"
                echo "Verificando sistema..."
                sleep 3
                com0="$(whereis amass | cut -d " " -f 2)" 
                com1="$(cat /etc/issue | cut -d " " -f 1)"
                com2="$(whereis nuclei | cut -d " " -f 2)"
                com3="$(whereis findomain | cut -d " " -f 2)"
                com4="$(whereis httpx | cut -d " " -f 2)"
                com5="$(whereis httprobe | cut -d " " -f 2)"
                com6="$(whereis go | cut -d " " -f 2)"

                ## Condicionais Opcoes Kali
                if [ $com3 == /usr/bin/findomain ]; then
                    echo -e "findomain ====>" "\e[1;32mok\e[0m"
                    sleep 3

                else
                    install_findomain
                fi

                if [ $com6 == /usr/local/go/ -o /usr/local/go/bin/go ]; then
                    echo -e "go        ====> ""\e[1;32mok\e[0m"
                    sleep 3
                else 
                    install_golang_kali
                fi
                
                if [ $com0 == /usr/bin/amass ]; then
                    echo -e "amass     ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_amass_kali
                fi

                if [ $com2 == /usr/bin/nuclei ]; then
                    echo -e "nuclei    ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_nuclei_kali
                fi

                if [ $com4 == /usr/bin/httpx ]; then
                    echo -e "httpx     ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else 
                    install_httpx_kali
                fi

                if [ $com5 == /usr/bin/httprobe ]; then
                    echo -e "httprobe  ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_httprobe_kali
                fi

                executa_vuln_kali
            fi
            fi
            ;;
        
        2)  
            echo "Recon de subdomains com portas 80/443 ativos..."
            sleep 2
            comdia="$(whereis dialog | cut -d " " -f 2)"
            if [ $comdia ==  /usr/bin/dialog ];then
                echo ""
            else 
               install_dialog
            fi
            menu=$( dialog --menu "Escolha seu Sistema:" 0 0 0 1 Ubuntu 2 Kali --stdout)
            
            if [ $? != 1 ];then
                echo -e "\n"
                sleep 3

            ## Menu Escolha Ubuntu
            if [ $menu == 1 ]; then
                echo -e "\n"
                echo "Verificando sistema..."
                sleep 3
                com0="$(whereis findomain | cut -d " " -f 2)"
                com1="$(whereis go | cut -d " " -f 2)"
                com2="$(whereis httpx | cut -d " " -f 2)"
                com3="$(whereis httprobe | cut -d " " -f 2)"
                com4="$(whereis dalfox | cut -d " " -f 2)"
                com5="$(whereis gau | cut -d " " -f 2)"

                if [ $com0 == /usr/bin/findomain ]; then
                    echo -e "findomain ====>" "\e[1;32mok\e[0m"
                    sleep 3

                else
                    install_findomain
                fi

                if [ $com1 == /usr/local/go/ -o /usr/local/go/bin/go ]; then
                    echo -e "go        ====> ""\e[1;32mok\e[0m"
                    sleep 3
                else 
                    install_golang_ubuntu
                fi

                if [ $com2 == /usr/bin/httpx ]; then
                    echo -e "httpx     ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else 
                    install_httpx_ubuntu
                fi

                if [ $com3 == /usr/bin/httprobe ]; then
                    echo -e "httprobe  ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_httprobe_ubuntu
                fi 

                if [ $com4 == /usr/bin/dalfox ]; then
                    echo -e "Dalfox    ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_dalfox_ubuntu
                fi

                if [ $com5 == /usr/bin/gau ]; then
                    echo -e "gau       ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_gau_ubuntu
                fi

                executa_xss_ubuntu
            fi

            ## Menu Opcao Kali
            if [ $menu == 2 ]; then
                echo -e "\n"
                echo "Verificando sistema..."
                sleep 3
                com0="$(whereis findomain | cut -d " " -f 2)"
                com1="$(whereis go | cut -d " " -f 2)"
                com2="$(whereis httpx | cut -d " " -f 2)"
                com3="$(whereis httprobe | cut -d " " -f 2)"
                com4="$(whereis dalfox | cut -d " " -f 2)"
                com5="$(whereis gau | cut -d " " -f 2)"

                if [ $com0 == /usr/bin/findomain ]; then
                    echo -e "findomain ====>" "\e[1;32mok\e[0m"
                    sleep 3

                else
                    install_findomain
                fi

                if [ $com1 == /usr/local/go/ -o /usr/local/go/bin/go ]; then
                    echo -e "go        ====> ""\e[1;32mok\e[0m"
                    sleep 3
                else 
                    install_golang_kali
                fi

                if [ $com2 == /usr/bin/httpx ]; then
                    echo -e "httpx     ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else 
                    install_httpx_kali
                fi

                if [ $com3 == /usr/bin/httprobe ]; then
                    echo -e "httprobe  ====>" "\e[1;32mok\e[0m"
                    sleep 3
                else
                    install_httprobe_kali
                fi 

                if [ $com5 == /usr/bin/gau ]; then
                    echo -e "gau       ====>" "\e[1;32mok\e[0m"
                else
                    install_gau_kali
                fi

                if [ $com4 == /usr/bin/dalfox ]; then
                    echo -e "Dalfox    ====>" "\e[1;32mok\e[0m"
                else
                    install_dalfox_kali
                fi
                
                executa_xss_kali
            fi
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