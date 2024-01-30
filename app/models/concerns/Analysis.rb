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

      misses = q["keyPushes"][0..-2].map { |k| k.transform_keys(&:to_sym).merge({diff: k["note"] - interval[:note1]})}

      {
        interval: interval,
        reaction_time: reaction_time,
        miss_count: miss_count,
        misses: misses,
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
      reaction_time: reaction_time.transform_values { |v| v[0] / v[1].to_f },
      miss_count: miss_count.transform_values { |v| v[0] / v[1].to_f }
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

    ramda = ->(v) {
      n = v.length
      _v = v.sort
      if n % 2 == 0
        (_v.sort[n / 2 - 1] + _v[n / 2]) / 2.0
      else
        _v.sort[n / 2]
      end
    }

    {
      reaction_time: reaction_time.transform_values(&ramda),
      miss_count: miss_count.transform_values(&ramda)
    }
  end

  def train_time
    a = questions_parsed
    if a.empty?
      0
    else
      a[-1]["keyPushes"][-1]["time"] #ms
    end
  end

  def total_miss_count
    infos.map {|x| x[:miss_count]}.sum
  end
end
