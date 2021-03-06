require 'minitest/autorun'
require 'minitest/pride'
require './lib/contestant'
require './lib/game'
require './lib/colorado_lottery'

class ColoradoLotteryTest < Minitest::Test
  def setup
    @lottery = ColoradoLottery.new

    @pick_4 = Game.new('Pick 4', 2)
    @mega_millions = Game.new('Mega Millions', 5, true)
    @cash_5 = Game.new('Cash 5', 1)

    @alexander = Contestant.new({
      first_name: 'Alexander',
      last_name: 'Aigades',
      age: 28,
      state_of_residence: 'CO',
      spending_money: 10})

    @benjamin = Contestant.new({
      first_name: 'Benjamin',
      last_name: 'Franklin',
      age: 17,
      state_of_residence: 'PA',
      spending_money: 100})

    @frederick = Contestant.new({
      first_name:  'Frederick',
      last_name: 'Douglas',
      age: 55,
      state_of_residence: 'NY',
      spending_money: 20})

    @winston = Contestant.new({
      first_name: 'Winston',
      last_name: 'Churchill',
      age: 18,
      state_of_residence: 'CO',
      spending_money: 5})

    @alexander.add_game_interest('Pick 4')
    @alexander.add_game_interest('Mega Millions')
    @frederick.add_game_interest('Mega Millions')
    @winston.add_game_interest('Cash 5')
    @winston.add_game_interest('Mega Millions')
    @benjamin.add_game_interest('Mega Millions')

  end

  def test_it_exists
    assert_instance_of ColoradoLottery, @lottery
  end

  def test_it_has_attributes
    assert_equal [], @lottery.winners
    expected = {}
    assert_equal expected, @lottery.registered_contestants
    assert_equal expected, @lottery.current_contestants
  end

  def test_interested_and_18?
    assert_equal true, @lottery.interested_and_18?(@alexander, @pick_4)
    assert_equal false, @lottery.interested_and_18?(@benjamin, @mega_millions)
    assert_equal false, @lottery.interested_and_18?(@alexander, @cash_5)
  end

  def test_can_register
    assert_equal true, @lottery.can_register?(@alexander, @pick_4)
    assert_equal false, @lottery.can_register?(@alexander, @cash_5)
    assert_equal true, @lottery.can_register?(@frederick, @mega_millions)
    assert_equal false, @lottery.can_register?(@benjamin, @mega_millions)
    assert_equal false, @lottery.can_register?(@frederick, @cash_5)
  end

  def test_register_contestant
  
    @lottery.register_contestant(@alexander, @pick_4)
    expected = {"Pick 4" => [@alexander]}
    assert_equal expected, @lottery.registered_contestants

    @lottery.register_contestant(@alexander, @mega_millions)
    expected2 = {"Pick 4" => [@alexander],"Mega Millions" => [@alexander]}
    assert_equal expected2, @lottery.registered_contestants

    @lottery.register_contestant(@frederick, @mega_millions)
    @lottery.register_contestant(@winston, @cash_5)
    @lottery.register_contestant(@winston, @mega_millions)
    expected3 = {"Pick 4"=>[@alexander],"Mega Millions"=>[@alexander, @frederick, @winston],"Cash 5" =>[@winston]}
    assert_equal expected3, @lottery.registered_contestants

    grace = Contestant.new({
      first_name: 'Grace',
      last_name: 'Hopper',
      age: 20,
      state_of_residence: 'CO',
      spending_money: 20})

    assert_instance_of Contestant, grace

    grace.add_game_interest('Mega Millions')
    grace.add_game_interest('Cash 5')
    grace.add_game_interest('Pick 4')
    @lottery.register_contestant(grace, @mega_millions)
    @lottery.register_contestant(grace, @cash_5)
    @lottery.register_contestant(grace, @pick_4)

    expected4 = {"Pick 4"=>[@alexander, grace],"Mega Millions"=>[@alexander, @frederick, @winston, grace],"Cash 5" =>[@winston, grace]}
    assert_equal expected4, @lottery.registered_contestants

  end

  def test_eligible_contestants

    grace = Contestant.new({
      first_name: 'Grace',
      last_name: 'Hopper',
      age: 20,
      state_of_residence: 'CO',
      spending_money: 20})

    assert_instance_of Contestant, grace

    @lottery.register_contestant(@alexander, @pick_4)
    @lottery.register_contestant(@alexander, @mega_millions)
    @lottery.register_contestant(@frederick, @mega_millions)
    @lottery.register_contestant(@winston, @cash_5)
    @lottery.register_contestant(@winston, @mega_millions)

    grace.add_game_interest('Mega Millions')
    grace.add_game_interest('Cash 5')
    grace.add_game_interest('Pick 4')
    @lottery.register_contestant(grace, @mega_millions)
    @lottery.register_contestant(grace, @cash_5)
    @lottery.register_contestant(grace, @pick_4)

    assert_equal [@alexander, grace], @lottery.eligible_contestants(@pick_4)
  end




 # pry(main)> lottery.eligible_contestants(pick_4)
 # #=> [#<Contestant:0x007ffe95fab0b8...>,
 #  #<Contestant:0x007ffe99998190...>]
 #
 # pry(main)> lottery.eligible_contestants(cash_5)
 # #=> [#<Contestant:0x007ffe96db1180...>, #<Contestant:0x007ffe99998190...>]
 #
 # pry(main)> lottery.eligible_contestants(mega_millions)
 # #=> [#<Contestant:0x007ffe95fab0b8...>, #<Contestant:0x007ffe99848470...>, #<Contestant:0x007ffe99998190...>]
 #
 # pry(main)> lottery.charge_contestants(cash_5)
 #
 # pry(main)> lottery.current_contestants
 # #=> {#<Game:0x007f8a32295360...> => ["Winston Churchill", "Grace Hopper"]}
 #
 # pry(main)> grace.spending_money
 # #=> 19
 #
 # pry(main)> winston.spending_money
 # #=> 4
 #
 # pry(main)> lottery.charge_contestants(mega_millions)
 #
 # pry(main)> lottery.current_contestants
 # #=> {#<Game:0x007f8a32295360...> => ["Winston Churchill", "Grace Hopper"],
 #  #<Game:0x007f8a322ad5a0...> => ["Alexander Aigades", "Frederick Douglas", "Grace Hopper"]}
 #
 # pry(main)> grace.spending_money
 # #=> 14
 #
 # pry(main)> winston.spending_money
 # #=> 4
 #
 # pry(main)> alexander.spending_money
 # #=> 5
 #
 # pry(main)> frederick.spending_money
 # #=> 15
 #
 # pry(main)> lottery.charge_contestants(pick_4)
 #
 # pry(main)> lottery.current_contestants
 # #=> {#<Game:0x007f8a32295360...> => ["Winston Churchill", "Grace Hopper"],
 # #<Game:0x007f8a322ad5a0...> => ["Alexander Aigades", "Frederick Douglas", "Grace Hopper"],
 # #<Game:0x007f8a317b5e40...> => ["Alexander Aigades", "Grace Hopper"]}
 # ```
end
