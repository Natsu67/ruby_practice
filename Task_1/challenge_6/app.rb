require_relative 'db/migrate_data_to_db'
require './reports/costs_report'

class Start
    def initialize()
        conn = migrate_data_to_db()
    
        CostsReport.new(conn)
    end
end

Start.new()