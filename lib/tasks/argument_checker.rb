#! ruby -Ku
module ArgumentChecker
  def self.checkArguments(arguments)
    if arguments.size < 3 then
      puts "Usage: cmd [search_keyword] [first_page_num] [last_page_num]"
      exit(0)
    end

    begin
      Integer(arguments[1])
      Integer(arguments[2])
    rescue ArgumentError
      puts "ページ番号は数値で入力してください。"
      exit(0)
    end
  end
end
