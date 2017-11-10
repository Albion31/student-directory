@students = []
@line_width = 70

def print_menu
  puts "1. Input the students."
  puts "2. Show the students."
  puts "3. Save the list to students.csv."
  puts "4. Load the list from students.csv."
  puts "9. Exit."
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def process(selection)
  case selection
    when "1"
      puts "You have chosen to add new students."
      input_students
    when "2"
      puts "You have chosen to show a list of students."
      show_students
    when "3"
      puts "You have chosen to save students."
      save_students(specific_file)
      puts "#{@students.count} students have been saved to the file."
    when "4"
      puts "You have chosen to load students."
      load_students(specific_file)
    when "9"
      exit
    else
      puts "I don't know what you mean, try again."
  end
end

def show_students
  print_header
  print_students_list
  print_footer
end

def save_students(filename = "students.csv")
  file = File.open(filename, "w")
  @students.each do |student|
    student_data = [student[:name],
                    student[:cohort],
                    student[:nationality],
                    student[:hobby],
                    student[:height],
                    student[:colour]]
    csv_line = student_data.join(",")
    file.puts(csv_line)
  end
  file.close
end

def load_students(filename = "students.csv")
  file = File.open(filename, "r")
  file.readlines.each do |line|
    name, cohort, nationality, hobby, height, colour = line.chomp.split(",")
    student_info(name, cohort, nationality, hobby, height, colour)
  end
  puts "#{@students.count} students have been loaded in total."
  file.close

end

def specific_file
  puts "Please choose a file."
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
    exit
  end
end

def input_students
  name = student_input("name").capitalize
  while !name.empty? do
    cohort_month = ["January", "February", "March", "April",
                    "May", "June", "July", "August",
                    "September", "October", "November", "December"]
    cohort = student_input("cohort").capitalize
      while !cohort_month.include?(cohort.capitalize)
        puts "The valid inputs are #{cohort_month.join(", ")}."
        cohort = student_input("cohort").capitalize
      end
    nationality = student_input("nationality").capitalize
    hobby = student_input("hobby").capitalize
    height = student_input("height (in meters)")
    colour = student_input("favourite colour").capitalize
    student_info(name, cohort, nationality, hobby, height, colour)
    @students.count <= 1 ? number = "student" : number = "students"
    puts "We now have #{@students.count} #{number}."
    puts "Just hit return to finish, otherwise please enter the name of the next student."
    name = STDIN.gets.chomp
  end

  @students
end

def student_input(personal_info)
  puts "Please enter the #{personal_info} of the student."
  answer = STDIN.gets.chomp
  if answer.empty?
    answer = "Not given"
  end
  answer
end

def print_header
  puts "The students of Villains Academy".center(@line_width)
  puts "-------------".center(@line_width)
end

def print_students_list
  puts "Do you want to filter the list of students?"
  filter = STDIN.gets.chomp
  while filter != "yes" && filter != "no"
    puts "Please answer yes or no"
    filter = STDIN.gets.chomp
  end
  if filter == "no"
    index = 0

    until index == @students.length
      student = @students[index]
      output(student, index)
      index += 1
    end
  elsif filter == "yes"
    puts "What would you like to fiter by?"
    puts "Please choose between \"first letter\", \"name length\" or \"cohort\""
    filter_by = STDIN.gets.chomp
    while filter_by != "first letter" && filter_by != "name length" && filter_by != "cohort"
      puts "Please put choose between \"first letter\", \"name length\" or \"cohort\""
      filter_by = STDIN.gets.chomp
    end
      if filter_by == "first letter"
        puts "Which letter would you like to filter the students name by?"
        first_letter = STDIN.gets.chomp.downcase
        @students_first_letter = []

        @students.each_with_index do |student, index|
          if student[:name].downcase.start_with?("#{first_letter}")
            output(student, index)
            @students_first_letter << student
          end
        end
          @students_first_letter.count <= 1 ? number = "student" : number = "students"
          puts "We have #{@students_first_letter.count} #{number} whose name starts with \"#{first_letter}\"."
    elsif filter_by == "name length"
        puts "How many characters would you like the student's name to be lower than?"
        characters = STDIN.gets.chomp.to_i
        @students_shorter_name = []

        @students.each_with_index do |student, index|
          if student[:name].length < characters
            output(student, index)
            @students_shorter_name << student
          end
        end
        @students_shorter_name.count <= 1 ? number = "student" : number = "students"
        puts "We have #{@students_shorter_name.count} #{number} whose name is shorter than #{characters} characters."
    elsif filter_by == "cohort"
      cohort_month = ["January", "February", "March", "April",
                      "May", "June", "July", "August",
                      "September", "October", "November", "December"]
      puts "What cohort month would you like?"
      cohort_filter = STDIN.gets.chomp.capitalize
        while !cohort_month.include?(cohort_filter.capitalize)
          puts "Please enter a valid cohort month. The valid inputs are #{cohort_month.join(", ")}."
          cohort_filter = STDIN.gets.chomp.capitalize
        end
      cohort_members = []
      @students.each_with_index do |student, index|
        if student[:cohort] == cohort_filter.capitalize.to_sym
          output(student, index)
          cohort_members << student
        end
      end
      cohort_members.count <= 1 ? number = "student" : number = "students"
      puts "We have #{cohort_members.count} #{number} in the #{cohort_filter} cohort."
    end
  end
end

def student_info(name, cohort, nationality, hobby, height, colour)
    @students << {name: name,
                  cohort: cohort.to_sym,
                  nationality: nationality,
                  hobby: hobby,
                  height: height,
                  colour: colour
                 }
end

def output(student, index)
  puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort).".center(@line_width)
  puts "Nationality: #{student[:nationality]}.".center(@line_width)
  puts "Hobby: #{student[:hobby]}.".center(@line_width)
  puts "Height (in metres): #{student[:height]}.".center(@line_width)
  puts "Colour: #{student[:colour]}.".center(@line_width)
  puts ""
end

def print_footer
  @students.count <= 1 ? number = "student" : number = "students"
    puts "Overall, we have #{@students.count} great #{number}."
end

try_load_students
interactive_menu
