# NseData

**NseData** is a Ruby gem for retrieving stock market data from the National Stock Exchange (NSE) of India. It provides a simple interface to interact with NSE's APIs and fetch real-time and historical stock market data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nse_data'
```
And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install nse_data
```

## Usage

To use the gem, create a new instance of the NseData::Client and make API calls:

```ruby
require 'nse_data'

client = NseData::Client.new

# Fetch data from the special pre-open listing endpoint
response = client.get('special-preopen-listing')

# Output the response (which is a Hash)
puts response
```

## Development

To contribute to this gem, follow these steps:

1. Fork the repository.
2. Create a new branch (git checkout -b feature-branch).
3. Make your changes.
4. Write tests for your changes.
5. Run the tests (bundle exec rspec).
6. Submit a pull request.

### Running Tests
To run the test suite, use:

```bash
bundle exec rspec
```
### Code Style
The gem uses RuboCop for linting and code style enforcement. Run RuboCop with:

```bash
bundle exec rubocop
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ahasunos/nse_data. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/nse_data/blob/master/CODE_OF_CONDUCT.md).

Please make sure to update tests as appropriate.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NseData project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/nse_data/blob/master/CODE_OF_CONDUCT.md).

## Upcoming Features
Here’s a glimpse of what’s planned for future dev:

- Support for Additional Endpoints: We aim to support more NSE API endpoints, allowing you to fetch a wider range of market data.
- Enhanced Error Handling: Improve the gem's error handling to provide more informative error messages.
- Caching Mechanism: Implement caching to reduce the number of API calls and improve performance.
- Historical Data: Add support for fetching historical market data.
- Rate Limiting: Integrate rate limiting to handle NSE API’s rate limits more effectively.
- Improved Documentation: Enhance documentation with more examples and detailed usage instructions.
