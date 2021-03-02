require "./config/environment"
# db.execute "INSERT INTO result_crawler (name, price, details,insert_id) VALUES ('dwadaw', '3243', 'fse',2)"
# db = SQLITE.new().connect
# puts db.execute "SELECT insert_id from result_crawler where insert_id = (SELECT max(insert_id) from result_crawler)"

Cli.new.call

# WEBSITE = "https://magento-test.finology.com.my".freeze
# def detail()
#   @a =[]
#     html = Nokogiri::HTML(HTTParty.get(WEBSITE).body)
#     html.css(".product-item").each_with_index do |element|
#       puts element.at("a").attributes["href"].value
#       puts element.css(".product-item-name").at("a").attributes["title"].value
#       puts element.at("span.price").text
#       puts ""
#       @a.push(element.at("a").attributes["href"].value)
#     end
#   @a.each_with_index do |element|
#     body = Nokogiri::HTML(HTTParty.get(element).body)
#     puts ""
#     puts body.css(".page-title").search(".base").text
#     puts body.css(".product-info-price").search(".price").text
#     puts body.css(".product").search(".value").text
#   end
# end
# detail()

