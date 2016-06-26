# This portion of the script handles the specifics of the Deluge Client.

# Author  : Erik Watson
# Website : http://erikwatson.me

require 'date'
require 'fileutils'

class Deluge
  def initialize(os, trackers, do_backup)
    puts "\nMake sure you've quit Deluge AND stopped the Deluge Daemon before continuing."
    puts "Press Return when this is done."
    gets.chomp # Waiting for return

    @trackers = trackers

    @task = get_task(os)

    if do_backup
      backup
    end

    run
  end

  def backup
    @task.backup
  end

  def restore
    @task.restore
  end

  def run
    @task.run
  end

  def get_task(os)
    case os
    when :windows
      Windows.new(@trackers)
    end
  end

end

class Windows
  def initialize(trackers)
    @from_tracker = trackers[:from]
    @to_tracker   = trackers[:to]

    @state = "#{ENV['APPDATA']}\\deluge\\state"
    @backup_state = backup_dir
  end

  def backup
    puts "Backing up #{@state} to #{@backup_state}"
    FileUtils.copy_entry(@state, @backup_state)
    puts "Backup Complete."
  end

  def restore
    # TODO
  end

  def run
    puts "\nWriting the new torrents.state file"

    state_path = "#{@state}\\torrents.state"
    state_bak_path = "#{@state}\\torrents.state.bak"

    result = File.open(state_path) do |file|
      file.read.gsub(@from_tracker, @to_tracker)
    end

    File.open(state_path, 'wb') do |file|
      file.write(result)
    end

    puts "Writing complete."
    puts "\nEnjoy :]"
  end

  def backup_dir
    date = DateTime.now.strftime("%d-%m-%y(%Hh-%Mm-%Ss)")
    "#{ENV['APPDATA']}\\deluge\\backup_state_#{date}"
  end
end