require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'


class GameTest < Minitest::Test
  def setup
    @pick_4 = Game.new('Pick 4', 2)
    @mega_millions = Game.new('Mega Millions', 5, true)
  end

  def test_it_exists
    assert_instance_of Game, @pick_4
    assert_instance_of Game, @mega_millions
  end

  def test_it_has_attributes
    assert_equal "Mega Millions", @mega_millions.name
    assert_equal 5, @mega_millions.cost
    assert_equal true, @mega_millions.national_drawing?
    assert_equal false, @pick_4.national_drawing?
  end
end




#
# pry(main)> alexander = Contestant.new({first_name: 'Alexander',
#                                       last_name: 'Aigiades',
#                                       age: 28,
#                                       state_of_residence: 'CO',
#                                       spending_money: 10})
# #=> <Contestant:0x007ff87ac0a498...>
#
# pry(main)> alexander.full_name
# #=> "Alexander Aigiades"
#
# pry(main)> alexander.age
# #=> 28
#
# pry(main)> alexander.state_of_residence
# #=> "CO"
#
# pry(main)> alexander.spending_money
# #=> 10
#
# pry(main)> alexander.out_of_state?
# #=> false
#
# pry(main)> alexander.game_interests
# #=> []
#
# pry(main)> alexander.add_game_interest('Mega Millions')
# pry(main)> alexander.add_game_interest('Pick 4')
#
# pry(main)> alexander.game_interests
# => ["Mega Millions", "Pick 4"]
# ```
