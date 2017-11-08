def input_students
  puts "Please enter the name of the first student."
  name = gets.capitalize.delete("\n")
  students = []

  while !name.empty? do
    cohort_month = ["January", "February", "March", "April",
                    "May", "June", "July", "August",
                    "September", "October", "November", "December"]
    puts "What is the student's cohort month?"
    cohort = gets.chomp.capitalize
      while !cohort_month.include?(cohort.capitalize)
        puts "Please enter a valid cohort month. The valid inputs are #{cohort_month.join(", ")}."
        cohort = gets.chomp.capitalize
      end
    puts "What is the student's country of birth?"
    country = gets.chomp.capitalize
      if country.empty?
        country = "N/A"
      end
    puts "What is the student's hobby?"
    hobby = gets.chomp.capitalize
      if hobby.empty?
        hobby = "N/A"
      end
    puts "What is the student's height in metres?"
    height = gets.chomp
      if height.empty?
        height = "N/A"
      end
    puts "What is the student's favourite colour?"
    colour = gets.chomp.capitalize
      if colour.empty?
        colour = "N/A"
      end
    students << {name: name,
                 country: country,
                 hobby: hobby,
                 height: height,
                 colour: colour,
                 cohort: cohort.to_sym}
      if students.count <= 1
        puts "Now we have #{students.count} student."
      else
        puts "Now we have #{students.count} students."
      end
    puts "Please enter the name of the next student."
    puts "To finish, just hit return twice."
    name = gets.chomp
  end

  students
end

def print_header
  line_height = 70
  puts "The students of Villains Academy".center(line_height)
  puts "-------------".center(line_height)
end

def print(students)
  line_height = 70
  puts "Do you want to filter the list of students?"
  filter = gets.chomp
  while filter != "yes" && filter != "no"
    puts "Please answer yes or no"
    filter = gets.chomp
  end
  if filter == "no"
    index = 0

    until index == students.length
      student = students[index]
      output(student, index)
      index += 1
    end
  elsif filter == "yes"
    puts "What would you like to fiter by?"
    puts "Please choose between \"first letter\", \"name length\" or \"cohort\""
    filter_by = gets.chomp
    while filter_by != "first letter" && filter_by != "name length" && filter_by != "cohort"
      puts "Please put choose between \"first letter\", \"name length\" or \"cohort\""
      filter_by = gets.chomp
    end
      if filter_by == "first letter"
        puts "Which letter would you like to filter the students name by?"
        first_letter = gets.chomp.downcase
        students_first_letter = []

        students.each_with_index do |student, index|
          if student[:name].downcase.start_with?("#{first_letter}")
            output(student, index)
            students_first_letter << student
          end
        end
          if students_first_letter.count <= 1
            puts "We have #{students_first_letter.count} student whose name starts with \"#{first_letter}\"."
          else
            puts "We have #{students_first_letter.count} students whose name starts with \"#{first_letter}\"."
          end
    elsif filter_by == "name length"
        puts "How many characters would you like the student's name to be lower than?"
        characters = gets.chomp.to_i
        students_shorter_name = []

        students.each_with_index do |student, index|
          if student[:name].length < characters
            output(student, index)
            students_shorter_name << student
          end
        end
        if students_shorter_name.count <= 1
          puts "We have #{students_shorter_name.count} student whose name is shorter than #{characters} characters."
        else
          puts "We have #{students_shorter_name.count} students whose name is shorter than #{characters} characters."
        end
    elsif filter_by == "cohort"
      cohort_month = ["January", "February", "March", "April",
                      "May", "June", "July", "August",
                      "September", "October", "November", "December"]
      puts "What cohort month would you like?"
      cohort_filter = gets.chomp.capitalize
        while !cohort_month.include?(cohort_filter.capitalize)
          puts "Please enter a valid cohort month. The valid inputs are #{cohort_month.join(", ")}."
          cohort_filter = gets.chomp.capitalize
        end
      cohort_members = []
      students.each_with_index do |student, index|
        if student[:cohort] == cohort_filter.capitalize.to_sym
          output(student, index)
          cohort_members << student
        end
      end
      if cohort_members.count <= 1
        puts "We have #{cohort_members.count} student in the #{cohort_filter} cohort."
      else
        puts "We have #{cohort_members.count} students in the #{cohort_filter} cohort."
      end
    end
  end
end

def output(student, index)
  line_height = 70
  puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort).".center(line_height)
  puts "Country: #{student[:country]}.".center(line_height)
  puts "Hobby: #{student[:hobby]}.".center(line_height)
  puts "Height (in metres): #{student[:height]}.".center(line_height)
  puts "Colour: #{student[:colour]}.".center(line_height)
  puts ""
end

def print_footer(students)
  if students.count <= 1
    puts "Overall, we have #{students.count} great student."
  else
    puts "Overall, we have #{students.count} great students."
end
end

students = input_students
students.count >= 1 ? print_header : nil
students.count >= 1 ? print(students) : nil
students.count >= 1 ? print_footer(students) : nil
