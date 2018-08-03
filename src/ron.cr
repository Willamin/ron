require "json"

module Ron
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end

class MageError
  JSON.mapping(
    message: String,
    trace: String,
    parameters: Hash(String, String)
  )

  def print_message
    my_message = message
    parameters.each do |k, v|
      my_message = my_message.gsub("%#{k}", v)
    end
    puts my_message
  end
end

input = STDIN.gets
if input.nil?
  exit 1
end

m = MageError.from_json(input)

show_message? = ARGV.includes?("--message")
show_trace? = ARGV.includes?("--trace")

if show_message?
  m.print_message
end

if show_trace?
  puts m.trace
end

if !show_message? && !show_trace?
  m.print_message
end
