require 'sinatra'
require 'uri'
require 'nokogiri'
require 'open-uri'
require 'cgi'

class App < Sinatra::Application
  enable :raise_errors

  get '/:query' do
    query = params['query']
    halt(400, "should be of format: gifme.ukoki.com/funny-cat.gif") unless query

    # remove filetype
    query = query.gsub(/\.[a-zA-Z]+$/, "")

    # replace hyphens with spaces and URI encode
    query = URI.encode query.gsub("-", "")

    url = "https://www.google.com/search?hl=en&tbm=isch&tbs=ift:gif,itp:animated&q=#{query}"

    # begin
    #   html = Nokogiri::HTML(open(url))
    #   random_image_url = html.css('.images_table td a').to_a.sample[:href]
    #   original_image_url = CGI::parse(random_image_url.gsub(/^[^\?]+\?/, ''))["imgurl"][0]
    #   redirect original_image_url
    # rescue Exception => e
      redirect "/assets/not_found.gif"
    # end
  end
end
