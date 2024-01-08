module Analysis
  def questions_parsed
    parsed = JSON.parse(questions)

    #TODO: 後で消す
    if parsed.length > 0 && parsed[0]["interval"]["note1"] == 60
      parsed.shift
    end

    parsed
  end

  def infos
    questions_parsed.map do |q|
      interval = q["interval"].transform_keys(&:to_sym)

      #TODO: save時にチェックするべき
      if (q["keyPushes"].empty? || q["keyPushes"][-1]["note"] != interval[:note1])
        raise "invalid keyPushes, #{q["keyPushes"]}}"
      end

      reaction_time = q["keyPushes"][-1]["time"] - q["startTime"]
      miss_count = q["keyPushes"].count - 1

      {
        interval: interval,
        reaction_time: reaction_time,
        miss_count: miss_count
      }
    end
  end

  def means
    reaction_time = NOTES.map { |note| [note, [0, 0]] }.to_h
    miss_count = NOTES.map { |note| [note, [0, 0]] }.to_h
    
    infos.each do |info|
      note = info[:interval][:note1]
      
      reaction_time[note][0] += info[:reaction_time]
      reaction_time[note][1] += 1
      
      miss_count[note][0] += info[:miss_count]
      miss_count[note][1] += 1
    end

    {
      reaction_time: reaction_time.transform_values { |v| v[0] / v[1] },
      miss_count: miss_count.transform_values { |v| v[0] / v[1] }
    }
  end
  
  def medians
    reaction_time = NOTES.map { |note| [note, []] }.to_h
    miss_count = NOTES.map { |note| [note, []] }.to_h

    infos.each do |info|
      note = info[:interval][:note1]
      
      reaction_time[note].push(info[:reaction_time])
      miss_count[note].push(info[:miss_count])
    end

    {
      reaction_time: reaction_time.transform_values { |v| v.sort[v.length / 2] },
      miss_count: miss_count.transform_values { |v| v.sort[v.length / 2] }
    }
  end
end
