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

	def interest_question(nth)
		if nth == 0
			index = 1
		elsif nth == 4
			index = 9

			if !shimamura? && subname == "A"
				index = 8
			end
		else
			return nil
		end

		self.questionnaire[index]
	end

	def self_efficacy_question(nth)
		if nth == 0
			index = 2
		elsif nth == 4
			index = 10

			if !shimamura? && subname == "A"
				index = 9
			end
		else
			return nil
		end

		self.questionnaire[index]
	end

	def motivation_question(nth)
		if nth == 0
			index = 3
		elsif nth == 4
			index = 8

			if !shimamura? && subname == "A"
				index = 10
			end
		else
			return nil
		end

		self.questionnaire[index]
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
end
