namespace :players do
  desc 'CREATE PLAYERS'

  task create_players: :environment do
    Player.get_list(page: 1)
  end

  task create_teams: :environment do

    Team.create_teams
  end
end
