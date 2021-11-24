require_relative 'db/migrate_data_to_db'
require './reports/states_report'

class Start
    def initialize()
        conn = migrate_data_to_db()
    
        StatesReport.new(conn)
    end
end

Start.new()