namespace :wtd do
  namespace :db do
    [:sqlite, :pg, :mysql].each do |driver|
      desc "Use #{driver} database.yml template and driver"
      task "use_#{driver}".to_sym, [:force] do |task, args|
        copy_database_template(driver.to_s, args[:force])
      end
    end

    def copy_database_template(driver, force = nil)
      template_path = File.join(Rails.root, 'config', 'database_templates', "#{driver}.yml")
      destination = File.join(Rails.root, 'config', 'database.yml')
      if File.exists?(destination) && force != 'force'
        puts "config/database.yml already exists - skipping template copy."
        puts "  To force overwriting the current file with a fresh template, use:"
        puts "  rake wtd:db:use_#{driver}[force]"
      else
        FileUtils.copy(template_path, destination)
        puts "Copied #{driver} template to config/database.yml."
      end
      change_database_driver_in_gemfile(driver)
    end

    def change_database_driver_in_gemfile(driver)
      db_driver = case driver
        when 'pg' then 'pg'
        when 'mysql' then 'mysql2'
        when 'sqlite' then 'sqlite3'
        else
          raise ArgumentError, "Driver #{driver} not recognized."
      end
      gemfile_path = File.join(Rails.root, 'Gemfile')
      gemfile_contents = File.read(gemfile_path)
      line_regex = /^gem '(.*)' \# Database driver gem - autoset$/
      new_line = "gem '#{db_driver}' # Database driver gem - autoset"
      if gemfile_contents =~ line_regex
        gemfile_contents.gsub!(line_regex, new_line)
        File.open(gemfile_path, 'w') do |f|
          f.puts gemfile_contents
        end
        puts "Gemfile updated to use #{db_driver}."
      else
        puts "Gemfile not updated - database driver gem line has been modified manually."
      end
    end
  end
end