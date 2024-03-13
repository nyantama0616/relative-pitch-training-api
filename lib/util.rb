module Util
  class << self
    def print_matrix(matrix)
      matrix.to_a.each do |row|
        puts row.map { |x| x.to_s.rjust(3) }.join(" ")
      end
    end
  
    def median(array)
      sorted = array.sort
      len = sorted.length
      (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
    end
  end
end
