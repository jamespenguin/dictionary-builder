require 'nokogiri'
require 'open-uri'
require 'uri'

module DictionaryBuilder
  module Spanish
    module_function

    BASE_URL = "http://en.wiktionary.org"
    LANGUAGE = "Spanish"
    LOWER_CHARS = ('a'..'z').to_a
    UPPER_CHARS = ('A'..'Z').to_a
    IGNORE_TYPES = ["acronym", "abbr", "prefix", "suffix", "init"]

    def get_page url
      Nokogiri::HTML open(url).read
    rescue
      nil
    end

    def get_full_url path
      URI.join(BASE_URL, path).to_s
    end

    def is_valid_word? word
      return false if word.include? " "
      return false if word.include? "'"
      return false if word.include? "-"
      true
    end

    def extract_words page
      words = []
      page.search("//li").map do | item |
        word = item.at("a")
        type = item.at("i")
        next if type == nil or word == nil
        skip = false
        IGNORE_TYPES.each do | itype |
          skip = true if type.text.include? itype
        end
        next if skip
        word = word.text.downcase
        next if words.include? word
        next if not is_valid_word? word
        words << word
      end
      words
    rescue
      nil
    end

    def retrieve_words_for_lettsr letter
      url = get_full_url "/wiki/Index:#{LANGUAGE}/#{letter}"
      page = get_page url
      extract_words page
    end

    def retrieve_letters_from_index
      letters = []
      url = get_full_url "/wiki/Index:#{LANGUAGE}"
      page = get_page url
      page.search("//a").map do | item |
        next if not item.has_attribute? "title"
        next if not item[:href].include? "/wiki/Index:"
        next if item[:href].include? "#"
        next if item[:href].include? "_"
        next if letters.include? item[:href].split("/")[-1]
        letters << item[:href].split("/")[-1]
      end
      letters.sort
    end

    def retrieve_all_words
      words = []
      retrieve_letters_from_index.each do | letter |
        puts "---#{letter}---"
        words += retrieve_words_for_lettsr letter
      end
      words
    end
  end
end
