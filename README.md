# NseData
## Table of Contents
- [NseData](#nsedata)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Installation](#installation)
  - [Usage](#usage)
    - [High-Level Interface](#high-level-interface)
    - [Low-Level API](#low-level-api)
  - [Configuration](#configuration)
    - [Example](#example)
    - [APIs Available](#apis-available)
  - [Development](#development)
    - [Running Tests](#running-tests)
    - [Code Style and Linting](#code-style-and-linting)
  - [Contributing](#contributing)
  - [License](#license)
  - [Code of Conduct](#code-of-conduct)

**NseData** is a Ruby gem designed to interact with the National Stock Exchange (NSE) of India's API, providing an easy-to-use interface for developers to retrieve stock market data. The gem offers a high-level API for most users and a lower-level API for advanced users who need more control over the interactions.

## Features
- Fetch stock market data from multiple NSE APIs
- High-level and low-level API interfaces
- Simple and clear error handling for HTTP requests
- Ruby 3.1 and 3.2 support with a test matrix across different OS
- Easy integration with CI/CD and coverage tools

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

### High-Level Interface
The high-level interface is designed to be simple and user-friendly. You can instantiate an object and call the available methods:

```ruby
require 'nse_data'

apis = NseData.list_all_endpoints
puts apis
```

### Low-Level API
For advanced users, the lower-level APIManager class offers more control over requests:

```ruby
require 'nse_data'

api_manager = NseData::APIManager.new
response = api_manager.fetch_data('index_names')
puts response.body # Returns index names in JSON format
```

where `index_names` is the name of the API routing to the path of https://www.nseindia.com/api/index-names

## Configuration
The gem uses an `api_endpoints.yml` file located in the config directory. This file maps API names to their respective endpoint URLs.

### Example
```yaml
  all_indices:
    path: "allIndices"
    description: "Fetches data of all available indices."
```

### APIs Available
  - **all_indices**: Fetches data of all available indices.
  - **circulars**: Provides a list of circulars.
  - **equity_master**: Fetches equity master data.
  - **glossary**: Fetches glossary content.
  - **holiday_clearing**: Fetches clearing holiday data.
  - **holiday_trading**: Fetches trading holiday data.
  - **index_names**: Fetches names of all indices.
  - **latest_circulars**: Provides the latest circulars.
  - **market_data_pre_open**: Fetches market pre-open data for all securities.
  - **market_status**: Fetches the current status of the market.
  - **market_turnover**: Fetches turnover data for the market.
  - **merged_daily_reports_capital**: Fetches merged daily reports for capital.
  - **merged_daily_reports_debt**: Fetches merged daily reports for debt.
  - **merged_daily_reports_derivatives**: Fetches merged daily reports for derivatives.

Please refer to the [api_endpoints.yml](lib/nse_data/config/api_endpoints.yml) file for the actual endpoint routing information.

## Development

To get started with contributing to **NseData**, follow these steps:

1. **Clone the repository**:

   First, clone the repository to your local machine and navigate to the project directory:

   ```bash
   git clone https://github.com/ahasunos/nse_data.git
   cd nse_data

2. **Install dependencies**:

   After navigating to the project directory, install the required gems using Bundler:

   ```bash
   bundle install
   ```

### Running Tests
The project uses RSpec for testing. Before submitting any changes, make sure to run the test suite to ensure that everything works as expected:

```bash
bundle exec rspec
```

### Code Style and Linting
To maintain consistent code quality and style, the project uses RuboCop for linting. Before submitting a pull request, ensure that your code adheres to the project's style guidelines by running RuboCop:

```bash
bundle exec rubocop
```

If RuboCop identifies any issues, it will provide suggestions for how to fix them.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ahasunos/nse_data. For major changes, please open an issue first to discuss what you would like to change.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NseData project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/nse_data/blob/master/CODE_OF_CONDUCT.md).
