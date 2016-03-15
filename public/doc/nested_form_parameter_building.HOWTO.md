# How to build `name` parameters in order to get the proper parameters to the controller

Funnily enough, I could not find much info about this on the Internet, so this
is just trial-and-error guesswork.

* `name: 'a[b]'` => `{ :a => { :b => value } }`
* `name: 'a[b][]'` => `{ :a => { :b => [ value, value, value, ... ] } }`
* `name: 'a[b][][c]'` => `{ :a => { :b => [ { :c => value }, { :c => value }, ... ] } }`
* `name: 'a[b][][c][][d]'` => `{ :a => { :b => [ { :c => [ { :d => value }, { :d => value }, ... ] }, { :c => [ { :d => value }, ... ] } } }`

## Example

```ruby

{ name: 'works_roles_authors[authors_attributes][][id]' }

# and

{ name: 'works_roles_authors[authors_attributes][][roles_attributes][][id]' }

# produce

{"works_roles_authors"=>{"authors_attributes"=>[{"id"=>"6", "roles_attributes"=>[{"id"=>"7"}, {"id"=>"6"}, {"id"=>"2"}, {"id"=>"4"}, {"id"=>""}]},
                                                {"id"=>"13", "roles_attributes"=>[{"id"=>"2"}, {"id"=>"4"}, {"id"=>""}]},
                                                {"id"=>"15", "roles_attributes"=>[{"id"=>"8"}, {"id"=>"6"}, {"id"=>"4"}, {"id"=>"5"}, {"id"=>""}]}]}}
```
