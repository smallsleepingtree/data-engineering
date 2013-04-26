namespace :wtd do
  desc "Create an admin user"
  task :create_admin_user => :environment do
    puts <<-DOC
Oh, fancy. You're using a rake task to create an admin.
What d'you want, a pat on the back?

- Checking for existing admin users...

    DOC
    if (users = User.where(:admin => true).all).present?
      puts <<-DOC
Hey, we already have admin user(s):
#{users.map(&:email)}

Want to create another?
      DOC
      print "(anything but \"yes\" will cancel): "
      answer = STDIN.gets.strip
      unless answer == 'yes'
        puts <<-DOC

Fine. Why are you wasting my time? I could have been downloading iPhone"
ads from Apple's website and dreaming about having capacitative fingers."

- Exiting...

        DOC
        next
      end
    else
      puts "\nNo admin user found.  Let's create one!\n"
    end
    print "Enter email address: "
    email = STDIN.gets.strip
    unless user = User.where(:email => email).first
      print "Enter password: "
      password = STDIN.gets.strip
      user = User.new(:email => email, :password => password)
    end
    puts "Making #{user.email} an admin..."
    user.admin = true
    user.authorized = true
    begin
      user.save!
      puts "Done!"
    rescue ActiveRecord::RecordInvalid => e
      puts "Oops.. something went wrong:"
      puts user.errors.full_messages
    end
  end
end