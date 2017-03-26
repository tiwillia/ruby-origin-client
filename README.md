# Ruby Origin Client Library
Early WIP

## Usage
Authorization is handled only through oauth tokens.

A client is created by supplying the api url and the oauth token. Objects are then created and passed into the client for creation, deletion, and updates:
```
require 'origin'

oauth_token = "xxxxxxxxxxxxxxxxxxxx"
oc = Origin::Client.new("https://127.0.0.1:8443/oapi/v1", oauth_token, verify_ssl=false)

ex_user = Origin::User.new("MiguelSanchez")
oc.create(ex_user)
```

Objects can also be gathered from the API, although a limited set of objects is currently supported:
```
lionel_hutz = oc.find(:user, "MiguelSanchez")
```

## Installation
Build the gem:
```
gem build origin-client.gemspec
```

Install the gem:
```
gem install origin-client-0.0.1.gem
```
