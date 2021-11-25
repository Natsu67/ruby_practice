

require 'quickchart'

# Generates state reports
class CostsReport

  def initialize(conn)
    template = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>{TITLE}</title></head>'
    template += '<body style="padding: 1em"><div style="display:flex"><div style="width: 200px; height: 100px; border: 1px solid black; display: flex; align-items:center; justify-content:center;">LOGO</div><div style="width:40%"><h1 align="center">{TITLE}</h1></div></div>'
    template += '<div>{BODY}</div></body></html>'

    report_costs(conn, template)
  end

  def report_costs(conn, template)
    materials = conn.exec('
      SELECT DISTINCT offices.title, marketing_materials.type, SUM(marketing_materials.cost) 
      FROM marketing_materials 
      JOIN fixtures on marketing_materials.fixture_id = fixtures.id
      JOIN rooms on fixtures.room_id = rooms.id 
      JOIN zones on rooms.zone_id = zones.id 
      JOIN offices on zones.office_id = offices.id GROUP BY marketing_materials.type, offices.title
      ORDER BY offices.title, marketing_materials.type').entries()

    materials_data = sort_materials_by_offices(materials)

    body = ''
    body += report_costs_body(materials_data)

    report = template.gsub('{TITLE}', 'Marketing Materials Costs Report').gsub('{BODY}', body)

    File.open('html/costs.html', 'w') { |file| file.write(report) }
  end

  def report_costs_body(materials_data)
    body = "<table class='table' style='font-size:18px; width: 60%; border-collapse: collapse; text-align:left;'>"

    materials_data[0].each do |office|
      group_body = ''
      group_cost = 0

      office[1].each do |material|
        fixture_str = '<tr style="border-bottom: 1px solid #ddd;">'
        fixture_str += "<td>#{material["type"]}</td>"
        fixture_str += "<td>#{material["sum"]}</td>"
        fixture_str += '</tr>'

        group_body += fixture_str
        group_cost += material["sum"].to_i
      end

      body += "<tr style='border-bottom: 1px solid black'><th colspan='2'><div div style='display:flex; justify-content:space-between;'><h2>#{office.first}</h2><h2>#{group_cost}</h2></div></th></tr>"
      body += "<tr><td><strong>Material Type</strong></td><td><strong>Sub Total Costs</strong></td></tr>#{group_body}"
    end

    body += '</table>'

    qc = get_repot_costs_chart(materials_data[1])

    body += "<h1 class='mt-5 text-center'>Marketing Material Costs By Type</h1><p class='text-center'><img src='#{qc.get_url}' /></p>"
  end

  def sort_materials_by_offices(materials)
    material_groups = {}
    material_types = {}

    materials.each do |material|
      material_groups[material["title"]] = [] unless material_groups.key?(material["title"])
      material_types[material["type"]] = 0 unless material_types.key?(material["type"])

      material_types[material["type"]] += material["sum"].to_i
      material_groups[material["title"]].push(material.slice("type", "sum"))
    end
    [material_groups, material_types]
  end

  def get_repot_costs_chart(materials_data)
    QuickChart.new(
      {
        type: 'doughnut',
        data: {
          labels: materials_data.keys,
          datasets: [
            data: materials_data.values
          ]
        }
      },
      width: 600,
      height: 300
    )
  end
end
