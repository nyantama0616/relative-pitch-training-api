require 'matrix'

module UserAnalysis
	def test_before
		train_records[0]
	end

  def nth_test(n)
		if shimamura?
      train_records[n + 1]
		else
      train_records[2*(n + 1)]
		end
	end

	def nth_train(n)
		if shimamura?
      nil
		else
      train_records[2*n + 1]
		end
	end

	def experiment_num
		if shimamura?
			train_records.length - 1
		else
			(train_records.length - 1) / 2
		end
	end

	# 各音程の平均反応時間の変化率の推移
	def reaction_time_change_ratio
		n = experiment_num
		m = Matrix.build(n - 1, 12) { 0 }
		
		(n - 1).times do |i|
			bef = nth_test(i).means[:reaction_time]
			aft = nth_test(i + 1).means[:reaction_time]

			12.times do |j|
				note = NOTES[j]
				m[i, j] = ((aft[note] - bef[note]) / bef[note]).round(3)
			end
		end
		
		m
	end
end
