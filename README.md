# Redmine Passwort Tool Plugin

 - Store passwords/other secrets crypted in database
 - Customizable password entry templates
 - Role based access per project

---

## Todos

## Testing

### Summary 

* [![build status](https://secure.travis-ci.org/simonswine/redmine_password_tool.png)](https://travis-ci.org/simonswine/redmine_password_tool) on travis-ci.org (master branch) 


### Test Policy


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

### Run test
```
rake redmine:plugins:test NAME=redmine_password_tool
```
