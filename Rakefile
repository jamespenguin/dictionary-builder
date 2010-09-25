require_relative 'dictionary_builder'

desc "Build dictionary list of English words"
task "build-dictionary" do
  e = DictionaryBuilder::English
  f = open("dictionaries/dict-english", "w")
  f.puts e.retrieve_all_words
  f.close
end

desc "Build dictionary list of Spanish words"
task "build-spanish-dictionary" do
  e = DictionaryBuilder::Spanish
  f = open("dictionaries/dict-spanish", "w")
  f.puts e.retrieve_all_words
  f.close
end

desc "Build dictionary list of French words"
task "build-french-dictionary" do
  e = DictionaryBuilder::French
  f = open("dictionaries/dict-french", "w")
  f.puts e.retrieve_all_words
  f.close
end

task :default do
  puts "snAAAaaaakess"
end
