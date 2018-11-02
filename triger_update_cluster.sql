use graph;

DELIMITER $$

CREATE TRIGGER trigger_update_cluster

AFTER INSERT

ON graph.endpoint_counter FOR EACH ROW

BEGIN

        insert into auto_aggr.endpoint_counter (select *  from graph.endpoint_counter  where id = new.id and counter like "%need_aggr%");

END

$$

DELIMITER ;
