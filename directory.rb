require 'csv'
@students = []
@line_width = 70
@cohort_month = %w[January February March April
                   May June July August
                   September October November December]
@filter_by = ''

def print_menu
  puts ''
  puts 'What would you like to do?'
  puts '1. Input the students.'
  puts '2. Show the students.'
  puts '3. Save the list to a chosen file'
  puts '4. Load an existing list from from a chosen file'
  puts '9. Exit.'
  puts 'Please input a number.'
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def process(selection)
  case selection
  when '1'
    puts 'You have chosen to add new students.'
    input_students
  when '2'
    puts 'You have chosen to show a list of students.'
    show_students
  when '3'
    puts 'You have chosen to save students.'
    save_students(specific_file)
    puts "#{@students.count} students have been saved to the file."
  when '4'
    puts 'You have chosen to load students.'
    load_students(specific_file)
  when '9'
    exit(0)
  else
    puts "I don't know what you mean, try again."
  end
end

def show_students
  print_header
  print_students_list
  print_footer
end

def save_students(filename = 'students.csv')
  CSV.open(filename, 'w') do |row|
    @students.each do |student|
      student_data = [
        student[:name],
        student[:cohort],
        student[:nationality],
        student[:hobby],
        student[:height],
        student[:colour]
      ]
      row << student_data
    end
  end
end

def load_students(filename = 'students.csv')
  CSV.foreach(filename) do |line|
    name, cohort, nationality, hobby, height, colour = line
    student_info(name, cohort, nationality, hobby, height, colour)
  end
  puts "#{@students.count} students have been loaded in total."
end

def specific_file
  puts 'Please choose a file.'
  filename = STDIN.gets.chomp
end

def try_load_students
  filename = ARGV.first
  if filename.nil?
    load_students
  elsif File.exist?(filename)
    load_students(filename)
  else
    puts "Sorry #{filename} doesn't exist."
    exit(1)
  end
end

def input_students
  name = student_input('name').capitalize
  until name.empty?
    cohort = student_input('cohort').capitalize
    until @cohort_month.include?(cohort.capitalize)
      puts "The valid inputs are #{@cohort_month.join(', ')}."
      cohort = student_input('cohort').capitalize
    end
    nationality = student_input('nationality').capitalize
    hobby = student_input('hobby').capitalize
    height = student_input('height (in meters)')
    colour = student_input('favourite colour').capitalize
    student_info(name, cohort, nationality, hobby, height, colour)
    number = @students.count <= 1 ? 'student' : 'students'
    puts "We now have #{@students.count} #{number}."
    puts 'Just hit return to finish, otherwise please enter the name of the next student.'
    name = STDIN.gets.chomp
  end
  @students
end

def student_input(personal_info)
  puts "Please enter the #{personal_info} of the student."
  answer = STDIN.gets.chomp
  answer = 'Not given.' if answer.empty?
  answer
end

def print_header
  puts 'The students of Villains Academy'.center(@line_width)
  puts '-------------'.center(@line_width)
end

def print_students_list
  puts 'Do you want to filter the list of students?'
  filter = STDIN.gets.chomp
  loop do
    if filter == 'no'
      no_filter
      break
    elsif filter == 'yes'
      puts 'What would you like to fiter by?'
      filter_choice
      loop do
        if @filter_by == 'first letter'
          first_letter_filter
          break
        elsif @filter_by == 'name length'
          length_filter
          break
        elsif @filter_by == 'cohort'
          cohort_filter
          break
        else
          filter_choice
        end
      end
      break
    else
      puts 'Please answer "yes" or "no".'
      filter = STDIN.gets.chomp
    end
  end
end

def student_info(name, cohort, nationality, hobby, height, colour)
  @students << {
    name: name,
    cohort: cohort.to_sym,
    nationality: nationality,
    hobby: hobby,
    height: height,
    colour: colour
  }
end

def no_filter
  index = 0
  until index == @students.length
    student = @students[index]
    output(student, index)
    index += 1
  end
end

def filter_choice
  puts 'Please put choose between "first letter", "name length" or "cohort".'
  @filter_by = STDIN.gets.chomp
end

def first_letter_filter
  puts 'Which letter would you like to filter the students name by?'
  first_letter = STDIN.gets.chomp.downcase
  @students_first_letter = []
  @students.each_with_index do |student, index|
    if student[:name].downcase.start_with?(first_letter)
      output(student, index)
      @students_first_letter << student
    end
  end
  number = @students_first_letter.count <= 1 ? 'student' : 'students'
  puts "We have #{@students_first_letter.count} #{number} whose name starts with \"#{first_letter}\"."
end

def length_filter
  puts "How many characters would you like the student's name to be lower than?"
  characters = STDIN.gets.chomp.to_i
  @students_shorter_name = []
  @students.each_with_index do |student, index|
    if student[:name].length < characters
      output(student, index)
      @students_shorter_name << student
    end
  end
  number = @students_shorter_name.count <= 1 ? 'student' : 'students'
  puts "We have #{@students_shorter_name.count} #{number} whose name is shorter than #{characters} characters."
end

def cohort_filter
  puts 'What cohort month would you like?'
  cohort_filter = STDIN.gets.chomp.capitalize
  until @cohort_month.include?(cohort_filter)
    puts "Please enter a valid cohort month. The valid inputs are #{@cohort_month.join(', ')}."
    cohort_filter = STDIN.gets.chomp.capitalize
  end
  cohort_members = []
  @students.each_with_index do |student, index|
    if student[:cohort] == cohort_filter.capitalize.to_sym
      output(student, index)
      cohort_members << student
    end
  end
  number = cohort_members.count <= 1 ? 'student' : 'students'
  puts "We have #{cohort_members.count} #{number} in the #{cohort_filter} cohort."
end

def output(student, index)
  puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort).".center(@line_width)
  puts "Nationality: #{student[:nationality]}.".center(@line_width)
  puts "Hobby: #{student[:hobby]}.".center(@line_width)
  puts "Height (in metres): #{student[:height]}.".center(@line_width)
  puts "Colour: #{student[:colour]}.".center(@line_width)
  puts ''
end

def print_footer
  number = @students.count <= 1 ? 'student' : 'students'
  puts "Overall, we have #{@students.count} great #{number}."
end

try_load_students
interactive_menu
