$users = {
  father: User.find_by(user_name: "父"),
  mother: User.find_by(user_name: "母"),
  daughter: User.find_by(user_name: "娘"),
  son: User.find_by(user_name: "息子"),
  shimamura: [],
  system: [],
}

[8, 11, 14, 15, 18].each do |id|
  $users[:shimamura] << User.find(id)
end

[9, 10, 13, 16, 17].each do |id|
  $users[:system] << User.find(id)
end
