require 'csv'

namespace :import do

  desc "Import users from csv"
  task users: :environment do
    filename = File.join Rails.root, "users.csv"
    
    counter = 0

    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      user = User.assign_from_row(row)
      if user.save
        counter += 1
      else
        puts "#{user.email} - #{user.errors.full_messages.join(",")}"
      end
    end

    puts "Imported #{counter} users"
  end
end