namespace :players do
  desc 'CREATE PLAYERS'

  task create_players: :environment do
    require 'uri'
    puts "CREATING PLAYERS"

    # some fake ebay shit
  #   search_string = URI.escape("#{@card.manufacturer} #{@card.year} #{@card.player_full_name} #{@card.series_number}")
  # url = "https://fantasysports.yahooapis.com/fantasy/v2/league/223.l.431/players"
  # 189624
  league_key = '406.l.189624'

  list = Player.get_list(page: 1)


  # @cards = eval(response.body)

  end
end
