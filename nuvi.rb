require 'open-uri'
require 'nokogiri'
require 'redis'
require 'zip'

redis = Redis.new
redis.del('NEWS_XML')

base_url = 'http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/'

urls = Nokogiri::HTML(open(base_url))
  .xpath('//a[contains(@href, "zip")]')
  .map { |link| base_url + link.attr('href') }

puts "#{urls.count} archives to publish from #{base_url}"

urls.each_with_index do |url, i|
  puts "Getting [#{i}/#{urls.count}]"
  Zip::File.open(open(url)) do |zip_file|
    print "Publishing #{zip_file.count} entries..."
    zip_file.each do |file|
      redis.rpush('NEWS_XML', file.get_input_stream.read)
    end
    puts "Done"
  end
end
