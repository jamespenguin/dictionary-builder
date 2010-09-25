require 'nokogiri'
require 'open-uri'

module DictionaryBuilder
  module English
    module_function

    LOWER_CHARS = ('a'..'z').to_a
    UPPER_CHARS = ('A'..'Z').to_a
    IGNORE_TYPES = ["abbr", "prefix", "suffix", "init"]

    def get_page url
      Nokogiri::HTML open(url).read
    rescue
      nil
    end

    def is_valid_word? word
      return false if word.include? " "
      return false if word.include? "'"
      return false if word.include? "-"
      word.each_char do | char |
        return false if not LOWER_CHARS.include? char and not UPPER_CHARS.include? char
      end
      true
    end

    def extract_words page
      words = []
      page.search("//li").map do | item |
        word = item.at("a")
        type = item.at("i")
        next if type == nil or word == nil
        next if IGNORE_TYPES.include? type.text
        next if not is_valid_word? word.text
        words << word.text
      end
      words
    rescue
      nil
    end

    def retrieve_words_for_lettsr letter
      url = "http://en.wiktionary.org/wiki/Index:English/#{letter}"
      page = get_page url
      extract_words page
    end

    def retrieve_all_words
      words = []
      ('a'..'z').to_a.each do | letter |
        puts "---#{letter}---"
        words += retrieve_words_for_lettsr letter
      end
      words
    end
  end
end
