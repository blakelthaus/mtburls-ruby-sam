require 'httparty'
require 'json'
require 'rss'
require 'open-uri'

def get_url(site)
  # url = "https://www.pinkbike.com/pinkbike_xml_feed.php"
  if (site == "pinkbike")
    url = "https://www.pinkbike.com/pinkbike_xml_feed.php"
  elsif (site == "vitalmtb")
    url = "http://feeds.vitalmtb.com/VitalMtbSpotlights"
  elsif (site == "bikeradar")
    url = "https://www.bikeradar.com/cycling-discipline/mtb/feed/" #doesn't work
  elsif (site == "mtbmag")
    url = " https://www.mtb-mag.com/en/feed/" #doesn't work
  elsif (site == "singletracks")
    url = "https://www.singletracks.com/articles/feed/"
  elsif (site == "enduro-mtb")
    url = "https://enduro-mtb.com/en/feed/" #doesn't work
  elsif (site == "mtbr")
    url = "https://www.mbr.co.uk/feed" 
  elsif (site == "imbikemag")
    url = "https://www.imbikemag.com/feed/"
  elsif (site == "velonews")
    url = "https://www.velonews.com/category/news/mountain/feed/"
  elsif (site == "bikerumor")
    url = "https://bikerumor.com/category/bike-types/mountain-bike/feed/"
  elsif (site == "radnut")
    url = "https://radnut.com/feed/"
  elsif (site == "nsmb")
    url = "https://nsmb.com/articles/rss/"
  elsif (site == "mbaction")
    url = "https://mbaction.com/feed/"
  elsif (site == "kitsbow")
    url = "https://www.kitsbow.com/blogs/news.atom"
  elsif (site == "bermstyle")
    url = "https://bermstyle.com/feed/"
  end

  url
end

def get_news(site)
  url = get_url(site)
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

  begin
    response = get_news(event["queryStringParameters"]["type"])
  rescue HTTParty::Error => error
    puts error.inspect
    raise error
  end

  {
    statusCode: 200,
    body: {
      links: response
    }.to_json
  }

end
