#! ruby -Ku
require "#{Rails.root}/lib/tasks/video_infos_collector.rb"
require "#{Rails.root}/lib/tasks/argument_checker.rb"

class Tasks::SharemovieCollector
  include VideoInfosCollector
  include ArgumentChecker

  def registerSharemovieData
    document = getHtmlDocument(@request_url)

    document.xpath('//article[contains(@id,"mylist_")]').each do |node|
      if node.css('p[@class="tag"]') != nil then
        next puts '無修正動画です。登録は行いません。' if node.css('p[@class="tag"]').text.include?('無修正')
      end
      @video_infos['video_id'] = node.css('a').attribute('href').text.split('/')[2]
      @video_infos['title'] = node.css('img').attribute('alt').text
      @video_infos['video_type'] = 'SHARE MOVIE'
      @video_infos['time'] = node.css('time')[0].text
      @video_infos['thumbnail'] = 'http://img1.smv.to/' + @video_infos['video_id'] + '/thumbnail_13.jpg'

      registerRecord
    end
    printRegisterRecord
  end

  def self.execute
    ArgumentChecker.checkArguments(ARGV)

    keyword_original = URI.encode(ARGV[0])
    keyword_original << '&x=0&y=0&reject=&opened=0&time=0'
    search_keyword = ARGV[0]

    puts keyword_original

    ARGV[1].upto(ARGV[2]) do |i|
      puts "#{i}ページ目"
      keyword = keyword_original + "&page=#{i}"
      obj = Tasks::SharemovieCollector.new("http://smv.to/search/?keyword=#{keyword}", search_keyword)
      obj.registerSharemovieData
    end
  end
end
