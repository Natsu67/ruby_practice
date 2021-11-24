require_relative 'drop_db'
require_relative 'create_db'
require_relative '../parse/parse'
require 'csv'

def migrate_data_to_db()
    conn = PG.connect(:dbname => 'task_1', :password => '', :port => 5432, :user => 'ntnshpig')
    csv_file = CSV.read("../data_for_task_1.csv", headers: true)
    drop_db(conn)
    create_db(conn)
    parse(csv_file, conn)
    conn
end
