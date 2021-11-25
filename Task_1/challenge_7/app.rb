require_relative 'db/migrate_data_to_db'
require './reports/office_installation'

class Start
    def initialize()
        conn = migrate_data_to_db()
    
        OfficeInstallation.new(conn)
    end
end

Start.new()