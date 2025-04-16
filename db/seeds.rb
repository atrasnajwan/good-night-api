# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
puts "Seeding..."

# Clear existing data, comment if you don't want to
Following.delete_all
SleepRecord.delete_all
User.delete_all
puts "Done resetting"

# Create Users
users = [
  { name: "Mike Stinger" },
  { name: "Tosin Abasi" },
  { name: "Tim Henson" },
  { name: "The Rev" },
  { name: "Chuck Schuldiner" }
].map { |user_data| User.create!(user_data) }

puts "Created #{users.count} users"

# Followings relationships
Following.create!(follower: users[0], followed: users[1])
Following.create!(follower: users[0], followed: users[2])
Following.create!(follower: users[1], followed: users[3])
Following.create!(follower: users[1], followed: users[4])
Following.create!(follower: users[2], followed: users[4])
Following.create!(follower: users[2], followed: users[1])
Following.create!(follower: users[3], followed: users[0])
Following.create!(follower: users[4], followed: users[3])
Following.create!(follower: users[4], followed: users[0])

puts "Created followings relationships"

# Sleep Records
now = Time.now

users.each do |user|
  3.times do |i|
    clocked_out = now - (i + 1).days + rand(6..9).hours # random 6-9
    clocked_in = clocked_out - rand(6..8).hours

    SleepRecord.create!(
      user: user,
      clocked_in_at: clocked_in,
      clocked_out_at: clocked_out
    )
  end
end

puts "Created sleep records for each user"

puts "DONE"
