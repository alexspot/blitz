require 'telegram/bot'

class TelegramBotWorker
  include Sidekiq::Worker

  def perform_async
    UpworkJobService.new.call
  end
end