#! ruby -Ku
require 'rubygems'
require 'open-uri'
require 'openssl'
require 'nokogiri'
require 'httpclient'

class Batch
  def self.execute
    url = 'https://xhamster.com/search.php?from=&q=japanese&qcat=video'
    client = HTTPClient.new
    client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
    puts client.get(URI.parse(url)).body
  end
end

Batch.execute
