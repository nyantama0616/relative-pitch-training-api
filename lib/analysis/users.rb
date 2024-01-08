$users = {
  father: User.find_by(user_name: "父"),
  mother: User.find_by(user_name: "母"),
  daughter: User.find_by(user_name: "娘"),
  son: User.find_by(user_name: "息子")
}

# users[:mother].questionnaire.each do |q|
#   x = {
#     id: q.id,
#     name: q.name,
#     file: q.data_file_path,
#     data: q.created_at
#   }

#   p x
# end
