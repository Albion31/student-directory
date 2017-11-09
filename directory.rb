@students = []
@line_width = 70



def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def print_menu
  puts "1. Input the students."
  puts "2. Show the students."
  puts "3. Save the list to students.csv."
  puts "4. Load the list from students.csv."
  puts "9. Exit."
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
    when "9"
      exit
    else
      puts "I don't know what you meant, try again."
  end
end

def show_students
  print_header
  print_students_list
  print_footer
end

def save_students
  file = File.open("students.csv", "w")
  @students.each do |student|
    student_data = [student[:name],
                    student[:cohort],
                    student[:country],
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
    name, cohort, country, hobby, height, colour = line.chomp.split(",")
    @students << {name: name,
                  cohort: cohort.to_sym,
                  country: country,
                  hobby: hobby,
                  height: height,
                  colour: colour
                 }
  end
  file.close
end

def try_load_students
  filename = ARGV.first
  return if filename.nil?
  if File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else
    puts "Sorry #{filename} doesn't exist"
    exit
  end
end

def input_students
  puts "Please enter the name of the first student."
  name = STDIN.gets.capitalize.delete("\n")

  while !name.empty? do
    cohort_month = ["January", "February", "March", "April",
                    "May", "June", "July", "August",
                    "September", "October", "November", "December"]
    puts "What is the student's cohort month?"
    cohort = STDIN.gets.chomp.capitalize
      while !cohort_month.include?(cohort.capitalize)
        puts "Please enter a valid cohort month. The valid inputs are #{cohort_month.join(", ")}."
        cohort = STDIN.gets.chomp.capitalize
      end
    puts "What is the student's country of birth?"
    country = STDIN.gets.chomp.capitalize
      if country.empty?
        country = "N/A"
      end
    puts "What is the student's hobby?"
    hobby = STDIN.gets.chomp.capitalize
      if hobby.empty?
        hobby = "N/A"
      end
    puts "What is the student's height in metres?"
    height = STDIN.gets.chomp
      if height.empty?
        height = "N/A"
      end
    puts "What is the student's favourite colour?"
    colour = STDIN.gets.chomp.capitalize
      if colour.empty?
        colour = "N/A"
      end
    @students << {name: name,
                  cohort: cohort.to_sym,
                  country: country,
                  hobby: hobby,
                  height: height,
                  colour: colour
                 }
    @students.count <= 1 ? number = "student" : number = "students"
    puts "Now we have #{@students.count} #{number}."
    puts "Please enter the name of the next student."
    puts "To finish, just hit return twice."
    name = STDIN.gets.chomp
  end

  @students
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

def output(student, index)
  puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort).".center(@line_width)
  puts "Country: #{student[:country]}.".center(@line_width)
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
