require 'upwork/api'
require 'upwork/api/routers/auth'
require 'upwork/api/routers/jobs/search'
class UpworkJob < ActiveRecord::Base

  def self.send_telegram_message(text)
    TelegramBotWorker.new.perform_async(text)
  end

  def self.format_response
    self.search_for_jobs['jobs'].each do |job|
      p job['title']
      p job['snippet'][0..50] #50 symbols for snippet to return
      p job['job_type']
      p job['client']['payment_verification_status']
    end
  end

  def self.search_for_jobs
    params = {
        'q' => 'junior rails',
        'job_type'    => 'hourly',
        'workload'    => 'part_time,full_time',
        'duration'    => 'quarter,semester',
        'days_posted' => 5,

    }
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
