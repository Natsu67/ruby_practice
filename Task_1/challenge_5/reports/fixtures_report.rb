
# Generates fixtures reports
class FixturesReport

    def initialize(conn)
        template = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>{TITLE}</title></head>'
        template += '<body style="padding: 1em"><div style="display:flex"><div style="width: 200px; height: 100px; border: 1px solid black; display: flex; align-items:center; justify-content:center;">LOGO</div><div style="width:40%"><h1 align="center">{TITLE}</h1></div></div>'
        template += '<div>{BODY}</div></body></html>'
    
        report_fixtures(conn, template)
    end

    def report_fixtures(conn, template)
      fixtures = conn.exec('
        SELECT DISTINCT fixtures_types.name AS "fixtures_type", offices.id, COUNT(offices.id) as "total", offices.*
        FROM fixtures 
        JOIN fixtures_types on fixtures.type_id = fixtures_types.id 
        JOIN rooms on fixtures.room_id = rooms.id 
        JOIN zones on rooms.zone_id = zones.id 
        JOIN offices on zones.office_id = offices.id GROUP BY fixtures_type, offices.id
        ORDER BY fixtures_types.name, offices.id').entries()
  
      fixtures_groups =  fill_fixtures_by_types(fixtures)

      body = ''
      body += report_fixtures_body(fixtures_groups)
  
      report = template.gsub('{TITLE}', 'Fixture Type Count Report').gsub('{BODY}', body)
  
      File.open('html/fixtures.html', 'w') { |file| file.write(report) }
    end
  
    def report_fixtures_body(fixtures_groups)

      body = "<table class='table' style='font-size:18px; width: 60%; border-collapse: collapse; text-align:left;'>"
  
      fixtures_groups.each do |group|
        group_count = 0;
        group_body = '';

        group.slice(1).each do |office|
          fixture_str = '<tr style="border-bottom: 1px solid #ddd;">'
          fixture_str += "<td>#{office["title"]}</td>"
          fixture_str += "<td>#{office["type"]}</td>"
          fixture_str += "<td>#{office["address"]}</td>"
          fixture_str += "<td>#{office["lob"]}</td>"
          fixture_str += "<td>#{office["total"]}</td>"
          fixture_str += "</tr>"
  
          group_body += fixture_str
          group_count += office["total"].to_i
        end
  
        body += "<tr style='border-bottom: 1px solid black'><th colspan='5'><div style='display:flex; justify-content:space-between;'><h2>#{group[0]}</h2><h2>#{group_count}</h2></div></th></tr>"
        body += "<tr><td><strong>Office</strong></td><td><strong>Type</strong></td><td><strong>Address</strong></td><td><strong>LOB</strong></td><td><strong>Sub Total Count</strong></td></tr>#{group_body}"
      end
  
      body += '</table>'
    end

    def fill_fixtures_by_types(fixtures)
        fixtures_groups = {}
  
        fixtures.each do |fixture|
          fixtures_groups[fixture["fixtures_type"]] = [] if !fixtures_groups.key?(fixture["fixtures_type"])
    
          fixtures_groups[fixture["fixtures_type"]].append(fixture.slice("title", "address", "type", "lob", "total"))
        end
        fixtures_groups
    end

  end
  