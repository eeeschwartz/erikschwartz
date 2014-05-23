# search markdown links and convert
# [do some cool thing](#fn-infer) => <a name="do-some-cool-thing"></a>[do some cool thing](#do-some-cool-thing)
def transform(line)
  fn_name = 'fn-infer'
  md_regex = %r{[^`]?\[(.*)\]\(##{fn_name}\)}
  name_regex = %r{##{fn_name}}
  a_regex = %r{\[}

  p line
  if (line =~ md_regex)
    heading = $1
    fragment = heading.gsub(/ /, '-')

    # remove non permalink chars
    fragment = fragment.downcase.gsub(/[^a-z-]/, '')

    line = line.sub(name_regex, "{{page.url}}##{fragment}")

    line = line.sub(a_regex, %(<a name="#{fragment}"></a> [))
    p line
  end
  line
end

# transform('[do some cool thing](#fn-infer)')
# exit
filename = './_posts/2014-05-23-environment-improvements-3.md'
File.open(filename) do |f|
  out = []

  f.each_line do |line|
    out << transform(line)
  end
  File.open(filename, 'w') do |f|
    out.each { |line| f << line }
  end
end
