class AddEventimIdToMatch < ActiveRecord::Migration[5.1]
  def change
    change_table "matches" do |t|
      t.string :eventim_id
    end
  end
end
