require 'json'
# require_relative 'train_records/interval_rates'

class TrainRecordsController < ApplicationController
    def create
        record = TrainRecords::Create.call(json_params)

        if record.save
            render json: {message: "Success!", record: record}
        else
            render json: {message: "Fail..."}
        end

        # save_json(record[:id], params[:json])
    end

    def interval_rates
        res = TrainRecords::IntervalRates.call(params[:id])
        render json: {interval_rates: res}
    end

    private

    def save_json(index, json)
        File.open("./record#{index}.json", "a") do |file|
            JSON.dump(json, file)
        end
    end

    def json_params
        json = params.require(:json)
    end
end
