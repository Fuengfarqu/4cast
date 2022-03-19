class FrequencyDistribution < ApplicationRecord
  belongs_to :item

  enum month: { january: 1, february: 2, march: 3, april: 4, may: 5, june: 6,
                 july: 7, august: 8, september: 9, october: 10, november: 11, 
                december: 12
              }
  def self.import(file)
    counter = 0
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      user = User.assign_from_row(row)
      if user.save
        counter += 1
      else
        puts "#{user.email} - #{user.errors.full_messages.join(",")}"
      end
    end
    counter
  end


  def self.assign_from_row(row)
    item = Item.where(name: row[:name]).first_or_initialize
    item.save

    frequency_distribution = FrequencyDistribution.where(item_id: item.id, year: row[:year], month: row[:month].downcase)
                                                  .first_or_initialize

    
    frequency_distribution.assign_attributes row.to_hash.slice(:demand, :frequency, :probability, :acumulative_probability)
    frequency_distribution.item_id = item.id
    frequency_distribution
  end
end
