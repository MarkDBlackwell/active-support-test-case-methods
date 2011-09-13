#active-support-test-case-methods

NOT READY YET

A Rails plugin containing various ActiveSupport::TestCase methods.

##Example Usage

##How To Install
In your Rails application:

```bash
rails install plugin git://github.com/MarkDBlackwell/active-support-test-case-methods.git
```

##Requirements
The plugin works with Test/Unit -- and maybe it will work with other 
test systems, too.

In your file, 'test/test_helper.rb', below the line, 'class 
ActiveSupport::TestCase' insert:

```ruby
include ActiveSupportTestCaseMethods

```

##Testing
Developed with Rails 3.0.9 & Ruby 1.8.7, it was tested by my app, before 
making it a plugin.

TODO -- more testing.
Please let me know if you find anything wrong with it.

Copyright (c) 2011 Mark D. Blackwell. See [MIT-LICENSE](MIT-LICENSE) for details.
