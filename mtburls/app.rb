require 'httparty'
require 'json'
require 'rss'
require 'open-uri'

def get_urls()
  {
    "pinkbike" => {
      "url": "https://www.pinkbike.com/pinkbike_xml_feed.php",
      "type": "pinkbike",
      "title": "Pinkbike",
      "color": "#D70202",
      "extension": ".png"
    },
    "mbaction" => {
      "url": "https://mbaction.com/feed/",
      "type": "mbaction",
      "title": "MBAction",
      "color": "#000000",
      "extension": ".png"
    },
    "vitalmtb" => {
      "url": "http://feeds.vitalmtb.com/VitalMtbSpotlights",
      "type": "vitalmtb",
      "title": "Vital MTB",
      "color": "#E2E2E2",
      "extension": ".png"
    },
    "mtbr" => {
      "url": "https://www.mbr.co.uk/feed",
      "type": "mtbr",
      "title": "MTBR",
      "color": "#404040",
      "extension": ".svg"
    },
    "imbikemag" => {
      "url": "https://www.imbikemag.com/feed/",
      "type": "imbikemag",
      "title": "IMBikeMag",
      "color": "#3C3C3C",
      "extension": ".png"
    },
    "nsmb" => {
      "url": "https://nsmb.com/articles/rss/",
      "type": "nsmb",
      "title": "NSMB",
      "color": "#000000",
      "extension": ".jpeg"
    },
    "singletracks" => {
      "url": "https://www.singletracks.com/articles/feed/",
      "type": "singletracks",
      "title": "Singletracks",
      "color": "#346A20",
      "extension": ".jpeg"
    },
    "bermstyle" => {
      "url": "https://bermstyle.com/feed/",
      "type": "bermstyle",
      "title": "Berm Style",
      "color": "#000000",
      "extension": ".png"
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
          puts item.pubDate
          response.push({title: item.title, link: item.link, pubDate: item.pubDate})
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
    headers: {
      "Access-Control-Allow-Headers": "Content-Type",
      "Access-Control-Allow-Origin": "*", 
      "Access-Control-Allow-Methods": "GET" 
    },
    body: {
      links: response
    }.to_json
  }
end
