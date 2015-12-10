# Contributing Guidelines

We love pull requests from everyone!

We encourage community contributions for all kinds of changes
both big and small, but we ask that you adhere to the following guidelines for contributing code.

##### Proposing Changes

As a starting point for all changes, we recommend [reporting an issue][report-issue]
before you begin making any changes. Make sure to search the issues on this repository
first to check and see the issue has already been previously discussed and whether or
not it's already being worked on.

- For small changes, improvements and bug fixes please feel free to send us a pull
request with proposed changes along-side the issue you report.

- For larger more involved or design related changes, please open an issue and discuss
the changes with the other contributors before submitting any pull requests.

[report-issue]: https://github.com/twitterdev/twitter-ruby-ads-sdk/issues?q=is%3Aopen+is%3Aissue

##### Submitting A Pull Request

1) Fork us and clone the repository locally.

```bash
git clone git@github.com:twitterdev/twitter-ruby-ads-sdk.git
```

2) Install development dependencies:

```bash
# install bundler (if you don't have it already)
gem install bundler

# install all development dependencies
bundle install
```

3) Make sure all tests pass before you start:

```bash
rake
```

4) Make your changes! (Don't forget tests and documentation)

5) Test your changes again and make sure everything passes:

```bash
rake
```

The test suite will automatically enforce test coverage and code style.
For the most part, we follow [this][style] community style guide with a
[few exceptions](https://github.com/twitterdev/twitter-ruby-ads-sdk/blob/master/.rubocop.yml).

[style]: https://github.com/bbatsov/ruby-style-guide

6) Submit your changes!

- [Squash](http://eli.thegreenplace.net/2014/02/19/squashing-github-pull-requests-into-a-single-commit) your development commits. Put features in a single clean commit whenever possible or logically split it into a few commits (no development commits). Test coverage can be included in a separate commit if preferred. 
- Write a [good commit message][commit] for your change.
- Push to your fork.
- Submit a [pull request][pr].

[commit]: http://chris.beams.io/posts/git-commit/
[pr]: https://github.com/thoughtbot/suspenders/compare/

We try to at least comment on pull requests within one business day and may suggest changes.

##### Release Schedule and Versioning

We have a regular release cadence and adhere to [semantic versioning](http://semver.org/). When
exactly your change ships will depend on the scope of your changes and what type of upcoming release
its best suited for.
