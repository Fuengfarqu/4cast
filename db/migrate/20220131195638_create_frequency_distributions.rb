class CreateFrequencyDistributions < ActiveRecord::Migration[7.0]
  def change
    create_table :frequency_distributions do |t|
      t.integer :month
      t.integer :year
      t.integer :demand
      t.integer :frequency
      t.float :probability
      t.float :acumulative_probability
      t.belongs_to :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
