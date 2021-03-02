require 'io/console'

class IoManager
  class << self
    BREAKER = '------------------------------------------'.freeze
    WEBSITE = "https://magento-test.finology.com.my".freeze

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
      db = SQLITE.new.connect

      number = 0
      array_data = []

      query = db.prepare "SELECT name,price,details from result_crawler where insert_id = (SELECT max(insert_id) from result_crawler)"
      result_query = query.execute

      result_query.each do |row|
        row.each do |data|
          array_data.push(data)
        end
      end

      array_to_str = "#{array_data.join(",")}"
      print array_to_str
      convert_data = array_to_str.split(",").each_slice(3).map{|s|{ name: s[0].to_s, price: s[1].to_s, desc: s[2].to_s }}
      result = convert_data.to_json

      obj = JSON.parse(result)

      obj.each do |data|
        puts BREAKER
        puts "NO: #{number+=1}"
        puts "Name: #{data["name"]}"
        puts "Price: #{data["price"]}"
        puts "Description: #{data["desc"]}"
        puts BREAKER
        puts " "
      end
    end

    def update
      db = SQLITE.new.connect

      get_insert_id = db.execute "SELECT MAX(insert_id) from result_crawler LIMIT 1"
      insert_id = ((get_insert_id.nil?) ? 1 : (get_insert_id.join('').to_i) + 1)

      collect_url = []

      html = Nokogiri::HTML(HTTParty.get(WEBSITE).body)
      puts("===== [GET] Crawling Website =====")
      html.css(".product-item").each_with_index do |element|
         collect_url.push(element.at("a").attributes["href"].value)
      end
      puts("===== [PROCESS] Fetch Data =====")
      collect_url.each_with_index do |element|
        body = Nokogiri::HTML(HTTParty.get(element).body)

        title = body.css(".page-title").search(".base").text
        price = body.css(".product-info-price").search(".price").text
        desc = body.css(".product").search(".value").text

        insert_query = db.execute "INSERT INTO result_crawler (name, price, details, insert_id) VALUES (?,?,?,?)",title,price,desc,insert_id
        puts("===== [SUCCESS] Data Update! =====")
      end

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

