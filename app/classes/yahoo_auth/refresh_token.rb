# frozen_string_literal: true

module YahooAuth
  class RefreshToken
    attr_reader :yahoo_auth, :client

    def self.run(yahoo_auth, client)
      new(yahoo_auth, client).run
    end

    def initialize(yahoo_auth, client)
      @yahoo_auth = yahoo_auth
      @client = client
    end

    def run
      setup
    end

    def setup
      oauth_credentials = Base64.strict_encode64("#{Rails.application.credentials.dig(:yahoo_client_id)}:#{Rails.application.credentials.dig(:yahoo_client_secret)}")
      token = client.get_token(refresh_token: yahoo_auth.refresh_token, redirect_uri: Rails.application.credentials.dig(:redirect_url), headers: { 'Authorization' => "Basic #{oauth_credentials}" }, grant_type: "refresh_token").to_hash
      refresh_time = Time.now + 1.hour
      yahoo_auth.update(access_token: token[:access_token], refresh_at: refresh_time)
    end
  end
end
