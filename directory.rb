require "csv"
@edited = "No"

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
  @filename = STDIN.gets.chomp + ".csv"
  save_settings
end

def change_cohort
  system('clear')
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
  puts "Current cohort: #{@current_cohort}"
  puts "Choose an option:"
  puts "1. Input new students"
  puts "2. List all students"
  puts "3. Delete students"
  puts "4. Change cohort"
  puts "5. List students in current cohort"
  puts "6. Search students name"
  puts "7. Save changes to file"
  puts "8. Reload from file"
  puts "9. Exit" 
  puts "10. Input Scores"
  puts "11. Average Scores"
end

def process(selection)
  case selection
    when "1"
      input_students
    when "2"
      list_all_students
    when "3"
      delete_students
    when "4"
      change_cohort
    when "5"
      print_students_in_cohort
    when "6"
      search_students_name
    when "7"
      save_students
    when "8"
      try_load_students
      puts "Loaded #{@students.count} student/s from #{@filename}"
    when "9"
      check_exit
    when "10"
      input_scores
    when "11"
      average_scores
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
        @edited = "Yes"
        del_id = STDIN.gets.chomp
      else
        puts "Student ID not found, try again"
        del_id = STDIN.gets.chomp
      end
    else
      puts "Invalid input, try again"
      del_id = STDIN.gets.chomp
    end
  end
end

def try_load_students
  @students = []
  if File.exists?(@filename) 
    load_students
  else
    puts "No students to load."
  end
end

def load_students 
  CSV.foreach(@filename, "r") do |row|
    @students << {id_num: row[0], name: row[1], cohort: row[2], score: row[3]}
  end
end

def input_students
  new_id_num = get_new_id_num
  puts "\nPlease enter the names of the students"
  puts "To finish, just hit return twice"
  name = STDIN.gets.chomp
  while !name.empty? do
    @students << {id_num: new_id_num.to_s, name: name, cohort: @current_cohort, score: 0}
    puts "Student inputted. We now have #{@students.count} students"
    new_id_num += 1
    @edited = "Yes"
    name = STDIN.gets.chomp
  end
end

def get_new_id_num
  if @students.empty?
    new_id_num = 1
  else
    new_id_num = @students[-1][:id_num].to_i + 1
  end
end

def save_students
  CSV.open(@filename, "w") do |csv|
    @students.each do |student|
      csv << [student[:id_num], student[:name], student[:cohort], student[:score]]
    end
  end
  @edited = "No"
  puts "Saved #{@students.count} to #{@filename}"
end

def print_header
  puts "\n#{@school_name} Student Directory"
  @school_name.length.times { print "=" }
  puts "=================="
  print_total_students
end

def print_students_in_cohort
  system('clear')
  by_cohort = @students.select { |student| student[:cohort] == @current_cohort }
  if !by_cohort.empty?
    print_list_header
    by_cohort.each do |student|
      puts_student(student)
    end
    print_list_footer
  else
    puts "No students found in #{@current_cohort}"
  end
end

def search_students_name
  system('clear')
  puts "Enter name (or partial name):"
  name_search = STDIN.gets.chomp
  search = @students.select { |student| student[:name].include? name_search }
  if !search.empty?
    print_list_header
    search.each do |student|
      puts_student(student)
    end
    print_list_footer
  else
    puts "No results."
  end
end

def list_all_students
  if !@students.empty?
    system('clear')
    puts "#{@school_name} Students List"
    print_list_header
    @students.each do |student|
      puts_student(student)
    end
    print_list_footer
    print_total_students
  end
end

def puts_student(student)
  puts student[:id_num].to_s.ljust(8) + student[:name].to_s.ljust(24) + student[:cohort].to_s.ljust(16) + student[:score].to_s
end

def print_list_header
  puts "------------------------------------------------------"
  puts "ID Num\tName\t\t\tCohort\t\tScore"
  puts "------------------------------------------------------"
end

def print_list_footer
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

def input_scores
  system('clear')
  @students.each_with_index do |student, index|
    if student[:cohort] == @current_cohort
      puts "Enter score for #{student[:name]}:"
      new_score = STDIN.gets.chomp
      @students[index][:score] = new_score
      @edited = "Yes"
    end
  end
end

def average_scores
  system('clear')
  test_scores = {}
  get_scores(test_scores)
  puts "Cohort\t\tAverage Highest Lowest"
  puts "-------------------------------------"
  test_scores.each do |cohort,scores|
    print cohort.to_s.ljust(16)
    print (scores.sum(0.0) / scores.size).floor(2).to_s.ljust(8)
    print scores.max.to_s.ljust(9)
    print scores.min
    print "\n"
  end
end

def get_scores(test_scores)
  @students.each do |student|
    if test_scores.has_key?(student[:cohort])
      test_scores[student[:cohort]] << student[:score].to_i
    else
      test_scores[student[:cohort]] = [student[:score].to_i]
    end
  end
  return test_scores
end

def check_exit
  if @edited == "Yes"
    puts "You have not saved your changes to file."
    puts "Are you sure you want to exit? (y/n)"
    while true do
      input = STDIN.gets.chomp
      if input == "y"
        system('clear')
        exit
      elsif input == "n"
        return
      else
        puts "Invalid option, try again"
      end
    end
  else
    system('clear')
    exit
  end
end

system('clear')
load_settings
try_load_students
print_header
interactive_menu