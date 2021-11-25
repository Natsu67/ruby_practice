

require 'quickchart'

# Generates state reports
class OfficeInstallation

  def initialize(conn)
    template = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>{TITLE}</title></head>'
    template += '<body style="padding: 1em"><div style="display:flex"><div style="width: 200px; height: 100px; border: 1px solid black; display: flex; align-items:center; justify-content:center;">LOGO</div><div style="width:40%"><h1 align="center">{TITLE}</h1><h4 align="center">{SUBTITLE}</h4></div></div>'
    template += '<div>{BODY}</div></body></html>'

    installation(conn, template)
  end

  def installation(conn, template)
    installation = conn.exec('
      SELECT offices.*, zones.name AS "zone_name", 
      rooms.name AS "room_name", rooms.area AS "room_area", rooms.max_people AS "room_max_people",
      fixtures.name AS "fixtures_name",
      fixtures_types.name AS "fixtures_type", 
      marketing_materials.name AS "marketing_materials_name", 
      marketing_materials.type AS "marketing_materials_type"
      FROM offices 
      JOIN zones on offices.id = zones.office_id
      JOIN rooms on rooms.zone_id = zones.id 
      JOIN fixtures on fixtures.room_id = rooms.id 
      JOIN fixtures_types on fixtures.type_id = fixtures_types.id 
      JOIN marketing_materials on marketing_materials.fixture_id = fixtures.id
      ORDER BY offices.title').entries()

    installation_group = get_installation_group(installation)
    installation_group.each do |office|
      body, area, max_people = installation_body(office)

      report = template.gsub('{TITLE}', office[1]["office_data"]["title"])
                        .gsub('{SUBTITLE}', "#{office[1]["office_data"]["state"]}, #{office[1]["office_data"]["address"]}, #{office[1]["office_data"]["phone"]}, #{office[1]["office_data"]["type"]}<br />Area: #{office[1]['area']}<br />Max people: #{office[1]['max_people']}")
                        .gsub('{BODY}',     body)

      File.open("html/#{office[1]['office_data']['title']}.html", 'w') { |file| file.write(report) }
    end
  end

  def installation_body(office)
    area = 0
    max_people = 0
    body = ""

    body = "<table class='table' style='font-size:18px; min-width: 40%; border-collapse: collapse; text-align:left;'>"

    office[1]["zones"].each do |zone|
      group_str = "<tr><th colspan='4'><h2>Zone: #{zone.first}</h2></th></tr>"

      zone[1].each do |room|
        group_str += "<tr><th colspan='4'><h4 align='left'>Room: #{room.first}</h4></th></tr><tr style='border-bottom: 1px solid #ddd;'><th>Material</th><th>Material Type</th><th>Fixture</th><th>Fixture Type</th></tr>"

        room[1].each do |material|
          group_str += '<tr style="border-bottom: 1px solid #ddd;">'
          group_str += "<td>#{material['marketing_materials_name']}</td>"
          group_str += "<td>#{material['marketing_materials_type']}</td>"
          group_str += "<td>#{material['fixtures_name']}</td>"
          group_str += "<td>#{material['fixtures_type']}</td>"
          group_str += '</tr>'
        end
      end

      body += group_str
    end

    body += '</table>'

    [body, area, max_people]
  end

  def get_installation_group(installation)
    installation_group = {}

    installation.each do |office|
      unless(installation_group.key?(office["title"]))
        installation_group[office["title"]] = {}
        installation_group[office["title"]]["office_data"] = office.slice("title", "city", "address", "state", "phone", "lob", "type")
        installation_group[office["title"]]["zones"] = {}
        installation_group[office["title"]]["area"] = 0
        installation_group[office["title"]]["max_people"] = 0
      end

      unless(installation_group[office["title"]]["zones"].key?(office["zone_name"]))
        installation_group[office["title"]]["zones"][office["zone_name"]] = {}
      end

      unless(installation_group[office["title"]]["zones"][office["zone_name"]].key?(office["room_name"]))
        installation_group[office["title"]]["zones"][office["zone_name"]][office["room_name"]] = []
        installation_group[office["title"]]["area"] +=  office["room_area"].to_i
        installation_group[office["title"]]["max_people"] +=  office["room_max_people"].to_i
      end

      installation_group[office["title"]]["zones"][office["zone_name"]][office["room_name"]].append(office.slice("fixtures_name", "fixtures_type", "marketing_materials_name", "marketing_materials_type"))
    end
    installation_group
  end
end
