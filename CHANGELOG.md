# Changelog

[0.1.0] - 2024-09-10

## Added
- **Caching Mechanism**: Implemented a scalable & flexible caching mechanism to reduce unnecessary API requests. Currently, it supports in-memory caching, with configurable features like custom TTL, disable caching for certain APIs or force refresh API calls.

- **Logger Configuration**: Implemented a custom logging system that can be configured by users. By default, logs are written to system temporary files.

- **HttpClient**: Implemented a flexible HTTP client using Faraday, with support for future extensions to other libraries, if needed.

- **ApiManager**: Implemented an API Manager that sets up the base URL, loads API endpoints from a YAML file, creates dynamic methods for each endpoint, and integrates the caching mechanism with configurable TTL for API calls and no-caching for some endpoints.

- **RSpec Tests**: Added RSpec tests for core classes with code coverage over 90%.

- **Security Audit**: Verified gem dependencies using bundler-audit to ensure no known vulnerabilities.

## Usage Notes
For usage instructions, please refer to the documentation available in the README file.

## Future Work
**Core Logic Extraction**: Plan to extract the core API interaction logic into a separate gem.