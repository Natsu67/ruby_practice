require 'pg'

conn = PG.connect(:dbname => 'task_1', :password => '', :port => 5432, :user => 'ntnshpig')

conn.exec(
    '
        DROP TABLE IF EXISTS offices, zones, rooms, fixtures, fixtures_types, marketing_materials, marketing_materials_types cascade;
        DROP TYPE IF EXISTS office_types cascade;
    '
)