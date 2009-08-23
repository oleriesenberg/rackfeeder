require 'yaml'
require 'feedzirra'

use Rack::ContentLength

class Rackfeeder
  def initialize
    @config = YAML.load_file(::File.join(::File.dirname(__FILE__), 'config.yml'))
  end

  def call(env)
    feed = Feedzirra::Feed.fetch_and_parse(@config["feed_url"])
    [200, { 'Content-Type' => 'text/html' }, build_html(feed)]
  end

  def build_html(feed)
    html = "<div id=\"rackfeeder\">\n"
    feed.entries.first(@config["entries"]).each do |entry|
      html << "  <div class=\"rackfeederEntry\">\n"
      html << "    <div class=\"rackfeederTitle\">#{entry.title}</div>\n"
      html << "    <div class=\"rackfeederContent\">#{entry.content}</div>\n"
      html << "  </div>\n"
    end
    html << "</div>\n"
    html
  end
end

app = Rackfeeder.new
run app
