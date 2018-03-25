class CreateMatch < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.string :opponent
      t.string :tickets_url
      t.timestamps
    end
  end
end
