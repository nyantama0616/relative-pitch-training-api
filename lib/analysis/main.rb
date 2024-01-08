require_relative './users.rb'
require_relative './datum.rb'

father0 = $datum[:my_system0][:father][:train]
puts father0.infos[0..2]
puts father0.means
puts father0.medians
