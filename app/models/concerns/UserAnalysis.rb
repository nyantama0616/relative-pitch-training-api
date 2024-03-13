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
	end

	def nth_questionnaire(name, nth)
		n = 0
		questionnaire.each do |q, i|
			if q.name == name
				return q if n == nth
				n += 1
			end
		end

		nil
	end

	def test_count
		5.times do |i|
			if nth_test(i).nil?
				return i
			end
		end
	end

	def train_count
		5.times do |i|
			if nth_train(i).nil?
				return i
			end
		end
	end

	def prev_train_reaction_time_mean
		nth = train_count - 1
		train = nth_train(nth)
		train.means[:reaction_time].values.sum / 12.0
	end

	# 平均反応時間の変化率
	def reaction_ratio
		reaction_times0 = test_before.means[:reaction_time].values
		reaction_times4 = nth_test(4).means[:reaction_time].values

		median0 = Util.median(reaction_times0)
		median1 = Util.median(reaction_times4)

		(median1 - median0) / median0
	end

	# 総ミス回数の変化率
	def miss_ratio
		miss0 = test_before.total_miss_count
		miss4 = nth_test(4).total_miss_count

		(miss4 - miss0) / miss0.to_f
	end

	# トレーニング時間比
	def motiv_ratio
		a = 5.times.map do |i|
			expected = nth_questionnaire("motivation", i).expected_train_time * 60.0
			actual = shimamura? ? 10 * 60.0 : nth_train(i).train_time / 1000.0
			expected / actual.to_f
		end
		Util.median(a)
	end

	def has_music_experience?
		q = nth_questionnaire("attribute", 0)
		q.music_experience != "半年未満"
	end
end
