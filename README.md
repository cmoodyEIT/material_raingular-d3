# MaterialRaingular::D3

MaterialRaingular::D3 adds d3 v4.4 directives to your MaterialRaingular application
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'material_raingular-d3'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install material_raingular-d3

## Usage

```slim
  mr-d3-ring-widget
    h3
      | Bio Billability
    mr-d3-ring ring-data="[50,10]"
  mr-d3-pie-chart d3-data="{bio: 10, planning: 30, cr: 12}"
  mr-d3-horizontal-bar-chart.test ng-init="dataSet = [{l: 'a',v: 23},{l: 'b',v: 13},{l: 'c',v: 21},{l: 'd',v: 14},{l: 'e',v: 37},{l: 'f',v: 15},{l: 'g',v: 18},{l: 'h',v: 34},{l: 'i',v: 30}]"
    mr-d3-bar.thingy ng-repeat="data in dataSet" mr-d3-label="data.l" mr-d3-value="data.v"
    mr-d3-bar mr-d3-label="'this'" mr-d3-value="'200'"
    mr-d3-x-axis ng-init="domain = [0,37]" mr-d3-label="'Value'" mr-d3-domain='domain'

    mr-d3-stacked-bar mr-d3-label="'CA'"
      mr-d3-bar ng-repeat="data in [10,4,7]" mr-d3-label="data" mr-d3-value="data"
    mr-d3-stacked-bar mr-d3-label="'AZ'"
      mr-d3-bar ng-repeat="data in [10,4,7]" mr-d3-label="data" mr-d3-value="data"
    mr-d3-y-axis mr-d3-label="'Arbitrary'"

  mr-d3-bar-chart.test ng-init="dataSet = [{l: 'a',v: 23},{l: 'b',v: 13},{l: 'c',v: 21},{l: 'd',v: 14},{l: 'e',v: 37},{l: 'f',v: 15},{l: 'g',v: 18},{l: 'h',v: 34},{l: 'i',v: 30}]"
    mr-d3-bar.thingy ng-repeat="data in dataSet" mr-d3-label="data.l" mr-d3-value="data.v"
    mr-d3-bar mr-d3-label="'this'" mr-d3-value="'200'"
    mr-d3-y-axis ng-init="domain = [37,0]" mr-d3-label="'Value'" mr-d3-domain='domain'

    mr-d3-stacked-bar mr-d3-label="'CA'"
      mr-d3-bar ng-repeat="data in [10,4,7]" mr-d3-label="data" mr-d3-value="data"
    mr-d3-stacked-bar mr-d3-label="'AZ'"
      mr-d3-bar ng-repeat="data in [10,4,7]" mr-d3-label="data" mr-d3-value="data"
    mr-d3-x-axis mr-d3-label="'Arbitrary'"
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/material_raingular-d3. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
