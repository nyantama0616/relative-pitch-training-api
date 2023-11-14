require 'json'

class TrainRecordsController < ApplicationController
    def create
        json = JSON.dump(params[:json])
        record = TrainRecord.new(json: json)
        if record.save
            render json: {message: "Success!", record: record}
        else
            render json: {message: "Fail..."}
        end

        save_json(record[:id], params[:json])
    end

    private

    def save_json(index, json)
        File.open("./record#{index}.json", "a") do |file|
            JSON.dump(json, file)
        end
    end
end
