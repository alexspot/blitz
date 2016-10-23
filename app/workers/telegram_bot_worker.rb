require 'telegram/bot'

class TelegramBotWorker
  include Sidekiq::Worker

  # TOKEN = '262483786:AAFbFV3dYk2Bc9lRUmADuwGZ47WzruqI2Qc'
  # CHANNEL = '286556903'

  def perform_async(message)
    Telegram::Bot::Client.run(ENV['telegram_bot_token']) do |bot|
      bot.api.send_message(chat_id: ENV['telegram_bot_channel'], text: message)
    end
  end
end