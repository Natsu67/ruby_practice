
module ReportFixtures
    def report_fixtures(conn, template)
      fixtures = conn.exec('SELECT * FROM fixtures ORDER BY name, room_id;')
  
      rooms = []
      conn.exec('SELECT * FROM rooms').each do |room|
        rooms << { id: room['id'], zone: room['zone_id'] }
      end
  
      zones = []
      conn.exec('SELECT * FROM zones').each do |zone|
        zones << { id: zone['id'], office: zone['office_id'] }
      end
  
      offices = []
      conn.exec('SELECT * FROM offices').each do |office|
        offices << { id: office['id'], name: office['title'], address: office['address'], lob: office['lob'], type: office['type'] }
      end
  
      fixtures_groups =  fill_fixtures_for_offices(fixtures, rooms, zones, conn)

      body = ''
      body += report_fixtures_body(fixtures_groups, offices)
  
      report = template.gsub('{TITLE}', 'Fixture Type Count Report').gsub('{BODY}', body)
  
      File.open('html/fixtures.html', 'w') { |file| file.write(report) }
    end
  
    def report_fixtures_body(fixtures_groups, offices)

      body = "<table class='table' style='font-size:18px; width: 60%; border-collapse: collapse; text-align:left;'>"
  
      fixtures_groups.each do |group_name, fixtures_group|
        group_body = ''
        group_count = 0
  
        fixtures_group.each do |office_id, fixture|
          fixture_office = offices.find { |office| office[:id] == office_id }
          office_count = fixture.length
  
          fixture_str = '<tr style="border-bottom: 1px solid #ddd;">'
          fixture_str += "<td>#{fixture_office[:name]}</td>"
          fixture_str += "<td>#{fixture_office[:type]}</td>"
          fixture_str += "<td>#{fixture_office[:address]}</td>"
          fixture_str += "<td>#{fixture_office[:lob]}</td>"
          fixture_str += "<td>#{office_count}</td>"
          fixture_str += '</tr>'
  
          group_body += fixture_str
          group_count += office_count
        end
  
        body += "<tr style='border-bottom: 1px solid black'><th colspan='5'><div style='display:flex; justify-content:space-between;'><h2>#{group_name}</h2><h2>#{group_count}</h2></div></th></tr>"
        body += "<tr><td><strong>Office</strong></td><td><strong>Type</strong></td><td><strong>Address</strong></td><td><strong>LOB</strong></td><td><strong>Sub Total Count</strong></td></tr>#{group_body}"
      end
  
      body += '</table>'
    end

    def fill_fixtures_for_offices(fixtures, rooms, zones, conn)
        fixtures_groups = {}
  
        fixtures.each do |fixture|
          fixture_type = conn.exec("SELECT (name) FROM fixtures_types WHERE id='#{fixture['type_id']}';").getvalue(0, 0)
          
          fixtures_groups[fixture_type] = {} if !fixtures_groups.key?(fixture_type)
    
          zone_id = rooms.find { |room| room[:id] == fixture['room_id'].to_s } [:zone]
          office_id = zones.find { |zone| zone[:id] == zone_id.to_s } [:office]
    
          fixtures_groups[fixture_type][office_id] = [] unless fixtures_groups[fixture_type].key?(office_id)
          fixtures_groups[fixture_type][office_id] << fixture
        end
        fixtures_groups
    end

  end
  