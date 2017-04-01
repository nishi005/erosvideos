#! ruby -Ku
require "#{Rails.root}/lib/tasks/video_infos_collector.rb"
require "#{Rails.root}/lib/tasks/argument_checker.rb"

class Tasks::ThisavCollector
  include VideoInfosCollector
  include ArgumentChecker

  def registerThisavData
    document = getHtmlDocument(@request_url)
    document.xpath('//div[@class="video_box"]').each do |node|
      img_element = node.css('img')

      #@image_data_list[img_element.attribute('src').text] = ""

      video_url_document = getHtmlDocument(node.css('a').attribute('href').text)
      begin
        @video_infos['video_id'] = video_url_document.xpath('//source')[0].attribute('src').text
      rescue NoMethodError
        puts "未対応のファイル形式です。プログラムを終了します。"
        exit(0)
      end
      @video_infos['video_id'] = node.css('a').attribute('href').text
      @video_infos['title'] = img_element.attribute('alt').text
      @video_infos['video_type'] = 'ThisAV'

      minute = node.css('div')[0].text.split(':')[0]
      hour = minute.to_i / 60
      minute = minute.to_i % 60
      second = node.css('div')[0].text.split(':')[1]
      time = format("%02d", hour.to_s) + ':' + format("%02d", minute.to_s) + ':' + second

      @video_infos['time'] = time.chomp
      @video_infos['thumbnail'] = img_element.attribute('src').text

      registerRecord
    end
    printRegisterRecord
  end

  def self.execute
    ArgumentChecker.checkArguments(ARGV)

    keyword_original = URI.encode(ARGV[0])
    keyword_original << '&for=videos&r=&min=&max='
    search_keyword = ARGV[0]

    ARGV[1].upto(ARGV[2]) do |i|
      puts "#{i}ページ目"
      keyword = keyword_original + "&page=#{i}"
      obj = Tasks::ThisavCollector.new("http://www.thisav.com/search?o=mr&type=&c=0&t=a&query=#{keyword}", search_keyword)
      obj.registerThisavData
    end
  end
end
