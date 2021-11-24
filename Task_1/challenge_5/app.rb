require_relative 'db/migrate_data_to_db'
require './reports/fixtures_report'

class Start
    def initialize()
        conn = migrate_data_to_db()
    
        FixturesReport.new(conn)
    end
end

Start.new()