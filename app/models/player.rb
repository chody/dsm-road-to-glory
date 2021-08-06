class Player < ApplicationRecord
  belongs_to :team, optional: true

  def self.get_list(page: nil)

    url = "https://fantasysports.yahooapis.com/fantasy/v2/league/#{Rails.application.credentials.dig(:league_key)}/players;start=#{page}"

    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    yahoo_auth = YahooAuthentication.first

    client = OAuth2::Client.new(Rails.application.credentials.dig(:yahoo_client_id),
                                Rails.application.credentials.dig(:yahoo_client_secret),
                                site: 'https://api.login.yahoo.com',
                                authorize_url: 'https://api.login.yahoo.com/oauth2/request_auth',
                                token_url: 'https://api.login.yahoo.com/oauth2/get_token')
  #

    YahooAuth::RefreshToken.run(yahoo_auth, client)
    request["Authorization"] = "Bearer #{yahoo_auth.access_token}"

    req_options = {
      use_ssl: uri.scheme == "https",
    }


    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    xml  = Nokogiri::XML(response.body)

    xml_hash = Hash.from_xml(xml.to_s)

    players = xml_hash.dig('fantasy_content', 'league', 'players', 'player')

    players.each do |p|
      puts "CREATING #{p['name']['full']}"
      Player.create(name: p['name']['full'],
                    first_name: p['name']['first'],
                    last_name: p['name']['last'],
                    position: p['display_position'],
                    headshot: p['image_url'],
                    nfl_team: p['editorial_team_full_name'],
                    bye_week: p['bye_weeks']['week'])
    end if players.present?

    Player.get_list(page: page + 25) if players.present?

  end
end
