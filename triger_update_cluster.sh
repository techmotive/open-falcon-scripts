mysql -uroot -p123456 -e 'truncate table auto_aggr.endpoint_counter;insert into auto_aggr.endpoint_counter (select *  from graph.endpoint_counter);'
