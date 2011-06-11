# create a unique gemset

run "rvm gemset create #{app_name}"
create_file ".rvmrc", "rvm gemset use #{app_name}"

# install gems
gem "haml", "~> 3.1.1"
gem "sass", "~> 3.1.2"
gem "nifty-generators", "~> 0.4.6", :group => :development

run 'bundle install'

generate 'nifty:layout --haml'
remove_file 'app/views/layouts/application.html.erb'
generate 'nifty:config'

# clean up rails defaults
remove_file 'public/index.html'
remove_file 'rm public/images/rails.png'

# git
file '.gitignore', <<-END
  .DS_Store
  .bundle
  db/*.sqlite3
  log/*.log
  tmp/
  .sass-cache/

  .project
  config/database.yml
  Gemfile.lock
END

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"
