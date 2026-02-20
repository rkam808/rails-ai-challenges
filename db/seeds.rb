# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#


Challenge.create(
  name: "HTML Generator",
  module: "Ruby",
  content: <<-HEREDOC
## Background & Objectives

Let’s keep practicing blocks in this challenge. We will code another method that should be called with a block, and this time we will see how blocks enable nesting method calls, and how this can be useful in a real-life example. We will also discover how we can define methods with a second optional parameter, which happens frequently!

## Specs

Implement the #tag method that builds the HTML tags around the content we give it in the block. For instance:
```ruby
tag("h1") do
  "Some Title"
end
#=> "<h1>Some Title</h1>"
```

This method accepts a second optional parameter (see section below on arguments with default value), enabling to pass an array with one HTML attribute name and its value, like ["href", "www.google.com"].
```ruby
tag("a", ["href", "www.google.com"]) do
  "Google it"
end
#=> '<a href="www.google.com">Google it</a>'
```

You may need to know that to include a " symbol inside a string delimited by double quotes,
you need to escape this character with an antislash: \".

The cool thing about this method is that you can nest method calls:

```ruby
tag("a", ["href", "www.google.com"]) do
  tag("h1") do
    "Google it"
  end
end
# => '<a href="www.google.com"><h1>Google it</h1></a>'
```

Cool right?
Arguments with default value

In Ruby you can supply a default value for an argument. This means that if a value for the argument isn’t supplied, the default value will be used instead, e.g.:

```ruby
def sum(a, b, c = 0)
  return a + b + c
end

sum(3, 6, 1) # => 10
sum(4, 2)    # => 6
```

Here, the third argument is worth 0 if we call sum with only two arguments.
  HEREDOC
)


Challenge.create(
  name: "Instance vs Class",
  module: "OOP",
  content: <<-HEREDOC
## Background & Objectives

- understand the difference between a class method and an instance method.

When using a gem or a module of the standard library, you will have to use class methods that are CALLED DIRECTLY ON THE CLASS, not on instances of the class. Consider the following lines in IRB:

```ruby
"this is a string object".upcase
["this", "is", "an", "array", "object"].shuffle
Time.now
a_time_object = Time.now
a_time_object.hour
```

Can you spot the one method that differs from the others? Make sure you can find the intruder!

## Specs

- Create a Restaurant class with two instance variables, @city and @name, set with the two parameters of initialize.
- Define an instance method #rate(new_rate) enabling the rating of a restaurant object. This method should re-compute the restaurant average rating @average_rating every time it’s called with a new rating. This @average_rating should be accessible to the external world.
- Define a class method .filter_by_city(restaurants, city) that returns all the restaurants in a given city (this return should be an array of restaurant objects). For instance:

```ruby
jules_verne = Restaurant.new("paris", "Jules Verne")
bluebird = Restaurant.new("london", "Bluebird")
daniel = Restaurant.new("new york", "Daniel")
restaurants = [jules_verne, bluebird, daniel]
Restaurant.filter_by_city(restaurants, "london") # => [ #<Restaurant:0x007f9a43bb7eb8 @city="london", @name="Bluebird"> ]
```

## Key learning points

Are you able to answer the following questions? (Go into the doc if necessary)

- Among #rate and .filter_by_city, which one is an instance method? Which one is a class method?
- Look at the list below. Which ones are which?

```ruby
Date.today
Twitter::REST::Client#follow (see https://github.com/sferik/twitter)
String#upcase
Nokogiri::HTML::Document.parse #(see http://www.rubydoc.info/gems/nokogiri/Nokogiri/XML/Document)
Array#shuffle
```

- optional: Looking at thfe new and initialize methods, which one is an instance method? Which one is a class method? How do they relate to each other? Which one is sub-calling the other?

  HEREDOC
)

Challenge.create(
  name: "Associations",
  module: "Active Record",
  system_prompt: "You must not invoke rails commands as students are working on a Ruby app with ActiveRecord stand-alone and haven't seen Rails yet.",
  content: <<-HEREDOC
## Background & Objectives

Let’s continue with our Hacker News app. Today we want to add a user layer, so that you need to log in first before submitting a new post.

(You don’t need to log in to view posts though)
Setup

We’ve given you a first migration to create the posts table.

```bash
rake db:create
rake db:migrate
```

## Specs

### Add a User model

We provide you the basic schema of posts (see existing migration in db/migrate folder).

First generate a new migration to create the User model. The model should have the following fields:

```bash
username
email
```

### Migration: a User has many posts

Generate another migration to create a one-to-many reference between User and Post.

Make sure you add the code in your models to allow you to access posts from a user instance, and the user from a given post instance.

### Seed with user and posts

Write a seed that populates your database with 5 users who each have between 5 and 10 posts. Feel free to use any strategy you want (faker or API).

Don’t spend too much time trying to use the API. Remember that our goal here is to work with associations.
  HEREDOC
)
