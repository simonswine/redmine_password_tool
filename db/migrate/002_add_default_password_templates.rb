class AddDefaultPasswordTemplates < ActiveRecord::Migration
  def self.up

    # SSH
    PasswordTemplate.new({
                             'name' => 'ssh_account',
                             'schema' => '   [
        {
            "name": "username",
        "caption": "Username",
        "type": "text",
        "validate": {
        "required": true
    }
    },
        {
            "name": "password",
        "caption": "Password",
        "type": "password"
    },
        {
            "name": "private_key",
        "caption": "Private Key",
        "type": "text"
    },
        {
            "name": "private_key_passphrase",
        "caption": "Passphrase for private Key",
        "type": "password"
    },
        {
            "name": "host",
        "caption": "Host",
        "type": "text",
        "validate": {
        "required": true
    }
    },
        {
            "name": "port",
        "caption": "Port",
        "type": "password"
    }]'
                         }).save

    # FTP
    PasswordTemplate.new({
                             'name' => 'ftp_account',
                             'schema' => '   [
        {
            "name": "username",
        "caption": "Username",
        "type": "text",
        "validate": {
        "required": true
    }
    },
        {
            "name": "password",
        "caption": "Password",
        "type": "password",
        "validate": {
        "required": true
    }
    },
        {
            "name": "host",
        "caption": "Host",
        "type": "text",
        "validate": {
        "required": true
    }
    },
        {
            "name": "port",
        "caption": "Port",
        "type": "password"
    }]'
                         }).save
    # Allegemein User Passwort (URL)
    PasswordTemplate.new({
                             'name' => 'user_password',
                             'schema' => '   [
        {
            "name": "username",
        "caption": "Username",
        "type": "text",
        "validate": {
        "required": true
    }
    },
        {
            "name": "password",
        "caption": "Password",
        "type": "password",
        "validate": {
        "required": true
    }
    }]'
                         }).save
    PasswordTemplate.new({
      'name' => 'user_password_url',
      'schema' => '[
  {
    "name": "username",
    "caption": "Username",
    "type": "text",
    "validate": {
      "required": true
    }
  },
  {
    "name": "password",
    "caption": "Password",
    "type": "password",
    "validate": {
      "required": true
    }
  },
  {
  "name": "url",
  "caption": "URL",
  "type": "url",
  "validate": {
    "required": true
  }
}]'
                         }).save

    # Typo 3 Seite
    PasswordTemplate.new({
                             'name' => 'typo3_site',
                             'schema' => '[
    {
        "name": "install_password",
        "caption": "Installtool Password",
        "type": "text"
    },
    {
        "name": "url",
        "caption": "URL",
        "type": "url",
        "validate": {
            "required": true
        }
    },
    {
        "name": "local_path",
        "caption": "Local Path",
        "type": "text"
    }
]'
                         }).save

    # Wordpress
    PasswordTemplate.new({
                             'name' => 'wordpress_site',
                             'schema' => '[
    {
        "name": "url",
        "caption": "URL",
        "type": "url",
        "validate": {
            "required": true
        }
    },
    {
        "name": "local_path",
        "caption": "Local Path",
        "type": "text"
    }
]'
                         }).save


    # MySQL Datenbank
    PasswordTemplate.new({
                             'name' => 'mysql_database',
                             'schema' => '[
    {
        "name": "username",
        "caption": "Username",
        "type": "text",
        "validate": {
            "required": true
        }
    },
    {
        "name": "password",
        "caption": "Password",
        "type": "password",
        "validate": {
            "required": true
        }
    },
    {
        "name": "host",
        "caption": "Host",
        "type": "text"
    },
    {
        "name": "dbname",
        "caption": "Database Name",
        "type": "text",
        "validate": {
            "required": true
        }
    },
    {
        "name": "port",
        "caption": "Port",
        "type": "text"
    }
]'
                         }).save


  end

  def self.down

    # Remove default templates
    template_names = ['ssh_account', 'ftp_account', 'user_password', 'user_password_url', 'typo3_site', 'wordpress_site', 'mysql_database']

    template_names.each { |name|
      pt = PasswordTemplate.find_by_name(name)

      if not pt.nil?
        pt.destroy
      end
    }


  end
end