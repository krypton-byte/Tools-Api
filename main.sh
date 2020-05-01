#!/usr/bin/bash
. ./module.sh
clear
printf " _______  _______  _______  ___      _______    _______  _______  ___  \n|       ||       ||       ||   |    |       |  |   _   ||       ||   | \n|_     _||   _   ||   _   ||   |    |  _____|  |  |_|  ||    _  ||   | \n  |   |  |  | |  ||  | |  ||   |    | |_____   |       ||   |_| ||   | \n  |   |  |  |_|  ||  |_|  ||   |___ |_____  |  |       ||    ___||   | \n  |   |  |       ||       ||       | _____| |  |   _   ||   |    |   | \n  |___|  |_______||_______||_______||_______|  |__| |__||___|    |___| \n"
menu(){
echo '               -----------------+= Menu =+--------------------'
echo '                       1. Download Video Dari Youtube'
echo '                       2. Download Lagu Dari Youtube'
echo '                       3. Pengirim Pesan Email'
echo '               -----------------+========+--------------------'
while true
	do
	printf "   pilih : ";read P
	if [[ '1','01' =~ $P ]];then
		yt
		break
	elif [[ '2','02' =~ $P ]];then
		mp3
		break
	elif [[ '3','03' =~ $P ]];then
		email
		break
	else
		echo '   salah'
	fi
done
}
email(){
	printf '   email   : ';read email
	printf '   subject : ';read subject
	printf '   pesan   : ';read pesan
	sub=$(urlencode $subject)
	pes=$(urlencode $pesan)
	x=$(curl -s "https://krypton-api.herokuapp.com/api/email?to=$email&subject=$sub&pesan=$pes")
	printf "   status  : $(echo $x|jq .status -r)\n   pesan   : $(echo $x|jq .pesan -r)\n"
}
mp3(){
	printf '   url : ';read url
	curl=$(curl -s "https://krypton-api.herokuapp.com/api/yt2mp3?url=$url")
	if [[ $(echo $curl|jq .status -r) == 'error' ]];then
		echo 'error'
	else
		wget "$(echo $curl | jq .url -r)" -O "$(echo $curl|jq .judul -r).mp3"
	fi
}
yt(){
	printf '   url : ';read url
	curl=$(curl -s "https://krypton-api.herokuapp.com/api/yt?url=$url")
	judul=$(echo $curl|jq .judul -r)
	if [[ ${#judul} > 30 ]];then
		echo "   judul : ${judul:0:30} ......."
	else
		echo "   judul : $judul"
	fi
	if [[ $(echo $curl|jq .status -r ) == 'sukses' ]];then
		for i in $(seq $(echo $curl|jq .data |jq length))
		do
			printf "   $i. qualitas : $(echo $curl|jq .data[$i].res -r )\n"
			printf "      mime : $(echo $curl|jq .data[$i].type -r)/$(echo $curl|jq .data[$i].subtype -r)\n"
		done
		printf '   pilih : ';read pilih
		url=$( echo $curl|jq .data[$pilih].url -r)
		if [[ $url == 'null' ]];then
 			echo '   pilihan tidak tersedia'
		else
			wget $url -O "$judul.$(echo $curl|jq .data[$pilih].subtype -r)"
		fi
	else
		printf "   masukan url dengan benar\n"
	fi
}
menu
