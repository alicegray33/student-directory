require "csv"
@school_name = "Unknown"
@current_cohort = "Unknown"
@filename = "unknown.csv"

@students = []

def load_settings
  if File.exists?("settings.csv")
    settings = CSV.read("settings.csv")
    @school_name, @current_cohort, @filename = settings[0][0], settings[0][1], settings[0][2]
  else
    puts "No settings found. Initializing new user."
    input_settings
  end
end

def input_settings
  puts "Enter name of school:"
  @school_name = STDIN.gets.chomp
  puts "Enter current cohort:"
  @current_cohort = STDIN.gets.chomp
  puts "Enter name of file to save students to:"
  @filename = STDIN.gets.chomp
  save_settings
end

def change_cohort
  puts "Enter new cohort:"
  @current_cohort = STDIN.gets.chomp
  save_settings
end

def save_settings
  CSV.open("settings.csv", "w") do |csv|
    csv << [@school_name, @current_cohort, @filename]
  end
end

def interactive_menu
  loop do
    print_menu 
    process(STDIN.gets.chomp)
  end
end

def print_menu
  puts "\nChoose an option:"
  puts "1. Input new students"
  puts "2. List the students"
  puts "3. Delete students"
  puts "4. Change cohort"
  puts "4. Save changes to file"
  puts "5. Reload from file"
  puts "9. Exit" 
end

def list_students
  print_header
  print_students_list
  print_footer
end

def process(selection)
  case selection
    when "1"
      input_students
    when "2"
      list_students
    when "3"
      delete_students
    when "4"
      change_cohort
    when "7"
      save_students
    when "8"
      load_students
    when "9"
      system('clear')
      exit
    else
      puts "I don't know what you mean, try again"
  end
end

def delete_students
  puts "\nPlease enter the number of the student to delete"
  puts "To finish, just hit return twice"
  name = STDIN.gets.chomp
  
  while !name.empty? do
    if name.to_i
      @students.delete_at(name.to_i - 1)
      puts "Student deleted. We now have #{@students.count} students"
      name = STDIN.gets.chomp
    else
      puts "I don't know what you mean, try again"
      name = STDIN.gets.chomp
    end
  end
end

def try_load_students
  if File.exists?(@filename) 
    load_students
  else 
    puts "#{@filename} doesn't exist. No students loaded" 
  end
end

def load_students
  @students = []
  CSV.foreach(@filename, "r") do |row|
    @students << {name: row[0], cohort: row[1], score: row[2]}
  end
  puts "Loaded #{@students.count} from #{@filename}"
end

def input_students
  puts "\nPlease enter the names of the students"
  puts "To finish, just hit return twice"
  name = STDIN.gets.chomp
  while !name.empty? do
    @students << {name: name, cohort: @current_cohort, score: 0}
    puts "Student inputted. We now have #{@students.count} students"
    name = STDIN.gets.chomp
  end
end

def save_students
  CSV.open("students.csv", "w") do |csv|
    @students.each do |student|
      csv << [student[:name], student[:cohort], student[:score]]
    end
  end
  puts "Saved #{@students.count} to students.csv"
end

def print_header
  puts "The students of #{@school_name}"
  puts "-------------"
end

def print_students_list
  @students.each_with_index do |student, num|
    puts "#{num + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
  end
end

def print_footer
  if @students.count > 1
    puts "Overall, we have #{@students.count} great students"
  elsif @students.count == 1
    puts "Overall, we have 1 great student"
  else
    puts "We have no students!"
  end
end

system('clear')
load_settings
try_load_students
interactive_menu