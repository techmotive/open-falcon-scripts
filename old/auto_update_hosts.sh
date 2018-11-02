#!/bin/bash
USER="root"
PASS="123456"

#update from `graph`.`endpoint` to falcon_portal.host
SQL="select endpoint from graph.endpoint where endpoint like \"%mesos-agent%\" or endpoint=\"auto_aggregator\"" # for mesos docker env
endpoints=`mysql -N -u$USER -p$PASS -e "$SQL"`

for ep in $endpoints
do
	SQL="select hostname from falcon_portal.host where hostname=\"$ep\";"
        hn=`mysql -N -u$USER -p$PASS -e "$SQL"`
        if [ "$hn" == "$ep" ]; then
                echo "$ep already exists falcon_portal.host, ignore"
                continue
        fi

        SQL="use falcon_portal;insert into falcon_portal.host(hostname) values(\"$ep\")"
        exist=`mysql -N -u$USER -p$PASS -e "$SQL"`
done

SQL="select id from falcon_portal.host where hostname like \"%shopeemobile-com%\" or hostname=\"auto_aggregator\";" # for mesos docker env
host_ids=`mysql -N -u$USER -p$PASS -e "$SQL"`

echo $host_ids
for id in $host_ids
do
	SQL="select host_id from falcon_portal.grp_host where grp_id=1 and  host_id = $id;"
	exist=`mysql -N -u$USER -p$PASS -e "$SQL"`
	if [ "$id" == "$exist" ]; then
		echo "$id already exists, ignore"
		continue
	fi

	echo "====$id into falcon_portal.grp_host==="
	SQL="use falcon_portal;insert into falcon_portal.grp_host(grp_id,host_id) values(1,$id)"
	exist=`mysql -N -u$USER -p$PASS -e "$SQL"`
done
