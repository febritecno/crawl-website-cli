class Product
  attr_reader :product_id, :product_name, :price, :product_details

  def initialize(product_id:, product_name:, price:, product_details:)
    @post_id = product_id
    @product_name = product_name
    $price = price
    @product_details = product_details
  end

  # returns a single product
  def product_info
    "Name: #{@product_name}\n  comments: #{@comment_count}"
  end

  # returns all info on a single article
  def long_article_info
    external_link = @external_link
    author = "by #{@post_author}"
    "#{@title} (#{domain(@external_link)})\n #{author} | points: #{
      @points} | comments: #{@comment_count}\n Link: #{external_link}"
  end
end
