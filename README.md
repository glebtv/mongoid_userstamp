# WARNING

This fork is INCOMPATIBLE with upstream due to different default field names

This fork uses actual mongoid belongs_to relations instead of low level work with BSON fields. Primary reason for doing
this is to support eager loading for creator/updater modifier

MongoidUserstamp adds stamp columns for created by and updated by
information within Rails applications using Mongoid ORM.

## Version Support

MongoidUserstamp is tested on the following versions:

* Ruby 1.9.3 and 2.0.0
* Rails 3
* Mongoid 3

## Install

```ruby
  gem 'mongoid_userstamp'
```

## Usage

```ruby
  # Default config
  Mongoid::Userstamp.config do |c|

    # Default config values

    c.user_reader = :current_user
    c.user_model = :user

    c.creator_field = :creator
    c.updater_field = :updater

  end

  # Example model
  class Person
    include Mongoid::Document
    include Mongoid::Userstamp
  end
 
  # Create instance
  p = Person.create

  # Updater ObjectID or nil
  p.updater_id
  # => BSON::ObjectId('4f7c719f476da850ba000039')

  # Updater instance or nil
  p.updater
  # => <User _id: 4f7c719f476da850ba000039>

  # Set updater manually (usually not required)
  p.updater = my_user # can be a Mongoid::Document or a BSON::ObjectID
  # => sets updated_by to my_user's ObjectID

  # Creator ObjectID or nil
  p.creator_id
  # => BSON::ObjectId('4f7c719f476da850ba000039')

  # Creator instance or nil
  p.creator
  # => <User _id: 4f7c719f476da850ba000039>

  # Set creator manually (usually not required)
  p.creator = my_user # can be a Mongoid::Document or a BSON::ObjectID
  # => sets created_by to my_user._id
```

## Contributing

Fork -> Patch -> Spec -> Push -> Pull Request

Please use Ruby 1.9.3 hash syntax, as Mongoid 3 requires Ruby >= 1.9.3

## Authors

* [Thomas Boerger](http://www.tbpro.de)
* [John Shields](https://github.com/johnnyshields)
* [GlebTV](https://github.com/glebtv)

## Copyright

Copyright (c) 2012-2013 Thomas Boerger Programmierung <http://www.tbpro.de>
Copyright (c) 2014 glebtv <http://rocketscience.pro>

Licensed under the MIT License (MIT). Refer to LICENSE for details.
