def input_students
  puts "Please enter the names fo the students"
  puts "To finish, just hit return twice"

  students = []
  name = gets.chomp

  while !name.empty? do
    students << {name: name, cohort: :november}
    puts "Now we have #{students.count} students"
    name = gets.chomp
  end

  students
end

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print(students)
  students.each_with_index do |student, index|
    puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
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
  puts "We have #{students_first_letter.count} students whose name start with \"#{first_letter}\"."
end

def print_footer(students)
  puts "Overall, we have #{students.count} great students."
end

students = input_students
print_header
# print(students)
print_first_letter(students)
print_footer(students)
