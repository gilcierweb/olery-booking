module OleryBooking
  module InputHelper
    def self.gets
      if ARGV.nil?
        Kernel.gets
      else
        STDIN.gets
      end
    end
  end
end