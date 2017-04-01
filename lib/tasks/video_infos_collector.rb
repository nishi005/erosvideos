#! ruby -Ku
require "#{Rails.root}/app/models/video_info"
require 'rubygems'
require 'open-uri'
require 'openssl'
require 'nokogiri'
require 'httpclient'

module VideoInfosCollector
  attr_accessor :request_url, :video_infos
  def initialize(url, keyword)
    @video_id = 0
    @keyword = keyword
    @request_url = url
    @client = HTTPClient.new
    @video_infos = Hash.new
    @video_infos_list = Array.new
    @register_record_num = 0
    @history = Array.new
  end

  #ハッシュで受け取ったデータをデータベースに登録
  def registerRecord
    if @video_infos['title'] =~ /無碼|【無】|\(無\)|「無」|\（無\）|\[無\]|無臭|無修/ then
      puts '無修正動画です。登録は無効です。'
      return
    end

    if @history.include?(@video_infos['title'])
      puts '登録済の動画です。登録は無効です。'
      return
    end

    @video_info = VideoInfo.new(@video_infos)

    ActiveRecord::Base.transaction do
      if @video_info.save! then
        puts "データの登録に成功しました"
      else
        puts "データの登録に失敗しました"
      end

      @video_tag = VideoTag.new({:video_id => @video_info.id, :tag => @video_infos['video_type']})
      @video_tag2 = VideoTag.new({:video_id => @video_info.id, :tag => @keyword})

      if @video_tag.save! && @video_tag2.save! then
        puts "タグの登録に成功しました"
      else
        puts "タグの登録に失敗しました"
      end
    end
    puts "データベースの更新に成功しました"
    @register_record_num += 1
    @history << @video_infos['title']
    rescue ActiveRecord::RecordInvalid => e
    puts "データベースの更新に失敗しました。ロールバックします。"
    puts e.message

  end

  #指定されたURLのHTMLデータを取得
  def getHttpData(url)
    return @client.get(URI.parse(url)).body
  end

  #指定されたURLのドキュメントオブジェクトを取得
  def getHtmlDocument(url)
    charset = nil
    html = open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |file|
      charset = file.charset
      file.read
    end

    if charset == 'iso-8859-1' then
      charset = 'utf-8'
    end

    return Nokogiri::HTML.parse(html, nil, charset)
  end

  #登録レコード数の表示
  def printRegisterRecord
    puts "登録レコード件数：#{@register_record_num}"
    puts "開始位置：#{@current_id}"
  end
end
