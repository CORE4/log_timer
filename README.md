# LogTimer

If a service crashed silently, chances are, it does not write to its logs for a while. This
gem checks a list of log files if they changed recently and alerts you if a file is older
than the given limit.

## Installation

    $ gem install log_timer

## Usage

When you run the gem for the first time, use the `--init` parameter to generate a basic example config.
Then open ~/.log_timer.yml in your favorite editor (most likely vim) and add the (log) files you want to have checked.

When you run log_timer, it will check all files listed in the "files:" section and check their modification times.
If a file is older than the specified limit, it will warn you with a message. This is not yet as useful as I would want
to have it. So if you run `log_timer --mail` it will send a mail to you with the same info plus the last lines from
the file (either 10 or, if specified, the number given with "tail:").

A cronjob might look like this:

```crontab
0 * * * * log_timer --mail --quiet
```

The limit works with [chronic_duration](https://github.com/hpoydar/chronic_duration). Most likely you will need
something like "30d" for 30 days or 24 hours ("24h").

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/log_timer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

