

namespace :import_inventory_demand do

  desc "Import inventory demand from csv"
  task items: :environment do
    filename = File.join Rails.root, "vendor/inventory_demand.csv"
    counter = 0

    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      frequency_distribution = FrequencyDistribution.assign_from_row(row)
      if frequency_distribution.save
        counter += 1
      else
        puts "#{frequency_distribution.item.name} - #{frequency_distribution.year}"\
             "#{frequency_distribution.month} #{frequency_distribution.errors.full_messages
                                                                             .join(",")}"
      end
    end

    puts "Imported #{counter} items"
  end

end