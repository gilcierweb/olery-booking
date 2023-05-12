require 'uri'
require 'json'
require 'net/http'
require 'watir'
require "erb"

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

      # data_all = ["https://www.tripadvisor.com/Hotel_Review-g188590-d1946024-Reviews-DoubleTree_by_Hilton_Amsterdam_Centraal_Station-Amsterdam_North_Holland_Province.html", "https://www.booking.com/hotel/nl/double-tree-by-hilton-amsterdam-centraal-station.en-gb.html?aid=304142&label=gen173nr-1FCAQoggJCInNlYXJjaF9kb3VibGV0cmVlIGhpbHRvbiBhbXN0ZXJkYW1ICVgEaCCIAQGYAQm4ARnIAQzYAQHoAQH4AQOIAgGoAgO4Apr47KIGwAIB0gIkMzYxZDljOGItMmZhOC00ZWIyLWJhYWYtMGRiNmZmNjY3ODhh2AIF4AIB&ucfs=1&arphpl=1&group_adults=2&req_adults=2&no_rooms=1&group_children=0&req_children=0&hpos=1&hapos=1&sr_order=popularity&srpvid=43812ecdbfb000b7&srepoch=1683700764&from_sustainable_property_sr=1&from=searchresults#hotelTmpl", "https://www.holidaycheck.de/hi/doubletree-by-hilton-amsterdam-centraal-station/8a65ed71-2c3d-343d-9d39-9e8c0211c938"]

      puts data_all.inspect

      template = File.read("#{__dir__}/template.html.erb")

      renderer = ERB.new(template)
      @urls = []
      @urls = data_all.to_a

      File.open("#{__dir__}/result.html", 'w') do |f|
        f.write renderer.result binding
      end

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
