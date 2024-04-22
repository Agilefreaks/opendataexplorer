#!/bin/bash

get_initial_page() {
	curl 'http://declaratii.integritate.eu/search.html' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'Referer: http://declaratii.integritate.eu/statistics.html' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1'
}

get_jsession_id() {
	grep -o 'jsessionid=[^"]*' | awk -F '=' '{print $2; exit}'
}

get_ice_window(){
	grep -o '<[^>]*name="ice.window"[^>]*'|grep -o 'value="[^"]*'| awk -F '"' '{print $2; exit}'
}

get_ice_view(){
	grep -o '<[^>]*name="ice.view"[^>]*'|grep -o 'value="[^"]*'| awk -F '"' '{print $2; exit}'|sed 's/:/%3A/'
}

get_view_state(){
	grep -o '<[^>]*name="javax.faces.ViewState"[^>]*'|grep -o 'value="[^"]*'| awk -F '"' '{print $2; exit}'|sed 's/:/%3A/'
}

click_cautare_avansata() {
	local jsessionid="$1"
	local window="$2"
	local view="$3"
	local view_state="$4"

	curl "http://declaratii.integritate.eu/search.html;jsessionid=$jsessionid"\
		-X POST\
		-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0'\
		-H 'Accept: */*'\
		-H 'Accept-Language: en-US,en;q=0.5'\
		-H 'Accept-Encoding: gzip, deflate'\
		-H 'Faces-Request: partial/ajax'\
		-H 'Content-type: application/x-www-form-urlencoded;charset=UTF-8'\
		-H 'Origin: http://declaratii.integritate.eu'\
		-H 'Connection: keep-alive'\
		-H 'Referer: http://declaratii.integritate.eu/search.html'\
		-H "Cookie: JSESSIONID=$jsessionid; _ga=GA1.2.1108484763.1713624375; _gid=GA1.2.2066264236.1713624375; _gat=1"\
		--data-raw "form=form&ice.window=$window&ice.view=$view&form%3AsearchKey_input=&form%3AsearchField_input=numePrenume&javax.faces.ViewState=$view_state&javax.faces.ClientWindow=$window&form%3AshowAdvancedSearch=form%3AshowAdvancedSearch&javax.faces.source=form&javax.faces.partial.execute=%40all&javax.faces.partial.render=%40all&ice.window=$window&ice.view=$view&ice.focus=&ice.event.target=form&ice.event.captured=form&ice.event.type=onsubmit&ice.submit.type=ice.s&ice.submit.serialization=form&javax.faces.partial.ajax=true"
}

cautare_avansata() {
	local jsessionid="$1"
	local window="$2"
	local view="$3"
	local view_state="$4"
	local start_date="$5" #04.01.2023
	local stop_date="$6"

	curl 'http://declaratii.integritate.eu/search.html'\
		-X POST\
		-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0'\
		-H 'Accept: */*'\
		-H 'Accept-Language: en-US,en;q=0.5'\
		-H 'Accept-Encoding: gzip, deflate'\
		-H 'Faces-Request: partial/ajax'\
		-H 'Content-type: application/x-www-form-urlencoded;charset=UTF-8'\
		-H 'Origin: http://declaratii.integritate.eu'\
		-H 'Connection: keep-alive'\
		-H 'Referer: http://declaratii.integritate.eu/search.html'\
		-H "Cookie: JSESSIONID=$jsessionid; _ga=GA1.2.1108484763.1713624375; _gid=GA1.2.2066264236.1713624375"\
		--data-raw "form=form&ice.window=$window&ice.view=$view&form%3ANumePrenume_input=&form%3AautoComplete_input=&form%3AFnc_input=&form%3AstartDate_input=$start_date&form%3AendDate_input=$stop_date&form%3AJudet_input=-1&form%3ALocalitate_input=-1&form%3ATip_input=-1&advancedAction=&javax.faces.ViewState=$view_state&javax.faces.source=form%3AsubmitButtonAS&javax.faces.partial.execute=%40all&javax.faces.partial.render=%40all&ice.window=$window&ice.view=$view&ice.focus=form%3AsubmitButtonAS&form%3AsubmitButtonAS=caut%C4%83%3E&ice.event.target=form%3AsubmitButtonAS&ice.event.captured=form%3AsubmitButtonAS&ice.event.type=onclick&ice.event.alt=false&ice.event.ctrl=false&ice.event.shift=false&ice.event.meta=false&ice.event.x=420&ice.event.y=964&ice.event.left=true&ice.event.right=false&javax.faces.behavior.event=click&javax.faces.partial.event=click&javax.faces.partial.ajax=true"
}

get_urls(){
	grep -o 'a href="/DownloadServlet[^"]*'
}

get_file_name(){
	grep -o "fileName=[^&]*"| awk -F '=' '{print $2}'
}

get_unique_id(){
	grep -o "uniqueIdentifier=[^&]*"| awk -F '=' '{print $2}'
}

download_file(){
	local rezultat="$1"
	local fname="$(echo "$rezultat"|get_file_name)"
	local unique_id="$(echo "$rezultat"|get_unique_id)"
	# echo "rezultat=$rezultat"
	# echo "fname=$fname"
	# echo "unique_id=$unique_id"
	# echo ""
	curl "http://declaratii.integritate.eu/DownloadServlet?fileName=$fname&uniqueIdentifier=$unique_id"\
		--output declaratii3/$fname\
		-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'Connection: keep-alive' -H 'Referer: http://declaratii.integritate.eu/search.html' -H 'Cookie: _ga=GA1.2.1108484763.1713624375; _gid=GA1.2.2066264236.1713624375; JSESSIONID=F0FE6089A20B08C189E23519EDE5537C' -H 'Upgrade-Insecure-Requests: 1'
}

download_docs(){
	local rezultate_cautare="$1"
	IFS=$'\n'
	for rezultat in $rezultate_cautare; do
		download_file "$rezultat"
	done	
}

data="$(get_initial_page)"
jsessionid="$(echo "$data"|get_jsession_id)"
ice_window="$(echo "$data"|get_ice_window)"
ice_view="$(echo "$data"|get_ice_view)"
view_state="$(echo "$data"|get_view_state)"
click_cautare_avansata "$jsessionid" "$ice_window" "$ice_view" "$view_state" >/dev/null 2>/dev/null
#rezultate_cautare="$(cautare_avansata "$jsessionid" "$ice_window" "$ice_view" "$view_state" "05.01.2023" "07.01.2023"|get_urls)"

for i in $(seq 0 365);do
	j=$(($i+2))
	start="$(date '+%d.%m.%Y' -d "2023-01-01 +$i days")"
	end="$(date '+%d.%m.%Y' -d "2023-01-01 +$j days")"
	rezultate_cautare="$(cautare_avansata "$jsessionid" "$ice_window" "$ice_view" "$view_state" "05.01.2023" "07.01.2023"|get_urls)"
	download_docs "$rezultate_cautare"
done
