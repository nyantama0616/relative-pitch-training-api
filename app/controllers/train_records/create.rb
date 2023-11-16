module TrainRecords
    module Create
        extend ActiveSupport::Concern #これいる？

        def self.call(json_params)
            json = dumped_json(json_params)
            record = TrainRecord.new(json: json)
        end

        private
        
        #普通にJSON.dumpすると、文字列のフォーマットがおかしいので、それを直す
        def self.dumped_json(json_params)
            json = JSON.dump(json_params)
            json.gsub!(/\\/, "")
            json.gsub!("\"{", "{")
            json.gsub!("}\"", "}")
            json.gsub("=>", ":")
        end
    end
end
