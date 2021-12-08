require "csv"
@students = []

def interactive_menu
  loop do
    print_menu 
    process(STDIN.gets.chomp)
  end
end

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list from students.csv"
  puts "5. Delete students"
  puts "9. Exit" 
end

def show_students
  print_header
  print_students_list
  print_footer
end

def process(selection)
  case selection
    when "1"
      input_students
    when "2"
      show_students
    when "3"
      save_students
    when "4"
      load_students
    when "5"
      delete_students
    when "9"
      exit
    else
      puts "I don't know what you mean, try again"
  end
end

def delete_students
  puts "Please enter the number of the student to delete"
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
  filename = ARGV.first 
  if filename.nil? 
    load_students
  elsif File.exists?(filename) 
    load_students(filename)
  else 
    puts "Sorry, #{filename} doesn't exist. No students loaded" 
  end
end

def load_students_old(filename = "students.csv")
  @students = []
  File.open(filename, "r") do |file|
    file.readlines.each do |line|
    name, cohort = line.chomp.split(',')
      @students << {name: name, cohort: cohort.to_sym}
    end
  end
  puts "Loaded #{@students.count} from #{filename}"
end

def load_students(filename = "students.csv")
  @students = []
  CSV.foreach(filename, "r") do |row|
    @students << {name: row[0], cohort: row[1].to_sym}
  end
  puts "Loaded #{@students.count} from #{filename}"
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  name = STDIN.gets.chomp
  while !name.empty? do
    @students << {name: name, cohort: :november}
    puts "Student inputted. We now have #{@students.count} students"
    name = STDIN.gets.chomp
  end
end

def save_students
  CSV.open("students.csv", "w") do |csv|
    @students.each do |student|
      csv << [student[:name], student[:cohort]]
    end
  end
  puts "Saved #{@students.count} to students.csv"
end

def print_header
  puts "The students of Villains Academy"
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

try_load_students
interactive_menu