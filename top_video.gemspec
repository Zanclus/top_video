Gem::Specification.new do |s|
  s.name        = 'top_video'
  s.version     = '0.2.0'
  s.date        = '2015-10-26'
  s.summary     = "Retrieve rising videos from your favorite music channels"
  s.description = "Using Youtube API, top_video is a gem which will allow you to retrieve rising videos from your favorite music channels with a release date less than one month"
  s.authors     = ["Valentin Wallet"]
  s.email       = 'valentinwallet@gmail.com'
  s.files       = ["lib/top_video.rb"]
  s.homepage    =
    'https://github.com/Zanclus/top_video'
  s.license       = 'MIT'
  s.add_runtime_dependency 'yt', '~> 0.25.5'
end
