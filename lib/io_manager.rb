require 'io/console'
require "./config/connector"

class IoManager
  class << self
    BREAKER = '------------------------------------------'.freeze

    # works with Cli class to get input
    def parse_layer_input(layer)
      layer.times { print ">" }
      print " "
      input = gets.chomp.downcase
      if layer > 1
        layer -= 1
        parse_layer_input(layer)
      else
        { input: input, layer: layer }
      end
    end

    def print_product_array(array)
      puts BREAKER
      array.each do |element|
        puts element
        puts ''
      end
      puts BREAKER
    end

    def print_single_product(article_string)
      puts "\n" + BREAKER
      puts article_string
      puts BREAKER + "\n\n"
    end

    # ||||||||||||||||||||||||||||||||
    # controller for each command
    # |||||||||||||||||||||||||||||||

    def greeting
      puts 'Running application, type `help` for help and `quit` to exit the program '
    end

    def goodbye
      puts 'Thank you for running the program, goodbye!'
    end

    def help
      puts ''
      puts '
first run the command `update` to retrieve data from the website and see the results that have been executed with the command `show`. Good luck'
      puts ''
      puts "List Action\n  `update`  - crawling data [online] and save to local database [logs.db] for caching"
      puts '  `show`  - view the most recent updated data from the local database to improve crawl performance'
      puts "List Command\n  `help`  - display this menu"
      puts "  `quit`  - exit program"
      puts ''
      puts '@FEBRIAN DWI PUTRA'
      puts ''
    end

    # string for error message of the incorrect input value
    # returns - formatted error message string
    def error_message(input)
      puts "Unknown command `#{input}`. Type `help` if stuck"
    end

    def show
      puts "hello"
    end

    def update
      puts "ano"
    end

    # ||||||||||||||||||||||||||||||||||||||||||||||||
    # deals with input for all layers and bad input
    # returns what was parsed
    # ||||||||||||||||||||||||||||||||||||||||||||||

    def global_input_layer(input)
      case input
      when 'quit'
        'quit'
      when 'help'
        help
      when 'update'
        update
      when 'show'
        show
      else
        error_message(input)
      end
    end

    end
  end

