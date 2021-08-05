# frozen_string_literal: true

module YahooAuth
  class GetToken
    attr_reader :client, :code, :yahoo_auth

    def self.run(client, code, yahoo_auth)
      new(client, code, yahoo_auth).run
    end

    def initialize(client, code, yahoo_auth)
      @client = client
      @code = code
      @yahoo_auth = yahoo_auth
    end

    def run
      setup
    end

    def setup
      oauth_credentials = Base64.strict_encode64("#{Rails.application.credentials.dig(:yahoo_client_id)}:#{Rails.application.credentials.dig(:yahoo_client_secret)}")
      token = client.auth_code.get_token(code, redirect_uri: Rails.application.credentials.dig(:redirect_url), headers: { 'Authorization' => "Basic #{oauth_credentials}"}, grant_type: "authorization_code").to_hash
      refresh_time = Time.now + 1.hour

      if yahoo_auth
        yahoo_auth.update(access_token: token[:access_token],
                          refresh_token: token[:refresh_token],
                          refresh_at: refresh_time)
      else
        YahooAuthentication.create(access_token: token[:access_token],
                                   refresh_token: token[:refresh_token],
                                   refresh_at: refresh_time)
      end
    end
  end
end
