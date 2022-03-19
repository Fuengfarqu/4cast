class RemoveDemandAndMonthYearFromItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :demand, :integer
    remove_column :items, :month_year, :string
  end
end
