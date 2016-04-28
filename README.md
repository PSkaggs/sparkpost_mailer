# SparkpostMailer

This is a wrapper for the sparkpost gem.  Just about everything here was a straight copy and paste from the mandrill_mailer gem.  Since Mandrill charges now I switched to SparkPost and needed something to get what I had to work like the Mandrill setup.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sparkpost_mailer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sparkpost_mailer

## Usage

This is how I'm using it:

Initializer
setup_mail.rb

```ruby
ActionMailer::Base.smtp_settings = {
  :address   => "smtp.sparkpostmail.com",
  :port      => 587,
  :Encryption => "STARTTLS",
  :Authentication => "AUTH LOGIN",
  :User => "SMTP_Injection",
  :password  => ENV['SPARKPOST_API_KEY']
}
ActionMailer::Base.delivery_method = :smtp

SparkPostMailer.configure do |config|
  config.api_key = ENV['SPARKPOST_API_KEY']
end
```
application.rb
```ruby
  config.sparkpost_mailer.default_url_options = { :host => "somehost.com" }
```
notification_mailer.rb
```ruby
class NotificationMailer < SparkPostMailer::PayloadMailer

  def render(path)
      template = Tilt.new(path)
      template.render(self)
  end

  def added_to_project(user, project)
    @user = user
    @project = project
    payload = {
       recipients: [{ address: { email: @user.email } }],
       content: {
         from: "some_email@email.email",
         subject: "You've been added to a project",
         template_id: 'mailer_template_id'
       },
       substitution_data: {
         name: @user.name,
         LOGO: "#{image_url('ui/spark_logo.png')}",
         PAGETITLE: "This is an automated message from #{ActionMailer::Base.default_url_options[:host]}",
         PAGEBODY: render("app/views/notification_mailer/added_to_project.html.slim")
       }
     }
    response = self.deliver(payload)
    puts response
  end

end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PSkaggs/sparkpost_mailer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
