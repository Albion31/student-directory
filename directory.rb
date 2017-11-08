def input_students
  puts "Please enter the name of the first student."

  name = gets.chomp
  students = []

  while !name.empty? do
    puts "What is the student's country of birth?"
    country = gets.chomp
    puts "What is the student's hobby?"
    hobby = gets.chomp
    puts "What is the student's height in metres?"
    height = gets.chomp
    puts "What is the student's favourite colour?"
    colour = gets.chomp
    students << {name: name,
                 country: country,
                 hobby: hobby,
                 height: height,
                 colour: colour,
                 cohort: :november}
    puts "Now we have #{students.count} students."
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
  students.each_with_index do |student, index|
    puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
  end
end

def print_until(students)
  index = 0
  line_height = 70
  until index == students.length
    puts "#{index + 1}. #{students[index][:name]} (#{students[index][:cohort]} cohort).".center(line_height)
    puts "Country: #{students[index][:country]}.".center(line_height)
    puts "Hobby: #{students[index][:hobby]}.".center(line_height)
    puts "Height (in metres): #{students[index][:height]}.".center(line_height)
    puts "Colour: #{students[index][:colour]}.".center(line_height)
    index += 1
  end
end

def print_first_letter(students)
  puts "Which letter would you like to filter the students name by?"
  first_letter = gets.chomp.downcase
  students_first_letter = []

  students.each_with_index do |student, index|
    if student[:name].downcase.start_with?("#{first_letter}")
      puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
      students_first_letter << student
    end
  end
  puts "We have #{students_first_letter.count} students whose name starts with \"#{first_letter}\"."
end

def print_shorter_name(students)
  puts "How many characters would you like to filter the students name by?"
  characters = gets.chomp.to_i
  students_shorter_name = []

  students.each_with_index do |student, index|
    if student[:name].length < characters
      puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
      students_shorter_name << student
    end
  end
  puts "We have #{students_shorter_name.count} students whose name is shorter than #{characters} characters."
end

def print_footer(students)
  puts "Overall, we have #{students.count} great students."
end

students = input_students
print_header
# print(students)
# print_first_letter(students)
# print_shorter_name(students)
print_until(students)
print_footer(students)
