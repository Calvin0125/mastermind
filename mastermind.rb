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

# create class for computer and add function for randomly selecting colors
class Computer
    def self.choose_code
        colors = [RED, GREEN, BLUE, YELLOW, PINK, WHITE]
        Array.new(4) {colors.sample}
    end
end

#create player class and add function for guessing
class User
    def self.guess
        user_guess = gets.chomp.downcase
        user_guess = user_guess.gsub("r", RED)
        user_guess = user_guess.gsub("g", GREEN)
        user_guess = user_guess.gsub("b", BLUE)
        user_guess = user_guess.gsub("y", YELLOW)
        user_guess = user_guess.gsub("p", PINK)
        user_guess = user_guess.gsub("w", WHITE)
        return user_guess.split(" ")
    end
end

# function for checking guess
def check_guess(guess, code)
    feedback = []
    already_checked = []
    guess.each_with_index do |color, index|
        if color == code[index]
            feedback.unshift(SMALL_RED)
            already_checked.push(color)
        elsif code.include?(color) && already_checked.count(color) < code.count(color)
            feedback.push(SMALL_WHITE)
            already_checked.push(color)
        end
    end
    return feedback
end


#12 times loop for 12 guesses during game
puts "Choose 4 colors to guess. \nType the colors separated by spaces. \nChoices are red, green, blue, yellow, pink, and white. \nEnter the first letter of each color to select."
code = Computer.choose_code
puts code.join("  ")
12.times do
    user_guess = User.guess
    puts user_guess.join("  ") + "   " + check_guess(user_guess, code).join("  ")
    if user_guess == code
        puts "You Win!!"
        puts code.join("  ")
        break
    end
end
