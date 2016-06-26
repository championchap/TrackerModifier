# A script to change the Tracker of your Torrents.

# WARNING : Currently, this script only works with the Deluge Client under
#           Windows.
#
# Author  : Erik Watson
# Website : http://erikwatson.me

require './deluge.rb'

class App
  def initialize
    run(get_os, get_client, get_trackers, backup?)
  end

  def get_trackers
    puts "\nEnter the tracker address you want to replace"
    from = gets.chomp

    puts "\nEnter the NEW address of the tracker"
    to = gets.chomp

    { :from => from, :to => to }
  end

  def get_os
    puts "\nWhat OS are you using?
    [1] Windows
    [2] OSX
    [3] Linux"

    case(gets.chomp.to_i)
    when 1
      :windows
    when 2
      :osx
    when 3
      :linux

    else
      puts "\nI don't recognise that OS, exiting!"
      exit!
    end
  end

  def get_client
    puts "\nWhat Torrent Client are you using?
    [1] Deluge
    [2] UTorrent
    [3] Transmission"

    case(gets.chomp.to_i)
    when 1
      :deluge
    when 2
      :uTorrent
    when 3
      :transmission

    else
      puts "\nI don't recognise that Torrent Client, exiting!"
      exit!
    end
  end

  def backup?
    puts "\nDo you want to make a backup? (y/n)"
    result = false
    backup = gets.chomp

    if backup == 'y' || backup == 'yes'
      result = true
    end

    result
  end

  # It works like this because I had intended to expand the script to support
  # a wider range of torrent client and operating system combinations
  def run(os, client, trackers, backup)
    case client

    when :deluge
      @client = Deluge.new(os, trackers, backup)

    when :transmission
      @client = Transmission.new(os)

    when :utorrent
      @client = UTorrent.new(os)

    end

  end
end

tracker_modifier = App.new