Factory.define :item do |f|
  f.sequence(:label) { |n| "a label#{n}"}
  f.sequence(:value) { |n| "a value#{n}"}
end

Factory.define :user do |f|
  f.name "Frisky Fitzpatrick"
end

Factory.define :trolley do |f|
  f.association :user
end

Factory.define :order do |f|
  f.association :trolley
end

Factory.define :note do |f|
  f.body "a test body"
  f.association :order
  f.association :user
end
