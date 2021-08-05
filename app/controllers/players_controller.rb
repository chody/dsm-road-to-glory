class PlayersController < ApplicationController
  def index
    @players = Player.where(team_id: nil)
  end
end
