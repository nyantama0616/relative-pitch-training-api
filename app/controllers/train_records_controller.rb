require 'json'

class TrainRecordsController < ApplicationController
	def create
		unless user = User.find(params[:user_id])
			render json: {message: "User not found"}, status: :not_found
		end

		dumped_questions = TrainRecord.dumped_questions(create_params[:questions])
		record = TrainRecord.new(user: user, questions: dumped_questions)

		if record.save
			render json: {recordId: record.id}, status: :created
		else
			render json: {message: "Failed..."}, status: :internal_server_error
		end
	end

	def interval_rates
		res = TrainRecords::IntervalRates.call(params[:id])
		render json: {intervalRates: res}
	end

	private

	def save_json(index, json)
		File.open("./record#{index}.json", "a") do |file|
				JSON.dump(json, file)
		end
	end

	def create_params
		{
			user_id: params[:user_id],
			questions: params[:questions]
		}
	end
end
