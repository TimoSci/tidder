
graph = {
	0=>[6,7,8,9,11,12],
	1=>[2,3,4,5],
	2=>[3,4,5,1],
	3=>[1,2,6,4,5],
	4=>[5,1,2,3,6],
	5=>[1,2,3,4],
	6=>[4,3,7,0],
	7=>[6,8,10,12,0],
	8=>[9,11,0,7],
	9=>[10,11,12,0,8],
	10=>[11,7,9],
	11=>[12,0,8,9,10],
	12=>[0,7,9,11]
}

user_names = %w(Alice Bob Charlie Dartha Emma Fred Gabriel Harry Ian Julia Kat Ludwig Maria)

user_list = graph.map do |k,friends|
  [
    k+1,
    { name: user_names[k], friend_ids: friends.map{|n| n+1} }
  ]
end.to_h


user_list.values.each do |user_hash|
  User.create(name: user_hash[:name])
end

#TODO build social network below independent of database ids
User.all.each do |user|
  user_hash = user_list[user.id.to_i]
  if user_hash
    user.update(user_hash)
    user.save
  end
end
