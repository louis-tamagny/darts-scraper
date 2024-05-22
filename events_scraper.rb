require "selenium-webdriver"
require "csv"

base_url = "https://leaderboard.dartconnect.com/"
csv_file = "events.csv"

# define the browser options
options = Selenium::WebDriver::Chrome::Options.new

# set a custom user agent
user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
options.add_argument("--user-agent=#{user_agent}")

# to run Chrome in headless mode

# options.add_argument("--headless") # comment out in development

# create a driver instance to control Chrome

# with the specified options

driver = Selenium::WebDriver.for :chrome, options: options



# connect to the target page

driver.navigate.to base_url




# wait for rows to be loaded and rendered
sleep(5)

# select all HTML row elements

rows = driver.find_elements(:css, ".listingsRow")

csv_rows = []

rows.map do |row|
  new_row = row.find_elements(:css, "td").map {|el| el.text }
  new_row.delete_at(1)
  new_row[-1] = new_row[-1].gsub(/\s/, ' ')
  new_row.push(row.attribute('data-url'))
  csv_rows.push(new_row)
end

# export the scraped rows to CSV

CSV.open(csv_file, "wb", write_headers: true, headers: ["date", "event name", "501 3DA", "max min", 'url']) do |csv|

  csv_rows.each do |csvrow|

          csv << csvrow

  end

end



# close the browser and release its resources

driver.quit
