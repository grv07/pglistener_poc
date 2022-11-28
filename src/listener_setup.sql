-- Add a table update notification function
CREATE OR REPLACE FUNCTION table_update_notify() RETURNS trigger AS $$
DECLARE
  id int;
  key varchar;
  value varchar;
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    id = NEW.id;
    key = NEW.key;
    value = NEW.val;
  ELSE
    id = OLD.id;
    key = OLD.key;
    value = OLD.val;
  END IF;
  PERFORM pg_notify('table_update', json_build_object('table', TG_TABLE_NAME, 'id', id, 'key', key, 'value', value, 'action_type', TG_OP)::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add UPDATE row trigger
DROP TRIGGER users_notify_update ON my_table;
CREATE TRIGGER users_notify_update AFTER UPDATE ON my_table FOR EACH ROW EXECUTE PROCEDURE table_update_notify();

-- Add INSERT row trigger
DROP TRIGGER users_notify_insert ON my_table;
CREATE TRIGGER users_notify_insert AFTER INSERT ON my_table FOR EACH ROW EXECUTE PROCEDURE table_update_notify();

-- Add DELETE row trigger
DROP TRIGGER users_notify_delete ON my_table;
CREATE TRIGGER users_notify_delete AFTER DELETE ON my_table FOR EACH ROW EXECUTE PROCEDURE table_update_notify();
