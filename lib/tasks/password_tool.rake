desc <<-END_DESC
Manage Redmine Password Tool

Example:
  rake redmine:password_tool:<cmd> RAILS_ENV="production"
END_DESC

require 'rspec/core/rake_task'


namespace :redmine do
  namespace :password_tool do
    task :create_secret => :environment do
      PasswordInstance.create_secret
    end

    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.pattern = Dir['plugins/redmine_password_tool/spec/**/*_spec.rb'].sort
      if ENV['CI'] == '1'
        t.rspec_opts = "--format RspecJunitFormatter --out junit_password_tool.xml"
      end
    end

    task :test do
      Rake::Task["redmine:password_tool:rspec"].execute
    end


  end
end
