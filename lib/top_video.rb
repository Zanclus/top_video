require 'yt'

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

  def numberOfDay(video)
    t = Time.now
    diff = t - video.published_at
    diff = diff / (60 * 60 * 24)
    return diff
  end

  def selectVideo(channel, average)
    videos = channel.videos
    videos.each do |video|
      diff = numberOfDay(video)
      averageVideo = video.view_count / diff
      if ((diff < 30) && (averageVideo > average))
        increase = ((averageVideo - average) / average) * 100
        videoList = VideoList.new(video, increase)
        @videos << videoList
      end
    end
  end

  def bubbleSort()
    order = 0
    while (order == 0)
      i = 0
      order = 1
      while (i < (@videos.length - 1))
        if (@videos[i].percent < @videos[i + 1].percent)
          tmp = @videos[i]
          @videos[i] = @videos[i + 1]
          @videos[i + 1] = tmp
          order = 0
        end
        i = i + 1
      end
    end
  end

  def averageView(channel)
    videos = channel.videos;
    i = 0;
    total = 0;
    videos.each do |video|
      diff = numberOfDay(video)
      total = total + (video.view_count / diff)
      i = i + 1
    end
    return (total / i)
  end

  def initialize(key, idChannels)
    Yt.configuration.api_key = key
    @videos = Array.new
    idChannels.each do |id|
      channel = Yt::Channel.new id: id
      average = averageView(channel)
      selectVideo(channel, average)
    end
  bubbleSort()
  end
end
