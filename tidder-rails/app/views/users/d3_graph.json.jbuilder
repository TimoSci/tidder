json.vertices @dg.vertices do |user|
  json.name user.name
  json.group 1
end

json.edges @dg.edges do |edge|
  json.source @position_ids.find_index(edge.source.id)
  json.target @position_ids.find_index(edge.target.id)
  json.value 1
end