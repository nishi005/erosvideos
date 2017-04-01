#! ruby -Ku
require "#{Rails.root}/lib/tasks/video_infos_collector.rb"
require "#{Rails.root}/lib/tasks/argument_checker.rb"

class Tasks::XvideosCollector
	include VideoInfosCollector
  include ArgumentChecker

	def	registerXvideosData
		id = @current_id + 1
		puts @request_url
		document = getHtmlDocument(@request_url)

		results = document.content.scan(/<a href="[\w\/]*"><img src="[\w\/\-\.\:]*/).uniq

		results.each_with_index do |result, i|
			tmp = result.split('/')
			if tmp[2] == 'THUMBNUM' then
				next
			end

			@image_data_list[result.split('"')[3]] = ""
			title = tmp[2].split('"')[0]

			@video_infos['id'] = id
			@video_infos['video_id'] = tmp[1]
			@video_infos['title'] = title
			@video_infos['video_type'] = "xvideos"
			@video_infos['total_number_of_views'] = 0
			@video_infos['good'] = 0
			@video_infos['bad'] = 0
			@video_infos['time'] = document.xpath('//span[@class="bg"]')[i].css('strong')[0].text
			puts @video_infos
			#registerRecord
			id += 1
		end

		#printRegisterRecord

		#setImageData
		#saveThumbnailImage

	end

  def self.execute
		ArgumentChecker.checkArguments(ARGV)

		keyword_original = URI.encode(ARGV[0])
		search_keyword = ARGV[0].gsub("+", " ")

		ARGV[1].upto(ARGV[2]) do |i|
      puts "#{i}ページ目"
      keyword = keyword_original + "&p=#{i}"
      obj = Tasks::XvideosCollector.new("https://www.xvideos.com/?k=#{keyword}", ARGV[3], search_keyword)
      obj.registerXvideosData
    end
  end
end
