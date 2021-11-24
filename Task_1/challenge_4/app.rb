# frozen_string_literal: true

require_relative 'db/migrate_data_to_db'
require './reports/reports'

class Start
    include Reports

    def initialize()
        conn = migrate_data_to_db()
    
        reports(conn)
    end
end

start = Start.new()