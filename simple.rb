# check prerequisites

%w{colored bundler}.each do |component|
  unless Gem::Specification::find_by_name(component)
    run "gem install #{component}"
    Gem::Specification.refresh
    Gem::Specification.activate(component)
  end
  require "#{component}"
end

puts 'Starting simple template...'.magenta

# create a unique gemset
run "rvm gemset create #{app_name}"
create_file ".rvmrc", "rvm use @#{app_name}"

# install gems
gem "haml", "~> 3.1.1"
gem "sass", "~> 3.1.2"
gem "nifty-generators", "~> 0.4.6", :group => :development

generate 'nifty:layout --haml'
remove_file 'app/views/layouts/application.html.erb'
generate 'nifty:config'

# clean up rails defaults
remove_file 'public/index.html'
remove_file 'rm public/images/rails.png'

# make sure the gems are installed on our gemset
run "rvm @#{app_name} -S bundle install"

# git
append_file '.gitignore', <<-END
.DS_Store
.project
config/database.yml
Gemfile.lock

# netbeans project directory
/nbproject/

# textmate project files
/*.tmpproj

# vim
**.swp
END

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"
