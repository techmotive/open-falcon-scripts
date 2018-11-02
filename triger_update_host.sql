use graph;

DELIMITER $$

CREATE TRIGGER trigger_update_host

AFTER INSERT

ON graph.endpoint FOR EACH ROW

BEGIN

        insert into auto_aggr.endpoint (select *  from graph.endpoint where id = new.id and endpoint like "%server_%" and endpoint not like "%error-endpoint%");

END

$$

DELIMITER ;
