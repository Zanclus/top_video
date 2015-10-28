require 'yt'
require 'thread'
require 'benchmark'

class ChannelInfo
  attr_accessor :channel
  attr_accessor :average
  attr_accessor :total

  def initialize(channel)
    @channel = channel
    @average = 0
    @total = 0
  end
end

class VideoList
  attr_accessor :video
  attr_accessor :percent

  def initialize(video, percent)
    @video = video
    @percent = percent
  end
end

class TopVideo
  attr_accessor :videos
  attr_accessor :channels
  attr_accessor :limit
  attr_accessor :mutex_channel
  attr_accessor :mutex_video

  # Return the difference in days between now and date where the video has been published
  def numberOfDay(date)
    t = Time.now
    diff = t - date
    diff = diff / (60 * 60 * 24)
    return diff
  end

  # dump function to show the array of video
  def dump(tab)
    puts "dump :"
    tab.each do |x|
      puts x.video.title
      puts x.percent
    end
    puts "end of dump"
  end

  # Select Video in channel result from date and average view by day
  def selectVideo(videos, average)
    tmp = Array.new
    videos.each do |video|
      diff = numberOfDay(video.published_at)
      averageVideo = video.view_count / diff
      if ((diff < 30) && (averageVideo > average))
        increase = ((averageVideo - average) / average) * 100
        videoList = VideoList.new(video, increase)
        tmp << videoList
      end
    end
    tmp.sort_by! {|item| item.percent}.reverse!
    @mutex_channel.synchronize do
      tmp.first(@limit).each do |x|
        @videos << x
      end
    end
  end

  # calcul the averageView by day of the channel
  def averageView(video, id)
    diff = numberOfDay(video.published_at)
    @mutex_video.synchronize do
      @channels.at(id).total = @channels.at(id).total + (video.view_count / diff)
    end
  end

  # global function which retries the average and select the video
  def global(channel, id)
    threads = Array.new
    videos = channel.videos
    videos.each do |video|
      threads << Thread.new(video) {|x| averageView(x, id)}
    end
    threads.each do |thread|
      thread.join
    end
    @channels[id].average = @channels[id].total / channel.video_count
    selectVideo(videos, @channels[id].average)
  end

  def initialize(key, idChannels, limit = 3)
    @videos = Array.new
    @channels = Array.new
    @limit = limit
    @mutex_channel = Mutex.new
    @mutex_video = Mutex.new
    threads = Array.new
    i = 0
    Yt.configuration.api_key = key
    idChannels.each do |id|
      channel = Yt::Channel.new id: id
      channelInfo = ChannelInfo.new(channel)
      @channels << channelInfo
      threads << Thread.new(channel, i) {|chan, id| global(chan, id)}
      i = i + 1
    end
    threads.each do |thread|
      thread.join
    end
    @videos.sort_by! {|x| x.video.channel_title}
  end
end
