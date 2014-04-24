desc <<-END_DESC
Manage Redmine Password Tool

Example:
  rake redmine:password_tool:<cmd> RAILS_ENV="production"
END_DESC

require 'rspec/core/rake_task'

plugin_name =  File.basename(File.expand_path(File.join(__FILE__,'..','..','..')))

namespace :redmine do
  namespace :password_tool do
    task :create_secret => :environment do
      PasswordInstance.create_secret
    end
  end
  namespace :plugins do
    desc 'Runs the plugins rspec tests.'
    task :test => "db:test:prepare" do |t|
      if not ENV['NAME'] || ENV['NAME'] == plugin_name
        Rake::Task["redmine:plugins:rspec"].invoke
      end
    end
    RSpec::Core::RakeTask.new :rspec do |t|
      t.rspec_opts = '--color'
      t.verbose = true
      t.pattern = "plugins/#{plugin_name}/spec/**/*_spec.rb"
    end
  end
end
