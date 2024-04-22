#!/bin/bash

psql_conn(){
	psql 'host=opendataexplorer.aware.ro port=11028 dbname=opendataexplorer user=some-db-user password=some-db-password'
}

insert() {
	local data="$(cat)"
	local nume="$(jq -r .nume <<< "$data")"
	local cui="$(jq -r .cui <<< "$data")"
	local caen="$(jq -r .caen <<< "$data")"
	local desc="$(jq -r .descriere <<< "$data")"
	psql_conn <<< 'insert into firme(nume, cui, caen, descriere)
		'"values('$nume', '$cui', '$caen', '$descriere')"
}

while read firma; do
	cui=$(awk '{print $1}'<<<"$firma")
	an=$(awk '{print $2}'<<<"$firma")
	re='^[0-9][0-9]*$'
	if ! grep -q "$re" <<< "$an" || [ $an -gt 2022 ]; then
		echo "skipping $an"
		continue
	fi
	echo "Adding $deni"
	curl "https://webservicesp.anaf.ro/bilant?an=2022&cui=$cui"| jq '{
		"nume":.deni,
		"cui":.cui,
		"caen":.caen,
		"descriere":.den_caen
	}'|insert
	sleep 1
done < sample