#! ruby -Ku
require "#{Rails.root}/lib/tasks/video_infos_collector.rb"
require "#{Rails.root}/lib/tasks/argument_checker.rb"

class Tasks::TokyotubeCollector
  include VideoInfosCollector
  include ArgumentChecker

  #指定されたURLのドキュメントオブジェクトを取得 -オーバーライド
  def getHtmlDocument(url)
    charset = nil
    html = open(@request_url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE, "Accept-Encoding" => "utf-8") do |file|
      charset = file.charset
      file.read
    end

    return Nokogiri::HTML.parse(html, nil, charset)
  end

  def registerTokyotubeData
    puts @request_url
    document = getHtmlDocument(@request_url)

    document.xpath('//div[contains(@class,"postBox hls0")]').each do |node|
      a_element = node.css('a')
      img_element = node.css('img')

      if a_element.size == 0 || img_element == 0 then
        next
      end

      href_element =  a_element.attribute('href').text.split('/')
      src_element = img_element.attribute('src').text

      next if href_element[0].include?('http')

      #@image_data_list[src_element] = ""
      #@image_data_list['aaa'] = ""

      @video_infos['video_id'] = href_element[2]
      @video_infos['title'] = href_element[3]
      @video_infos['video_type'] = 'TokyoTube'
      @video_infos['time'] = node.css('span')[0].text
      @video_infos['thumbnail'] = src_element

      registerRecord
    end
    printRegisterRecord
  end

  def self.execute
    ArgumentChecker.checkArguments(ARGV)

    keyword_original = URI.encode(ARGV[0])
    search_keyword = ARGV[0]

		ARGV[1].upto(ARGV[2]) do |i|
      puts "#{i}ページ目"
      keyword = keyword_original + "&page=#{i}"
      obj = Tasks::TokyotubeCollector.new("http://www.tokyo-tube.com/search?search_type=videos&search_query=#{keyword}", ARGV[3], search_keyword)
      obj.registerTokyotubeData
    end
  end
end
