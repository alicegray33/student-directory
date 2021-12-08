require "csv"

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
  @current_cohort = STDIN.gets.chomp.capitalize
  puts "Enter name of file to save students to:"
  @filename = STDIN.gets.chomp
  save_settings
end

def change_cohort
  puts "Enter new cohort:"
  @current_cohort = STDIN.gets.chomp.capitalize
  puts "Cohort changed to #{@current_cohort}"
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
  puts "\nMain Menu"
  puts "---------"
  puts "Choose an option:"
  puts "1. Input new students"
  puts "2. List the students"
  puts "3. Delete students"
  puts "4. Change cohort"
  puts "7. Save changes to file"
  puts "8. Reload from file"
  puts "9. Exit" 
end

def list_students
  print_students_list
  print_total_students
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
      puts "Invalid option, try again"
  end
end

def delete_students
  puts "\nPlease enter the ID number of the student to delete"
  puts "To finish, just hit return twice"
  del_id = STDIN.gets.chomp
  
  while !del_id.empty? do
    if del_id.to_i
      if @students.find {|student| student[:id_num] == del_id }
        @students.delete_if { |student| student[:id_num] == del_id }
        puts "Student deleted. We now have #{@students.count} students"
        del_id = STDIN.gets.chomp
      else
        puts "Student ID not found, try again"
        del_id = STDIN.gets.chomp
      end
    else
      puts "I don't know what you mean, try again"
      del_id = STDIN.gets.chomp
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
    @students << {id_num: row[0], name: row[1], cohort: row[2], score: row[3]}
  end
  puts "Loaded #{@students.count} from #{@filename}"
end

def input_students
  new_id_num = @students[-1][:id_num].to_i + 1
  puts "\nPlease enter the names of the students"
  puts "To finish, just hit return twice"
  name = STDIN.gets.chomp
  while !name.empty? do
    @students << {id_num: new_id_num.to_s, name: name, cohort: @current_cohort, score: 0}
    puts "Student inputted. We now have #{@students.count} students"
    new_id_num += 1
    name = STDIN.gets.chomp
  end
end

def save_students
  CSV.open(@filename, "w") do |csv|
    @students.each do |student|
      csv << [student[:id_num], student[:name], student[:cohort], student[:score]]
    end
  end
  puts "Saved #{@students.count} to #{@filename}"
end

def print_header
  puts "\n#{@school_name} Student Directory"
  @school_name.length.times { print "=" }
  puts "=================="
end

def print_students_list
  system('clear')
  puts "#{@school_name} Students List"
  puts "------------------------------------------------------"
  puts "ID Num\tName\t\t\tCohort\t\tScore"
  puts "------------------------------------------------------"
  @students.each do |student|
    puts student[:id_num].to_s.ljust(8) + student[:name].to_s.ljust(24) + student[:cohort].to_s.ljust(16) + student[:score].to_s
  end
  puts "------------------------------------------------------"
end

def print_total_students
  if @students.count > 1
    puts "In total, we have #{@students.count} students."
  elsif @students.count == 1
    puts "In total, we have 1 student."
  else
    puts "We currently have no students."
  end
end

system('clear')
load_settings
try_load_students
print_header
interactive_menu