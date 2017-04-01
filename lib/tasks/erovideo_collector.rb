#! ruby -Ku
require "#{Rails.root}/lib/tasks/video_infos_collector.rb"
require "#{Rails.root}/lib/tasks/argument_checker.rb"
require 'kconv'

class Tasks::ErovideoCollector
  include VideoInfosCollector
  include ArgumentChecker

  def registerErovideoData
    puts @request_url
    document = getHtmlDocument(@request_url)

    document.xpath('//div[@class="da-zoom-normal"]').each do |node|
      img_element = node.css('img')
      #@image_data_list[img_element.attribute('src').text] = ""

      @video_infos['video_id'] = node.css('a').attribute('moviecode').text
      @video_infos['title'] = img_element.attribute('alt').text
      @video_infos['video_type'] = 'erovideo'

      minute = node.css('span')[1].text.split(':')[0]
      hour = minute.to_i / 60
      minute = minute.to_i % 60
      second = node.css('span')[1].text.split(':')[1]
      time = format("%02d", hour.to_s) + ':' + format("%02d", minute.to_s) + ':' + second

      @video_infos['time'] = time
      @video_infos['thumbnail'] = img_element.attribute('src').text

      registerRecord
    end

    printRegisterRecord
  end

  def self.execute
    ArgumentChecker.checkArguments(ARGV)

    keyword_original = URI.encode(ARGV[0])
    search_keyword = ARGV[0].split('&')[0]

    url = 'http://ero-video.net/?q=&oq='

    if ARGV[3] == 'false' then
      url = 'http://ero-video.net/?q='
    end

    ARGV[1].upto(ARGV[2]) do |i|
      puts "#{i}ページ目"
      keyword = keyword_original + "&mosaiced=1" + "&page=#{i}"
      obj = Tasks::ErovideoCollector.new("#{url}#{keyword}", search_keyword)
      obj.registerErovideoData
    end
  end
end
