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
  attr_accessor :limit
  attr_accessor :tmp

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
  def selectVideo(channel, average)
    videos = channel.videos
    videos.each do |video|
      diff = numberOfDay(video.published_at)
      averageVideo = video.view_count / diff
      if ((diff < 30) && (averageVideo > average))
        increase = ((averageVideo - average) / average) * 100
        videoList = VideoList.new(video, increase)
        @tmp << videoList
      end
    end
    bubbleSort(@tmp)
    @tmp.first(@limit).each do |x|
      @videos << x
    end
    @tmp.clear
  end

  # Sort the array of video
  def bubbleSort(videoTab)
    order = 0
    while (order == 0)
      i = 0
      order = 1
      while (i < (videoTab.length - 1))
        if (videoTab[i].percent < videoTab[i + 1].percent)
          tmp = videoTab[i]
          videoTab[i] = videoTab[i + 1]
          videoTab[i + 1] = tmp
          order = 0
        end
        i = i + 1
      end
    end
  end

  # return the averageView by day of the channel
  def averageView(channel)
    videos = channel.videos;
    i = 0;
    total = 0;
    videos.each do |video|
      diff = numberOfDay(video.published_at)
      total = total + (video.view_count / diff)
      i = i + 1
    end
    return (total / i)
  end

  def initialize(key, idChannels, limit = 3)
    @videos = Array.new
    @tmp = Array.new
    @limit = limit
    Yt.configuration.api_key = key
    idChannels.each do |id|
      channel = Yt::Channel.new id: id
      average = averageView(channel)
      selectVideo(channel, average)
    end
  end
end
