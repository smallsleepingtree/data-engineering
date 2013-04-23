# Hey there, DevOps.

In case you haven't read the memo (which would surprise me, since we printed it on neon fuschia stock using 24pt Comic Sans, to avoid a repeat of last year's debacle in which the entire 7th floor claimed to be surprised by the paper airplane ban, leading to an ill-conceived protest now commemorated every month on Lethal Papercut Awareness Day, but I digress), LivingSocial recently acquired Jerry Seinfeld's most recent internet venture, WhatsTheDealWithDeals.biz.  Those responsible for the acquisition will be subject to an intensive internal "training," but [what's done is done](http://nfs.sparknotes.com/macbeth/page_96.html), and we're now tasked with integrating WTDWD.biz's data into our systems.

### The Usual Problem: Bears

Seinfeld, following an innovative business plan he likes to call "Who Cares?", employed an IT team consisting mostly of bear cubs.  As we all know, bears are terrified of relational databases, so WTDWD.biz's business data was primarily written on the backs of packages of Nestle chocolate chips.  Fortunately, Seinfeld & Co has managed to transcribe the transactional data into tab-delimited files, and now they're ready to upload the data into our database.

## Look, We Made Another Rails App

To accomplish this monumental goal and bring joy to the lives of dozens of customers, we created a [Ruby on Rails](http://rubyonrails.org) app.  And now you get to set it up!

### Installation

#### Getting the Code

First, clone the repository (for the purposes of this documentation, we're cloning into a folder called `smallsleepingtree`):

    $ git clone git@github.com:/smallsleepingtree/data-engineering.git smallsleepingtree

#### Configuration

The Rails app is in a directory *within* the smallsleepingtree directory you just created, so let's `cd` into it:

    $ cd smallsleepingtree/whats_the_deal_with_rails

There's a .ruby-version file in that directory, in case you're using [rbenv](http://rbenv.org), [rvm](https://rvm.io), or [chruby](https://github.com/postmodern/chruby).  If not, just make sure you've got Ruby 1.9.x in your path.

I know you're getting excited now, but before you can spin up the server, you'll need to choose a database config.  If you're in a hurry, SQLite is your best choice, but if you'd rather use PostgreSQL or MySQL, that's fine, too.  Don't let me tell you how to live your life.  You're DevOps.

    $ rake wtd:db:use_sqlite  # or wtd:db:use_pg, or wtd:db:use_mysql
    $ bundle install          # needed if chosen database driver gem not in bundle

This creates a database.yml file from a template in the `config` directory; you're welcome to edit the new file as you wish.  It also updates the Gemfile to use the chosen driver, which is why you may need to run bundle install after changing the DB.

By default, the SQLite config needs no additional setup, but the PostgreSQL and MySQL default configs assume you have a server running locally, and they'll use a database named `whats_the_deal_dev` in the development environment, with a passwordless user named 'whats_the_deal'.

Now that you've got your database config set up, populate the schema:

    $ rake db:migrate

#### Creating the Admin User

Finally, to set up the first user (an administrator who will be able to authorize additional users):

    $ rake wtd:create_admin_user

You will be prompted to provide an email address and password for the new admin user.  Use discretion in choosing your admin user - this person will be as the sun itself, wielding power over light and darkness.  Or, more accurately, over which user accounts are allowed to upload data files.

That's it!  You're done!  Grab a cup of rooibos tea and some sesame crackers, and take the rest of the day off.

**Oh, wait!**  We forgot to actually spin up the server.

#### Not Forgetting to Spin Up the Server

    $ rails s

This will spin up a WEBrick instance, running on port 3000, accessible at [http://localhost:3000](http://localhost:3000).  Make sure everything looks good there - you can try logging in as the recently created admin user if you want - and *now* you can enjoy your tea.  I'm sorry; I hope it isn't cold now.

### Usage

See the `README.md` file in the `whats_the_deal_with_rails` directory for user instructions.