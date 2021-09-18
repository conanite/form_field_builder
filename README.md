# FormFieldBuilder

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'form_field_builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install form_field_builder

## Usage


```haml

- ffb = FormFieldBuilder::Decorated.new @widget, { tag: :div }

%form(method='post' action='/widgets')
  = ffb.text_input     :name
  = ffb.date_input     :start
  = ffb.quantity_input :size
  = ffb.price_input    :price
  = ffb.text_area      :description
  %input(type='submit')
```

generates a html form as you might expect, using your I18n to look up labels, and a node with class `error_container` for your js form validation errors. Example

```html
  <div>
    <label for='widget_name'>Wie heißt dein Widget?</label>
    <div class='error_container'></div>
    <input id='widget_name' type='text' name='widget[name]' value='Henkel'/>
  </div>
```

Each `*_input` method takes options controlling:

* the origin of texts for labels and descriptions and placeholders
* whether to show labels, descriptions, placeholders
* what prefix to use (by default the underscored classname)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/form_field_builder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
