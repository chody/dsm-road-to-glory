class PlayersController < ApplicationController
  def index
    @players = Player.where(team_id: nil)
  end

  def show
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])

    @player.update(team_id: params[:player][:team_id])

    redirect_to root_path
  end
end
