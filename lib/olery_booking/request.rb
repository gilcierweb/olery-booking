require 'uri'
require 'json'
require 'net/http'
require 'watir'

module OleryBooking
  class Request

    def initialize(search)
      @search = search
    end

    def call

    end

    def run
      data_all = []
      data_all.concat tripadvisor()
      data_all.concat booking()
      data_all.concat holidaycheck()

      puts data_all.inspect
      puts 'Search successfully performed'
    end

    def tripadvisor
      data = []
      browser = Watir::Browser.new
      browser.goto "https://www.tripadvisor.com/Search?q=#{@search}"

      button = browser.button(visible_text: /Search/)
      button.text == 'Search' # => true
      button.click
      link = browser.link(class: 'review_count').href

      browser.close

      data << link.gsub('#REVIEWS', '')
      data
    end

    def booking
      data = []
      browser = Watir::Browser.new
      browser.goto "https://www.booking.com/searchresults.en-gb.html?ss=#{@search}"

      link = browser.link(class: 'e13098a59f').href

      browser.close

      data << link
      data
    end

    def holidaycheck
      data = []
      browser = Watir::Browser.new
      browser.goto "https://www.holidaycheck.de/search-result/?q=#{@search}"

      link = browser.link(class: 'list-item').href

      browser.close

      data << link
      data
    end

    private

    def get_booking(url)
      url_bookings = url
      url = URI(url_bookings)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)

      response = http.request(request)
      bookings = JSON.parse(response.read_body)
      puts bookings.inspect
      return bookings
    end
  end
end
