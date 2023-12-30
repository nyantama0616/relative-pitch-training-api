require 'json'
# require_relative 'train_records/interval_rates'

class TrainRecordsController < ApplicationController
	def create
		unless user = User.find(params[:user_id])
			render json: {message: "User not found"}, status: 404
		end

		records = TrainRecord.dumped_records(params[:records])
		train_record = TrainRecord.new(user: user, records: records)

		if train_record.save
		    render json: { message: "Success!", record: train_record }
		else
		    render json: { message: "Failed..." }, status: 500
		end

		# save_json(record[:id], params[:json])
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
end
