class CreateTicket < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.string :eventim_id
      t.string :prices
      t.string :seat_description
      t.belongs_to :match, index: true
      t.timestamps
    end
  end
end
