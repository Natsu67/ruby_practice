require_relative 'db/drop_db'
require_relative 'db/create_db'
require_relative 'parse/parse'
require 'csv'

def migrate_data_to_db()
    conn = PG.connect(:dbname => 'task_1', :password => '', :port => 5432, :user => 'ntnshpig')
    csv_file = CSV.read("./data_for_task_1.csv", headers: true)
    drop_db(conn)
    create_db(conn)
    parse(csv_file, conn)
end


migrate_data_to_db()