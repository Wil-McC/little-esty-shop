# require "json"
# require "faraday"

class DateService

  def self.upcoming
    get_data('https://date.nager.at/Api/v2/NextPublicHolidays/US')
  end

  def self.upcoming_three
    # out = upcoming.first(3)
  end

  def self.get_data(url)
    response = Faraday.get(url)
    # do |req|
      # req.headers['Authorization'] = "token #{ENV['github_token']}"
    # end
    data = response.body
    JSON.parse(data, symbolize_names: true)
  end
end

# <% DateService.upcoming_three.each do |holiday| %>
  # <p><%= holiday[:localName] %> - <%= holiday[:date] %></p>
# <% end %>
