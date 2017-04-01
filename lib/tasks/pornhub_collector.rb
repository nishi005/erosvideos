#! ruby -Ku
require "#{Rails.root}/lib/tasks/video_infos_collector.rb"
require "#{Rails.root}/lib/tasks/argument_checker.rb"

class Tasks::PornhubCollector
  include VideoInfosCollector
  include ArgumentChecker

  def registerPornhubData
    id = @current_id + 1
    begin
      document = getHtmlDocument(@request_url)
      video_info_nodes = document.search('//div[@class="phimage"]')
      image_nodes = document.search('//img[contains(@class,"js-videoThumb js-videoThumbFlip thumb")]')
      p video_info_nodes.size
      p image_nodes.size
    end while video_info_nodes.size != image_nodes.size

    video_info_nodes.each do |node|

      @video_infos['id'] = id
      @video_infos['video_id'] = node.css('a').attribute('href').text.split('=')[1]
      @video_infos['title'] = node.css('a').attribute('title').text
      @video_infos['video_type'] = 'pornhub'
      @video_infos['total_number_of_views'] = 0
      @video_infos['good'] = 0
      @video_infos['bad'] = 0
      @video_infos['time'] = node.css('var')[0].text

      minute = node.css('var')[0].text.split(':')[0]
      hour = minute.to_i / 60
      minute = minute.to_i % 60
      second = node.css('var')[0].text.split(':')[1]
      time = format("%02d", hour.to_s) + ':' + format("%02d", minute.to_s) + ':' + second

      @video_infos['time'] = time

      registerRecord
      id += 1
    end

    image_nodes.each do |node|
      img_element = node.attribute('data-mediumthumb')
      if img_element == nil then
        img_element = node.attribute('data-image')
      end

      @image_data_list[img_element.text] = ""
    end

    printRegisterRecord

    setImageData
    saveThumbnailImage
  end

  def self.execute
    ArgumentChecker.checkArguments(ARGV)

    keyword_original = URI.encode(ARGV[0])
    search_keyword = ARGV[0].gsub("+", " ")

		ARGV[1].upto(ARGV[2]) do |i|
      puts "#{i}ページ目"
      keyword = keyword_original + "&page=#{i}"
      obj = Tasks::PornhubCollector.new("http://jp.pornhub.com/video/search?search=#{keyword}", ARGV[3], search_keyword)
      obj.registerPornhubData
    end
  end
end
