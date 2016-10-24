require 'upwork/api'
require 'upwork/api/routers/auth'
require 'upwork/api/routers/jobs/search'
require 'telegram/bot'

class UpworkJobService

  def call
    do_search['jobs'].each do |job|
      if UpworkJob.is_job_new?(job['id'])
        UpworkJob.create(job_id:job['id']) #saved new job to db
        message = "Blitzkrieg bot found new job:
                   #{job['title']}
                   Job Type: #{job['job_type']}
                   Workload: #{job['workload']}
                   Client PS: #{job['client']['payment_verification_status']}
                   Posted:#{job['date_created']}
                   #{job['url']}"
        Telegram::Bot::Client.run(ENV['telegram_bot_token']) do |bot|
          bot.api.send_message(chat_id: ENV['telegram_bot_channel'], text: message)
        end
      end
    end
  end

  private

  def setup_client
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

  def do_search
    params = {
        'q'           => 'junior rails',
        'job_type'    => 'hourly',
        'workload'    => 'part_time,full_time',
        'duration'    => 'quarter,semester',
        'days_posted' => 5,
    }
    Upwork::Api::Routers::Jobs::Search.new(setup_client).find(params)
  end
end