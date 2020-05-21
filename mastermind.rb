require 'colorize'

#constants for colored circles
RED = "\u2B24".red
GREEN = "\u2B24".green
BLUE = "\u2B24".cyan
YELLOW = "\u2B24".yellow
PINK = "\u2B24".magenta
WHITE = "\u2B24".white
SMALL_RED = "\u25CF".red
SMALL_WHITE = "\u25CF".white

# create class for computer and add function for randomly selecting colors and computer guess
class Computer
    def self.choose_hard_code
        colors = [RED, GREEN, BLUE, YELLOW, PINK, WHITE]
        Array.new(4) {colors.sample}
    end
    def self.choose_easy_code
        colors = [RED, GREEN, BLUE, YELLOW, PINK, WHITE]
        colors.sample(4)
    end
    def self.guess
        colors = [RED, GREEN, BLUE, YELLOW, PINK, WHITE]
        Array.new(4) {colors.sample}
    end
end

#create player class and add function for guessing
class User
    def self.guess
        user_guess = gets.chomp.downcase
        while user_guess !~ /\A[rgbypw]\s[rgbypw]\s[rgbypw]\s[rgbypw]\z/ do
            puts "Enter the first letter of each color separated by spaces."
            user_guess = gets.chomp.downcase
        end
        user_guess = user_guess.gsub("r", RED)
        user_guess = user_guess.gsub("g", GREEN)
        user_guess = user_guess.gsub("b", BLUE)
        user_guess = user_guess.gsub("y", YELLOW)
        user_guess = user_guess.gsub("p", PINK)
        user_guess = user_guess.gsub("w", WHITE)
        return user_guess.split(" ")
    end
    def self.choose_code
        puts "Choose your code for the computer to guess. \nEnter the first letter of each color separated by spaces."
        code = gets.chomp.downcase
        while code !~ /\A[rgbypw]\s[rgbypw]\s[rgbypw]\s[rgbypw]\z/ do
            puts "Enter the first letter of each color separated by spaces."
            code = gets.chomp.downcase
        end
        code = code.gsub("r", RED)
        code = code.gsub("g", GREEN)
        code = code.gsub("b", BLUE)
        code = code.gsub("y", YELLOW)
        code = code.gsub("p", PINK)
        code = code.gsub("w", WHITE)
        return code.split(" ")
    end
end

# function for checking guess
# global variable to use in Computer class for improving Computer guesses
$feedback = []
def check_guess(guess, code)
    $feedback = []
    already_checked = []
    guess.each_with_index do |color, index|
        if color == code[index]
            $feedback.unshift(SMALL_RED)
            already_checked.push(color)
            if already_checked.count(color) > code.count(color)
                $feedback.delete_at($feedback.index(SMALL_WHITE))
            end
        elsif code.include?(color) && already_checked.count(color) < code.count(color)
            $feedback.push(SMALL_WHITE)
            already_checked.push(color)
        end
    end
    return $feedback
end


#choose difficulty
def choose_difficulty    
    puts "Choose hard (duplicate colors allowed) or easy (no duplicate colors). \nType 'h' or 'e' to choose."
    difficulty = gets.chomp.downcase
    while difficulty !~ /\A[he]\z/ do
        puts "Type 'h' or 'e' to choose difficulty."
        difficulty = gets.chomp.downcase
    end
    puts "Choose 4 colors to guess. \nChoices are red, green, blue, yellow, pink, and white. \nEnter the first letter of each color separated by spaces to select."
    if difficulty == "h"
        code = Computer.choose_hard_code
    elsif difficulty == "e"
        code = Computer.choose_easy_code
    end
    return code
end

#guess computers code
def player_guess(code)   
    accumulator = 0
    12.times do
        user_guess = User.guess
        puts user_guess.join("  ") + "   " + check_guess(user_guess, code).join("  ")
        if user_guess == code
            puts "You Win!!"
            puts code.join("  ")
            break
        end
        accumulator += 1
        if accumulator == 12
            puts "The code was #{code.join("  ")}. \nYou Lost."
        end
    end
end

#computer guesses players code
def computer_guess(code)
    accumulator = 0
    computer_guess = Computer.guess
    12.times do
        computer_guess = computer_guess.sample($feedback.length)
        while computer_guess.length < 4 do
            computer_guess.push(Computer.guess.sample(1)[0])
        end
        puts computer_guess.join("  ") + "   " + check_guess(computer_guess, code).join("  ")
        if computer_guess == code
            puts "The computer guessed your code. You lose."
            break
        end
        accumulator += 1
        if accumulator == 12
            puts "The computer couldn't guess your code. You win!"
        end
    end
end
#choose if making code or guessing code
puts "Type 'm' to make a code and 'g' to guess a code."
choice = gets.chomp.downcase
while choice !~ /\A[mg]\z/ do
    puts "Type 'm' to make a code and 'g' to guess a code."
    choice = gets.chomp.downcase
end
if choice == 'g'
    computer_code = choose_difficulty
    player_guess(computer_code)
elsif choice == 'm'
    player_code = User.choose_code
    puts "Your code is #{player_code.join("  ")}"
    computer_guess(player_code)
end

