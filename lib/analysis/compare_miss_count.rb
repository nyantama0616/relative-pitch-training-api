require_relative './users.rb'
require_relative './datum.rb'
require_relative './util.rb'

shimamuras = $users[:shimamura].filter { |user| user.train_records.length == 6 }
systems = $users[:system].filter { |user| user.train_records.length == 11 }

shimamura_ratio = shimamuras.map do |user|
  bef = user.test_before.total_miss_count
  aft = user.nth_test(4).total_miss_count
  ((aft - bef) / bef.to_f).round(3)
end

system_ratio = systems.map do |user|
  bef = user.test_before.total_miss_count
  aft = user.nth_test(4).total_miss_count
  ((aft - bef) / bef.to_f).round(3)
end

puts "===島村群==="
p shimamura_ratio
puts "平均値: #{shimamura_ratio.sum / shimamura_ratio.length}"
puts "中央値: #{Util.median(shimamura_ratio)}"
puts ""

puts "===システム群==="
p system_ratio
puts "平均値: #{system_ratio.sum / system_ratio.length}"
puts "中央値: #{Util.median(system_ratio)}"
