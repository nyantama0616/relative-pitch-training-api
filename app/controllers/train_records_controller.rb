require 'json'

class TrainRecordsController < ApplicationController
	def show
		unless record = params[:id].to_i < 0 ? TrainRecord.last : TrainRecord.find(params[:id])
			render json: {message: "Record not found"}, status: :not_found
		end

		render json: {record: record.info}
	end

	def create
		unless user = User.find(create_params[:user_id])
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

	def means
		unless train = TrainRecord.find(params[:id])
			render json: {message: "Record not found"}, status: :not_found
		end

		json = {
			reactionTime: train.means[:reaction_time].values,
			missCount: train.means[:miss_count].values,
		}

		render json: {means: json}
	end

	private

	def save_json(index, json)
		File.open("./record#{index}.json", "a") do |file|
				JSON.dump(json, file)
		end
	end

	def create_params
		{
			user_id: params[:userId],
			questions: params[:questions]
		}
	end
end
