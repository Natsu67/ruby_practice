require 'pg'

def drop_db(conn) 
    conn.exec(
        '
            DROP TABLE IF EXISTS offices, zones, rooms, fixtures, fixtures_types, marketing_materials cascade;
            DROP TYPE IF EXISTS office_types cascade;
        '
    )
end