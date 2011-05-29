Factory.define :user do |user|
  user.name                   "John Doe"
  user.email                  "john@doe.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@examle.com"
end

Factory.define :micropost do |mp|
  mp.content      "foobar"
  mp.association  :user
end