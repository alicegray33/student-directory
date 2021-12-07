# All student names stored in an arrary
students = [
  "Dr. Hannibal Lecter",
  "Darth Vader",
  "Nurse Ratched",
  "Michael Corleone",
  "Alex DeLarge",
  "The Wicked Witch of the West",
  "Terminator",
  "Freddy Krueger",
  "The Joker",
  "Joffrey Baratheon",
  "Norman Bates"
]

# First we print the list of students from the array
puts "The students of Villains Academy"
puts "-------------"
students.each do |student|
  puts student
end

# Then we print the total number of students; all on one line
puts "Overall, we have #{students.count} great students"