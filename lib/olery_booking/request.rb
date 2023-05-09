module OleryBooking
  class Request

    def initialize(urls)
      @urls = urls
    end

    def call

    end

    def run
      data_url = ['http://www.tripadvisor.com/Hotel_Review-g188590-d1946024-Reviews-DoubleTree_by_Hilton_Hotel_Amsterdam_Centraal_Station-Amsterdam_North_Holland_Province.html',
                  'https://www.booking.com/hotel/nl/double-tree-by-hilton-ams terdam-centraal-station.en-gb.html',
                  'https://www.holidaycheck.de/hi/doubletree-by-hilton-hotel-amsterdam-centraal-station/8a65ed71-2c3d-343d-9d39-9e8c0211'
      ]
      @urls.each do |url|

      end
    end

    def tripadvisor
      get_booking(url)
    end

    def booking
      get_booking(url)
    end

    def holidaycheck
      get_booking(url)
    end

    private

    def get_booking(url)
      url_bookings = url
      url = URI(url_bookings)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)

      response = http.request(request)

      return JSON.parse(response.read_body)
    end
  end
end