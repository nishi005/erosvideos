#! ruby -Ku
require "#{Rails.root}/app/models/video_info"
require 'rubygems'
require 'open-uri'
require 'openssl'
require 'nokogiri'
require 'httpclient'

class VideoInfoCollector

  attr_accessor :current_id

  def initialize
    @request_url = "https://xhamster.com/search.php?from=&q=japanese&qcat=video"
    @current_id = getCurrentId.to_i
    @video_infos = Hash.new
    @image_data_list = Hash.new
    @client = HTTPClient.new
  end

  def getHtml
    res = @client.get(URI.parse(@request_url))
    return res.body
  end

  def registerRecord
		@video_info = VideoInfo.new(@video_infos)
		if @video_info.save then
			puts "データの登録に成功しました"
		else
			puts "データの登録に失敗しました"
		end
	end

  def registerXhamsterData
    id = @current_id + 1
    body = getHtml
    results = body.scan(/div class="video"><a href="[\w\/\-\.\:]*" class="hRotator"><img src='[\w\/\-\.\:]*' class='thumb' alt="[\w\s]*"/)

    results.each do |result|
      video_id = result.split('/')[4]
      img_url = result.split("'")[1]
      title = result.split('alt=')[1]
      title.gsub!('"', "")

      @image_data_list[img_url] = ""

      @video_infos['id'] = id
      @video_infos['video_id'] = video_id
      @video_infos['title'] = title
      @video_infos['video_type'] = "xhamster"
      @video_infos['total_number_of_views'] = 0
      @video_infos['good'] = 0
      @video_infos['bad'] = 0

      registerRecord
      id += 1
    end
    p @image_data_list
    setImageData
    saveThumbnailImage
  end

  def saveThumbnailImage
    id = @current_id + 1
    @image_data_list.each do |key, val|
      open("images/#{id}.jpg", "wb") do |file|
        file.write(@image_data_list[key])
      end
      id += 1
    end
    @current_id = id - 1
#    setCurrentId
  end

  def setImageData
    @image_data_list.each do |key, val|
      @image_data_list[key] = @client.get(key).body
    end
  end

  def setCurrentId
		open("current_id.txt", "w:UTF-8") do |file|
			file.write(@current_id)
		end
	end

  def getCurrentId
    open("current_id.txt", "r:UTF-8") do |file|
      return file.read
    end
  end

end

class XhamsterCollector
  def self.execute
    obj = VideoInfoCollector.new
    obj.registerXhamsterData
  end
end

XhamsterCollector.execute
