for i in `find /home/ld-sgdev/workspace/open-falcon -name "*.log*" -size +5000M `;
do 
	echo truncate $i;
	tail -n 1000 $i > /tmp/backup-of-$(basename $i);
	echo "truncate to /tmp/backup-of-$(basename $i)";
	mv /tmp/backup-of-$(basename $i) $i;
	echo "truncate ok";
	sleep 1
	service=`basename $i`
	service=${service%%.log*}
	echo "restart service:", $service
	cd /home/ld-sgdev/workspace/open-falcon/
	./open-falcon restart $service
 done
echo "done"
