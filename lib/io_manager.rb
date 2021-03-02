require 'io/console'

class IoManager
  class << self
    BREAKER = '------------------------------------------'.freeze
    SPACER = "\n".freeze
    WEBSITE = "https://magento-test.finology.com.my".freeze

    # /////////////////////////////////
    # works with Cli class to get input
    # ///////////////////////////

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
      puts ''
      puts "List Action\n `start`   - run action show & update together"
      puts '  `update`  - crawling data and save to local database [logs.db]'
      puts '  `show`    - view the most recent updated data'
      puts "List Command\n  `help`  - display this menu"
      puts "  `quit`  - exit program"
      puts ''
      puts 'BY : FEBRIAN DWI PUTRA'
      puts 'febri09494@gmail.com'
      puts ''
    end

    # string for error message of the incorrect input value
    # returns - formatted error message string
    def error_message(input)
      puts "Unknown command `#{input}`. Type `help` if stuck"
    end

    def start
      puts("===== [ACTION: SHOW & UPDATE] =====")
      puts SPACER
      update
      show
    end

    def show
      puts("===== [ACTION: SHOW] =====")
      puts SPACER
      number = 0
      collect_url = []

      puts("===== [GET] Crawling Website =====")
      puts SPACER
      html = Nokogiri::HTML(HTTParty.get(WEBSITE).body)
      html.css(".product-item").each_with_index do |element|
         collect_url.push(element.at("a").attributes["href"].value)
      end
      collect_url.each_with_index do |element|
        body = Nokogiri::HTML(HTTParty.get(element).body)

        title = body.css(".page-title").search(".base").text
        price = body.css(".product-info-price").search(".price").text
        desc = body.css(".product").search(".value").text

        puts BREAKER
        puts "NO: #{number+=1}"
        puts "Name: #{title}"
        puts "Price: #{price}"
        puts "Description: #{desc.delete!("\n")}"
        puts BREAKER
        puts " "
      end
    end

    def update
      puts("===== [ACTION: UPDATE] =====")
      puts SPACER
      db = SQLITE.new.connect

      collect_url = []

      html = Nokogiri::HTML(HTTParty.get(WEBSITE).body)
      puts("===== [GET] Crawling Website =====")
      puts SPACER
      html.css(".product-item").each_with_index do |element|
         collect_url.push(element.at("a").attributes["href"].value)
      end
      puts("===== [PROCESS] Fetch & Save Logs Data =====")
      puts SPACER
      collect_url.each_with_index do |element|
        body = Nokogiri::HTML(HTTParty.get(element).body)

        title = body.css(".page-title").search(".base").text
        price = body.css(".product-info-price").search(".price").text
        desc = body.css(".product").search(".value").text

        insert_query = db.execute "INSERT INTO logs_crawler (name, price, details) VALUES (?,?,?)",title,price,desc
        puts("===== [SUCCESS] The Data Has Been Updated! =====")
        puts SPACER
      end

    end

    # ||||||||||||||||||||||||||||||||||||||||||||||||
    # deals with input for all layers and bad input
    # ||||||||||||||||||||||||||||||||||||||||||||||

    def global_input_layer(input)
      case input
      when 'quit'
        'quit'
      when 'help'
        help
      when 'start'
        start
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

