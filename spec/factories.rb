Factory.define :user do |user|
  user.name                   "John Doe"
  user.email                  "john@doe.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end