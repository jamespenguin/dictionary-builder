require 'ap'
require_relative 'dictionary_builder'

desc "Build dictionary list of English words"
task "build-dictionary" do
  e = DictionaryBuilder::English
  f = open("dict", "w")
  f.puts e.retrieve_all_words
  f.close
end

task :default do
  puts "snAAAaaaakess"
end
