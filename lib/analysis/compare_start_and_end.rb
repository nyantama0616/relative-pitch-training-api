require_relative './users.rb'
require_relative './datum.rb'
require_relative './util.rb'

shimamuras = $users[:shimamura].filter { |user| user.train_records.length == 6 }
systems = $users[:system].filter { |user| user.train_records.length == 11 }

shimamura_medians = shimamuras.map do |user|
  before = user.test_before.means[:reaction_time].values
  after = user.nth_test(4).means[:reaction_time].values
  ratio = 12.times.to_a.map { |i| (after[i] - before[i]) / before[i] }
  # [user.id, user.user_name, Util.median(ratio)]
  [user.id, Util.median(ratio)]
end
shimamura_mean = shimamura_medians.map(&:last).sum / shimamura_medians.length
shimamura_median = Util.median(shimamura_medians.map(&:last))

system_medians = systems.map do |user|
  before = user.test_before.means[:reaction_time].values
  after = user.nth_test(4).means[:reaction_time].values
  ratio = 12.times.to_a.map { |i| (after[i] - before[i]) / before[i] }
  # [user.id, user.user_name, Util.median(ratio)]
  [user.id, Util.median(ratio)]
end
system_means = system_medians.map(&:last).sum / system_medians.length
system_median = Util.median(system_medians.map(&:last))

puts "===島村群==="
puts "平均反応時間の変化率"
puts ""
puts "[user_id, 平均反応時間の変化率]"
shimamura_medians.each do |x|
  p x
end
puts ""
puts "平均: #{shimamura_mean}"
puts "中央値: #{shimamura_median}"

puts "\n\n"

puts "===システム群==="
puts "平均反応時間の変化率"
puts ""
puts "[user_id, 平均反応時間の変化率]"
system_medians.each do |x|
  p x
end
puts ""
puts "平均: #{system_means}"
puts "中央値: #{system_median}"
