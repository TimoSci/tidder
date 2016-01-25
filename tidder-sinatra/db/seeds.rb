
graph = {
	0=>[6,7,8,9,11,12],
	1=>[2,3,4,5],
	2=>[3,4,1],
	3=>[1,2,6,4,5],
	4=>[5,1,2,3,6],
	5=>[1,2,4],
	6=>[4,3,0],
	7=>[6,8,10,12,0],
	8=>[9,1,0,7],
	9=>[10,1,0,8],
	10=>[11,7,9],
	11=>[12,0,9,10],
	12=>[0,7,9,11]
}



user_names = %w(Alice Bob Charlie Dartha Emma Fred Gabriel Harry Ian Julia Kat Leo Maria)

user_list = graph.map do |k,friends|
  [
    k+1,
    { name: user_names[k], friend_ids: friends.map{|n| n+1} }
  ]
end.to_h


user_list.values.each do |user_hash|
	binding.pry
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


# Topic hierarchy

Topic.create(name:"ROOT")

t1 = Topic.new(name:"science",user_id:1)
t1.save
t11 = Topic.new(name:"physics",user_id:2)
t11.parent = t1
t11.save
t12 = Topic.new(name:"biology",user_id:1)
t12.parent = t1
t12.save
t13 = Topic.new(name:"psychology",user_id:3)
t13.parent = t1
t13.save
t111 = Topic.new(name:"astrophysics",user_id:4)
t111.parent = t11
t111.save
t2 = Topic.new(name:"news",user_id:5)
t2.save
t21 = Topic.new(name:"world",user_id:2)
t21.parent = t2
t21.save
t22 = Topic.new(name:"tech",user_id:2)
t22.parent = t2
t22.save
t221 = Topic.new(name:"gaming",user_id:2)
t221.parent = t22
t221.save

Post.create(topic:t1,user_id:1,title:"Brain circuit involved in antidepressant effect of ketamine identified")
Post.create(topic:t1,user_id:2,title:"Researchers find magnesium intake may be beneficial in preventing pancreatic cancer.")
Post.create(topic:t1,user_id:3,title:"Marijuana derivative reduces seizures in people with treatment-resistant epilepsy")
Post.create(topic:t11,user_id:1,title:"All about Earth’s Gravity")
Post.create(topic:t11,user_id:4,title:"Heat radiates 10,000 times faster at the nanoscale")
Post.create(topic:t11,user_id:2,title:"Witten introduces M-theory in 1995")
Post.create(topic:t13,user_id:2,title:"Brain circuit involved in antidepressant effect of ketamine identified")
Post.create(topic:t13,user_id:4,title:"A Point of View: Is there any such thing as a wise person?")
Post.create(topic:t13,user_id:1,title:"Religion’s evolutionary landscape: Counterintuition, commitment, compassion, communion")
Post.create(topic:t111,user_id:2,title:"LISA Pathfinder will pave the way for us to ‘see’ black holes for the first time")
Post.create(topic:t111,user_id:4,title:"Giant galaxies die from the inside out: Star formation shuts down in the centers of elliptical galaxies first.")
Post.create(topic:t111,user_id:5,title:"Is it possible for a moon to orbit a planet more slowly than the planet orbits the system center?")


p = Post.create(topic:t11,user_id:1,title:"String Theory Explained")
c1 = p.comments.create(text:"'Almost infinite' ... so not at all infinite.",user_id:2)
c2 = p.comments.create(text:"Transfinite",user_id:2,parent:c1)
c3 = p.comments.create(text:"it's like 'a little pregnant'",user_id:3,parent:c1)
c4 = p.comments.create(text:"'Googol' in this context",user_id:4,parent:c1)
c5 = p.comments.create(text:"Eh; in his preprint he spelled it that way. Google was an accidental misspelling of googol",user_id:5,parent:c4)
c6 = p.comments.create(text:"You're dumb",user_id:6,parent:c5)
c6 = p.comments.create(text:"No YOU are dumb sir",user_id:5,parent:c6)
c7 = p.comments.create(text:"Pffff...",user_id:6,parent:c6)
