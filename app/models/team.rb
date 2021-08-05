class Team < ApplicationRecord

  def self.create_teams
    url = "https://fantasysports.yahooapis.com/fantasy/v2/league/#{Rails.application.credentials.dig(:league_key)}/teams"

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

    teams = xml_hash.dig('fantasy_content', 'league', 'teams', 'team')

    teams.each do |team|
      puts "creating TEAM #{team['name']}\n\n\n"
      Team.create(name: team['name'],
                  owner: Team.get_owner_name(team: team['managers']['manager']['nickname']),
                  logo: team['team_logos']['team_logo']['url'],
                  draft_position: Team.get_draft_position(team: team['managers']['manager']['nickname'])
                )
    end
  end

  def self.get_owner_name(team: nil)
    case team
    when 'Harrison'
      return 'Harry'
    when 'Bryce Lobdell'
      return 'Bryce'
    when 'Lucas'
      return 'Luke'
    when 'Dane M'
      return 'Dane'
    when 'Jared'
      return 'Botj'
    when 'Zach'
      return 'Bart'
    when 'adam'
      return 'Brink'
    else
      return team
    end
  end

  def self.get_draft_position(team: nil)
    case team
    when 'Harrison'
      return 3
    when 'Paul'
      return 6
    when 'Cody'
      return 2
    when 'Bryce Lobdell'
      return 10
    when 'Aric'
      return 5
    when 'Zach'
      return 7
    when 'Lucas'
      return 9
    when 'Dane M'
      return 1
    when 'Jared'
      return 4
    when 'adam'
      return 8
    end
  end
end
