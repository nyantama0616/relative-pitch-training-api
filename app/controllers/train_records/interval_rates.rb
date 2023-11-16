require 'json'
require "logger"

module TrainRecords
    module IntervalRates
        extend ActiveSupport::Concern #これいる？
        
        NOTES = [50, 52, 53, 55, 57, 59, 62, 64, 65, 67, 69, 71]
        def self.call(id)
            record = TrainRecord.find(id)
            interval_records = JSON.parse(record[:json], symbolize_names: true)

            hash = {}
            NOTES.each do |note|
                hash[note] = [0, 0, 0]
            end

            interval_records.each do |record|
                hash[record[:note1]][0] += record[:missCount]
                hash[record[:note1]][1] += record[:duration]
                hash[record[:note1]][2] += 1
            end

            result = {
                missRates: [],
                averageReactionRates: []
            }

            hash.keys.sort.each_with_index do |note, i|
                if hash[note][2] == 0
                    result[:missRates][i] = 0
                    result[:averageReactionRates][i] = 0
                else
                    result[:missRates][i] = hash[note][0] / hash[note][2].to_f
                    result[:averageReactionRates][i] = hash[note][1] / hash[note][2].to_f
                end
            end

            result
        end
    end
end
