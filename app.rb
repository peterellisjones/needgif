require 'sinatra'
require 'newrelic_rpm'
require 'uri'
require 'nokogiri'
require 'open-uri'
require 'cgi'
require 'json'
use Rack::Logger

class App < Sinatra::Application
  enable :raise_errors, :logging

  get '/favicon.ico' do
    redirect "/assets/not_found.gif"
  end

  get '/:query' do
    query = params['query']

    # remove filetype
    query = query.gsub(/\.[a-zA-Z]+$/, "")

    # replace hyphens with spaces and URI encode
    query = URI.encode query.gsub("-", "")

    biw=2209

    url = "https://www.google.com/search?hl=en&tbm=isch&tbs=ift:gif,itp:animated&q=#{query}&safe=on"

    # check memcache
    m_query = "QUERY:"+query.to_s
    begin
      ret = $Cache.get(m_query)
      (redirect(image_url) and return) if image_url = JSON.parse(ret).sample
    rescue
    end

    # otherwise grab from google and put in cache
    begin
      html = Nokogiri::HTML(open(url))
      image_urls = []
      html.css('.images_table td a').to_a.take(1).each do |a|
        image_urls.push CGI::parse(a[:href].gsub(/^[^\?]+\?/, ''))["imgurl"][0]
      end
      (redirect("/assets/not_found.gif") and return) if image_urls.length == 0
      # cache for a day by default
      $Cache.set(m_query, image_urls.to_json, 60*60*24)
      redirect image_urls.first
    rescue Exception => e
      redirect "/assets/not_found.gif"
    end
  end

  get '/' do
    redirect "/assets/not_found.gif"
  end
end
