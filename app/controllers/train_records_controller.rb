require 'json'
# require_relative 'train_records/interval_rates'

class TrainRecordsController < ApplicationController
    # 指定されたユーザーのトレーニング記録を全て取得する(トレーニングidの配列を返す)
    def index
        record_ids = TrainRecord.where(user_id: params[:user_id]).order(:created_at).pluck(:id)
        render json: {train_record_ids: record_ids}
    end

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
        render json: {intervalRates: res}
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
