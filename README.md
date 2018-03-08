Getting Started [![Build Status](https://travis-ci.org/twitterdev/twitter-ruby-ads-sdk.svg?branch=master)](https://travis-ci.org/twitterdev/twitter-ruby-ads-sdk) [![Code Climate](https://codeclimate.com/github/twitterdev/twitter-ruby-ads-sdk/badges/gpa.svg)](https://codeclimate.com/github/twitterdev/twitter-ruby-ads-sdk) [![Test Coverage](https://codeclimate.com/github/twitterdev/twitter-ruby-ads-sdk/badges/coverage.svg)](https://codeclimate.com/github/twitterdev/twitter-ruby-ads-sdk/coverage) [![Gem Version](https://badge.fury.io/rb/twitter-ads.svg)](http://badge.fury.io/rb/twitter-ads)
------

##### Installation
```bash
# installing the latest signed release
gem install twitter-ads
```

##### Quick Start
```ruby
require 'twitter-ads'

# initialize the client
client = TwitterAds::Client.new(
  CONSUMER_KEY,
  CONSUMER_SECRET,
  ACCESS_TOKEN,
  ACCESS_TOKEN_SECRET
)

# load the advertiser account instance
account = client.accounts('c3won9gy')

# load and update a specific campaign
campaign = account.campaigns('4m0gjms')
campaign.entity_status = EntityStatus::PAUSED
campaign.save

# iterate through campaigns
account.campaigns.each do |camp|
  # do stuff
end
```

##### Command Line Helper
```bash
# The twitter-ads command launches an interactive session for testing purposes
# with a client instance automatically loaded from your .twurlrc file.

~ ❯ twitter-ads
twitter-ads vX.X.X >> CLIENT
=> #<TwitterAds::Client:0x70101526238580 consumer_key="Fy90KQy57152sn5Mv7axji9409">
twitter-ads vX.X.X >> CLIENT.accounts.first
=> #<TwitterAds::Account:0x70101527905720 id="4lvtcum">
```
For more help please see our [Examples and Guides](https://github.com/twitterdev/twitter-ruby-ads-sdk/tree/master/examples) or check the online [Reference Documentation](http://twitterdev.github.io/twitter-ruby-ads-sdk/reference/index.html).

## Compatibility & Versioning

This project is designed to work with Ruby 2.0.0 or greater. While it may work on other version of Ruby, below are the platform and runtime versions we officially support and regularly test against.

Platform | Versions
-------- | --------
MRI | 2.0.0, 2.1.x, 2.2.x, 2.3.x
JRuby | 1.7.x, 9.0.0.0 (JDK7, JDK8, OpenJDK)
Rubinius | 2.4.x, 2.5.x

All releases adhere to strict [semantic versioning](http://semver.org). For Example, major.minor.patch-pre (aka. stick.carrot.oops-peek).

## Development
If you'd like to contribute to the project or try an unreleased development version of this project locally, you can do so quite easily by following the examples below.
```bash
# clone the repository
git clone git@github.com:twitterdev/twitter-ruby-ads-sdk.git
cd twitter-ruby-ads-sdk

# install dependencies
bundle install

rake docs # building documentation
rake spec # run all tests

# installing a local unsigned release
gem build twitter-ads.gemspec & gem install twitter-ads-X.X.X.gem
```
We love community contributions! If you're planning to send us a pull request, please make sure read our [Contributing Guidelines](https://github.com/twitterdev/twitter-ruby-ads-sdk/blob/master/CONTRIBUTING.md) first.

## Feedback and Bug Reports
Found an issue? Please open up a [GitHub issue](https://github.com/twitterdev/twitter-ruby-ads-sdk/issues) or even better yet [send us](https://github.com/twitterdev/twitter-ruby-ads-sdk/blob/master/CONTRIBUTING.md) a pull request.<br/>
Have a question? Want to discuss a new feature? Come chat with us in the [Twitter Community Forums](https://twittercommunity.com/c/advertiser-api).

## Error Handling

Like the [Response](https://github.com/twitterdev/twitter-ruby-ads-sdk/blob/master/lib/twitter-ads/http/response.rb) and [Request](https://github.com/twitterdev/twitter-ruby-ads-sdk/blob/master/lib/twitter-ads/http/request.rb) classes, the Ads API SDK fully models all [error objects](https://github.com/twitterdev/twitter-ruby-ads-sdk/blob/master/lib/twitter-ads/error.rb) for easy error handling.

<img src="http://i.imgur.com/opbv7Nh.png"/ alt="Error Hierarchy">

## License

The MIT License (MIT)

Copyright (C) 2015 Twitter, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
