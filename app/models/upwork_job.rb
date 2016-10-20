require 'upwork/api'
require 'upwork/api/routers/auth'
require 'upwork/api/routers/jobs/search'


class UpworkJob < ActiveRecord::Base

  def self.search_for_jobs
    params = {'q' => 'python'}
    Upwork::Api::Routers::Jobs::Search.new(self.client).find(params)
  end

  def self.client
    config = Upwork::Api::Config.new(
      'consumer_key'    => Rails.configuration.custom['consumer_key'],
      'consumer_secret' => Rails.configuration.custom['consumer_secret'],
      'access_token'    => Rails.configuration.custom['access_token'],
      'access_secret'   => Rails.configuration.custom['access_secret']
    )
    client =  Upwork::Api::Client.new(config)
    Upwork::Api::Routers::Auth.new(client)

    client
  end
end
