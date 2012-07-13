def excerpt(text, phrase, *args)
  return unless text && phrase

  options = args.extract_options!
  unless args.empty?
    options[:radius] = args[0] || 100
    options[:omission] = args[1] || "..."
  end
  options.reverse_merge!(:radius => 100, :omission => "...")

  phrase = Regexp.escape(phrase)
  return unless found_pos = text.mb_chars =~ /(#{phrase})/

  start_pos = [ found_pos - options[:radius], 0 ].max
  end_pos   = [ [ found_pos + phrase.mb_chars.length + options[:radius] - 1, 0].max, text.mb_chars.length ].min

  prefix  = start_pos > 0 ? options[:omission] : ""
  postfix = end_pos < text.mb_chars.length - 1 ? options[:omission] : ""

  prefix + text.mb_chars[start_pos..end_pos].strip + postfix
end

strings = [
  "I have a dog.",
  "I hope you know i have a dog, & I love it",
  "I have a dog & you don't. Ha!",
  "I hope you know i like cheese.",
  "I like dogs",
]

strings = "one two one three one five two"



puts strings.scan(/(?:a\w).*\a/i).inspect   

# codex = {}
# 
# 
# strings.each do |string|
#   string.scan(/[\w\']{3,}/).each do |word|
#     codex[word] ||= 0
#     codex[word] += 1
#   end
# end
# 
# codex.each do |string, occurances|
#   puts "#{string} - #{occurances}"
# end