
# Generates state reports
class StatesReport

  def initialize(conn)
    template = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>{TITLE}</title></head>'
    template += '<body style="padding: 1em"><div style="display:flex"><div style="width: 200px; height: 100px; border: 1px solid black; display: flex; align-items:center; justify-content:center;">LOGO</div><div style="width:40%"><h1 align="center">{TITLE}</h1></div></div>'
    template += '<div>{BODY}</div></body></html>'

    report_states(conn, template)
  end

  def report_states(conn, template)
    offices = conn.exec('SELECT * FROM offices ORDER BY state;')

    body = ''
    state = ''

    offices.each do |office|
      if state != office['state']
        body += '</tbody></table>' if state != ''

        state = office['state']

        body += "<h2 style='width:60%; border-bottom:2px solid black;'>#{state}</h2><table class='table' style='font-size:18px; width: 60%; border-collapse: collapse; text-align:left;'><thead><tr><th>Office</th><th>Type</th><th>Address</th><th>LOB</th></tr></thead><tbody>"
      end

      office_str = '<tr style="border-bottom: 1px solid #ddd;">'
      office_str += "<td>#{office['title']}</td>"
      office_str += "<td>#{office['type']}</td>"
      office_str += "<td>#{office['address']}</td>"
      office_str += "<td>#{office['lob']}</td>"
      office_str += '</tr>'

      body += office_str
    end

    body += '</tbody></table>'

    report = template.gsub('{TITLE}', 'States Report').gsub('{BODY}', body)

    File.open('html/states.html', 'w') { |file| file.write(report) }
  end

end
