# TopVideo

Using Youtube API, top_video is a gem that will allow you to retrieve rising videos from your favorite music channels with a release date less than one month.

## Installation

Add this line to your application's Gemfile:

gem 'top_video'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install top_video

## How to use ?

The gem uses a client model to query against the API. So, you need a API key for Youtube.

An example :

    id_channels = ["UCudKvbd6gvbm5UCYRk5tZKA"] # Array of channel id
    api_key = "YOUR_API_KEY" # replace by your API key
    topVideos = TopVideo.new(api_key, channels)
    topVideos.videos.each do |x|
        puts x.video.title # title of the video
        puts x.percent # developement percentage of the video
    end

## Contributing

1. Fork it ( https://github.com/Zanclus/top_video/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
