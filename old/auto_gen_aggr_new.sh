#!/bin/bash

CREATOR="auto_aggregator"
ONE_ENDPOINT="auto_aggregator"
USER="root"
PASS="123456"


SQL='select count(*) from falcon_portal.host where hostname="auto_aggregator";'
count=`mysql -N -u$USER -p$PASS -e "$SQL"`
if [ "$count" == "0" ] ;then
	SQL='use falcon_portal; replace into host(hostname) values("auto_aggregator");'
	count=`mysql -N -u$USER -p$PASS -e "$SQL"`
fi

SQL='select count(*)  from graph.endpoint_counter where counter like "%reportType=need_aggr%";'
cnt=`mysql -N -u$USER -p$PASS -e "$SQL"`

#echo $cnt "to write"
for ((i=0;i<$cnt;i++));do
SQL='select counter,step,type from graph.endpoint_counter where counter like "%reportType=need_aggr%" ' 
SQL=$SQL" limit $i,1"
#echo $SQL
result=`mysql -N -u$USER -p$PASS -e "$SQL" `
metric_name=`echo $result|awk '{print $1}'`
metric_step=`echo $result|awk '{print $2}'`
metric_type=`echo $result|awk '{print $3}'`

	#echo $i ": metric_name: " $metric_name "metric_type:" $metric_type " step: " $metric_step

	[[ ! $aggr_tags =~ "metricType=counter" ]] && denominator="\$\#" ||denominator="1"
	numerator="\$($metric_name)"
	aggr_metric=${metric_name%/*}
	aggr_tags=${metric_name##*/}
	aggr_tags=${aggr_tags/"reportType=need_aggr,"/""}
	aggr_tags=${aggr_tags/",valueType=count"/""}
	aggr_tags=${aggr_tags/"metricType=counter,"/""}
	#echo " metric_name: " $metric_name "metric_type:" $metric_type " denominator: " $denominator
	SQL="select count(*) from falcon_portal.cluster where numerator=\"$numerator\""
	count=`mysql -N -u$USER -p$PASS -e "$SQL"`
	#echo "cnt:" $count "lines"
	if [ "$count" == "0" ] ;then
		endpoint=$ONE_ENDPOINT
		metric=$aggr_metric
		tags=$aggr_tags
		ds_type="GAUGE"
		creator=$CREATOR
		SQL="use falcon_portal;insert into falcon_portal.cluster(grp_id,numerator,denominator,endpoint,metric,tags,ds_type,step,creator) values(1,
\"$numerator\",\"$denominator\",\"$endpoint\",\"$metric\",\"$tags\",\"$ds_type\",\"$metric_step\",\"$creator\")"
	 	#echo $SQL
		count=`mysql -N -u$USER -p$PASS -e "$SQL"`
	 	#echo "insert result:" $count
	fi
	
done

