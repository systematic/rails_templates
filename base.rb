
run "echo 'TODO' > README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"

# Freeze!
rake "rails:freeze:gems"

#load_template "http://github.com/systematic/rails_templates/raw/master/initial_git_commit.rb

# Set up git repository
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
file '.gitignore', <<-END
log/*.log
*~
db/*.bkp
coverage
tmp
test/log
log/test
\#*
.\#*
apple_report_*.xls
.DS_Store
.svn
db/deep_test*
*_flymake.*
db/*.sqlite3
END

git :init
git :add => '.'
git :commit => "-m 'initial commit'"




# Install submoduled plugins
plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'

# plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git', :submodule => true
# plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git', :submodule => true
# plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git', :submodule => true
# plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git', :submodule => true
# plugin 'role_requirement', :git => 'git://github.com/timcharper/role_requirement.git', :submodule => true
# plugin 'acts_as_taggable_redux', :git => 'git://github.com/monki/acts_as_taggable_redux.git', :submodule => true
# plugin 'aasm', :git => 'git://github.com/rubyist/aasm.git', :submodule => true
git :add => '.'
git :commit => "-m 'plugins'"

# Install all gems
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
gem "rubyist-aasm", :lib => "aasm", :source => "http://gems.github.com"

# gem 'ruby-openid', :lib => 'openid'
# gem 'sqlite3-ruby', :lib => 'sqlite3'
# gem 'hpricot', :source => 'http://code.whytheluckystiff.net'
# gem 'RedCloth', :lib => 'redcloth'
rake('gems:install', :sudo => true)
git :add => '.'
git :commit => "-m 'gems'"

generate("authenticated", "user session --include-activation  --aasm")
git :add => '.'
git :commit => "-m 'user authentication'"
