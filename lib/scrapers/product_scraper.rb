class ProductScraper
  WEBSITE = "https://news.ycombinator.com".freeze
  class << self
    # scrape website for aricles on a given page
    # returns hash of formatted posts
    def scrape_posts(news_route)
      news_url = WEBSITE + news_route
      html = Nokogiri::HTML(HTTParty.get(news_url).body)
      posts = []
      # `subtexts` is an array of all the gray text under the article links
      # they match up 1-1 with the number of `.athing`s, so the `i` var in
      # the w/ index block matches that article's  subtext
      subtexts = html.css(".subtext")
      html.css(".athing").each_with_index do |post, i|
        post_values = scrape_posts_helper(post)
        scrape_posts_helper_subtexts(post_values, subtexts[i])
        posts << post_values
      end
      NewsPage.new(page_link: news_url, posts: posts)
    end

  # helper methods to initialize the Product object
  private

    def scrape_posts_helper(post)
      post_id = post.attributes["id"].value
      Product.new(
        post_id: post_id,
        external_link: post.css(".title a")[0].attributes["href"].value,
        title: post.css(".storylink").text,
        comments_link: WEBSITE + "/item?id=#{post_id}"
      )
    end

    def scrape_posts_helper_subtexts(post_values, subtext)
      only_number = /^(\d+)/
      number = subtext.css("a").last.children.text
      count = number == "discuss" ? 0 : only_number.match(number).to_s
      post_values.add_subtext(
        post_author: subtext.css(".hnuser").text,
        points: only_number.match(subtext.css(".score").text).to_s,
        comment_count: count
      )
    end
  end
end
