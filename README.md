# InstagramUploader

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'instagram_uploader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install instagram_uploader

## Usage

Somewhere in your code:
```ruby
require 'instagram_uploader'
```

## Example
```ruby
require 'instagram_uploader'

uploader = InstagramUploader::Uploader.new('login', 'password')
uploader.upload('./image.jpg', 'image_description')
```

You can't upload an image with  description that will include control characters or symbol ' ( or many other things)
before uploading i change my desc to
```ruby
desc.gsub(/[\'\n]/, '  ').gsub(/[^[:print:]]/) {|x| x.ord}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/q3pp/instagram_uploader.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
