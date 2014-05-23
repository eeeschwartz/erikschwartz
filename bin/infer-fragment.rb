# search markdown links and convert
# [do some cool thing](#fn-infer) => [do some cool thing](#do-some-cool-thing)

line = '[do some cool thing](#fn-infer)'
def transform(line)
  fn_name = 'fn-infer'
  md_regex = %r{[^`]\[(.*)\]\(##{fn_name}\)}
  name_regex = %r{#{fn_name}}
  a_regex = %r{\[}

  p line
  if (line =~ md_regex)
    heading = $1
    fragment = heading.gsub(/ /, '-')

    # remove non permalink chars
    fragment = fragment.downcase.gsub(/[^a-z-]/, '')

    line = line.sub(name_regex, fragment)

    line = line.sub(a_regex, "<a name=\"#{fragment}\"></a> [")
    p line
  end
end

transform(line)
#
# File.open(filename) do |f|
#   out = []
#
#   f.each_line do |line|
#     out << line
#   end
#   File.open(filename, 'w') do |f|
#     out.each { |line| f << line }
#   end
# end
