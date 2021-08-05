class DraftController < ApplicationController
  def index
    @teams = Team.all.order(draft_position: :asc)
    client = OAuth2::Client.new(Rails.application.credentials.dig(:yahoo_client_id),
                                Rails.application.credentials.dig(:yahoo_client_secret),
                                site: 'https://api.login.yahoo.com',
                                authorize_url: 'https://api.login.yahoo.com/oauth2/request_auth',
                                token_url: 'https://api.login.yahoo.com/oauth2/get_token')


    yahoo_auth = YahooAuthentication.first
    if !params[:code].present? && !yahoo_auth&.access_token
      redirect_to client.auth_code.authorize_url(redirect_uri: Rails.application.credentials.dig(:redirect_url))
    else
      if yahoo_auth&.access_token
        # refresh if needed
        YahooAuth::RefreshToken.run(yahoo_auth, client) if yahoo_auth&.refresh_at < DateTime.now
      else
        # create a new token
        YahooAuth::GetToken.run(client, URI.unescape(params[:code]), yahoo_auth)
      end
    end
  end
end
