class Item < ApplicationRecord
  has_many :frequency_distributions

  def self.import(file)
    counter = 0

    CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
      frequency_distribution = FrequencyDistribution.assign_from_row(row)
      if frequency_distribution.save
        counter += 1
      else
        puts "#{frequency_distribution.item.name} - #{frequency_distribution.year}"\
             "#{frequency_distribution.month} #{frequency_distribution.errors.full_messages
                                                                             .join(",")}"
      end
    end

    counter
  end
end
