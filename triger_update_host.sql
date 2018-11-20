use graph;

DELIMITER $$

CREATE TRIGGER trigger_update_host

AFTER INSERT

ON graph.endpoint FOR EACH ROW

BEGIN

        insert into auto_aggr.endpoint (select * from graph.endpoint where endpoint REGEXP '[a-zA-Z]*-[a-zA-Z_]*-[a-zA-Z]*-[a-zA-Z]*-[0-9]{2}');

END

$$

DELIMITER ;
