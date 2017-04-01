require 'csv'

csv = CSV.parse(File.open('goodreads_library_export.csv').read)
statements = csv.drop(1).map { |row| Hash[csv.first.zip(row)] }.map.with_index do |row, index|
%(MATCH (b#{index}:Book { title: "#{row['Title']}" })\n
MATCH (p#{index}:Person { name: "#{row['Author']}" })\n
CREATE (b#{index})-[:AUTHOR]->(p#{index})\n
)
end.join
File.open('transformed', 'w') { |f| f.write statements }