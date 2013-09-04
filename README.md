# Redmine Passwort Tool Plugin

 - Store passwords/other secrets crypted in database
 - Customizable password entry templates
 - Role based access per project

---

## Todos

## Testing

 - Everything should be covered by tests

### Prepare test database

```
# Test Env
export RAILS_ENV=test

# Drop Database
rake db:migrate

# Upgrade Database Schema
rake db:test:load
rake db:test:prepare
rake redmine:plugins:migrate 

```


### Recreate test database

```
# Reset db completly
rake db:drop db:create db:migrate db:test:load db:test:prepare redmine:plugins:migrate redmine:load_default_data RAILS_ENV=test

```

