require 'httparty'
require 'json'
require 'rss'
require 'open-uri'

def get_urls()
  {
    "pinkbike" => {
      "url": "https://www.pinkbike.com/pinkbike_xml_feed.php"
    },
    "vitalmtb" => {
      "url": "http://feeds.vitalmtb.com/VitalMtbSpotlights"
    },
    "singletracks" => {
      "url": "https://www.singletracks.com/articles/feed/"
    },
    "mtbr" => {
      "url": "https://www.mbr.co.uk/feed"
    },
    "imbikemag" => {
      "url": "https://www.imbikemag.com/feed/"
    },
    "velonews" => {
      "url": "https://www.velonews.com/category/news/mountain/feed/"
    },
    "bikerumor" => {
      "url": "https://bikerumor.com/category/bike-types/mountain-bike/feed/"
    },
    "nsmb" => {
      "url": "https://nsmb.com/articles/rss/"
    },
    "mbaction" => {
      "url": "https://mbaction.com/feed/"
    },
    "bermstyle" => {
      "url": "https://bermstyle.com/feed/"
    }
  }
end

def get_url(site)
  urls = get_urls()
  print urls
  urls[site][:url]
end

def get_news(site)
  url = get_url(site)
  puts "test"
  puts url
  counter = 0
  response = []
  URI.open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      puts "Title: #{feed.channel.title}"
      #need to figure out how to limit number of rss items we pull
      feed.items.each do |item|
        if(counter < 20)
          puts item.title
          puts item.link
          response.push({title: item.title, link: item.link})
          counter += 1
        end
      end
  end

  response
end


def lambda_handler(event:, context: )
  if (event["queryStringParameters"])
    begin
      response = get_news(event["queryStringParameters"]["type"])
    rescue HTTParty::Error => error
      puts error.inspect
      raise error
    end
  else 
    response = get_urls()
  end

  {
    statusCode: 200,
    body: {
      links: response
    }.to_json
  }
end
