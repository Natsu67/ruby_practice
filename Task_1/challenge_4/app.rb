require_relative 'db/migrate_data_to_db'
require './reports/reports'

include Reports
conn = migrate_data_to_db()
reports(conn)
