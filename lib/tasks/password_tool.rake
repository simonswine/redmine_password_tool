desc <<-END_DESC
Manage Redmine Password Tool

Example:
  rake redmine:password_tool:<cmd> RAILS_ENV="production"
END_DESC

namespace :redmine do
  namespace :password_tool do
    task :create_secret => :environment do
      PasswordInstance.create_secret
    end
  end
end
