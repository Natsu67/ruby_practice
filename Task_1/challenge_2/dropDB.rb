require 'pg'

conn = PG.connect(:dbname => 'task_1', :password => '', :port => 5432, :user => 'ntnshpig')

conn.exec(
    '
        DROP TABLE IF EXISTS offices, zones, rooms, fixtures, marketing_materials cascade;
        DROP TYPE IF EXISTS material_type, office_types, fixture_types, office_lob, office_type cascade;
    '
)