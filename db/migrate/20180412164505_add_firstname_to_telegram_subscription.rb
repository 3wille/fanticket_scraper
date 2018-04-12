class AddFirstnameToTelegramSubscription < ActiveRecord::Migration[5.1]
  def change
    change_table "telegram_subscriptions" do |t|
      t.string :first_name
    end
  end
end
