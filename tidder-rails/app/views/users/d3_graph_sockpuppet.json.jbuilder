json.vertices @dg.vertices do |user|
  json.name user.name
  json.karma user.global_karma
  if user == @user
    json.local_karma 0
    json.group 2
  else
    json.local_karma user.relative_karma(@user)
    json.group 1
  end
end

json.edges @dg.edges do |edge|
  json.source @position_ids.find_index(edge.source.id)
  json.target @position_ids.find_index(edge.target.id)
  json.value 1
end