# From webmaster-gallery/test/test_helper.rb

module ActiveSupportTestCaseMethods
  
# Note: some of these methods use *pairs* of models: e.g., Picture and DirectoryPicture, Tag and FileTag.

# TODO: Perhaps, to generalize these methods, change to define the pairs somewhere. So, it could be called, 'model_pairs'.
# TODO: write, 'so you can do: myModel ...'

  module TestHelper

    private

# construct_changes_strings
# sub:
#   model_names
#   series

    def construct_changes_strings(model,operation,count=1)
      expected=model_names model
      case operation
      when 'delet' then changed=expected.pop count
      when 'add'
        changed=series "added#{ 'picture'==model ? '.png' : '-name' }", count
        expected=expected.take(count).concat changed
      end
      [expected,changed]
    end

# mock_expected
# Perhaps, change: rename to, 'mock_all_my_models_expected'.
# Not show.
# sub:
#   application-dependent:
#     mock_file_tags
#     mock_directory_pictures
#     mock_unpaired_names

    def mock_expected(model,expected)
      other='tag'==model ? [] : :all
      t,p  ='tag'==model ? [expected,other] : [other,expected]
      mock_file_tags          t
      mock_directory_pictures p
      mock_unpaired_names []
    end

# mock_model - (pairs only)
# Perhaps, change, to use: 'model_pairs' (defined above).
# Or, pass two models.
# sub:
#   (none)

    def mock_model(model,method,expected)
      expected=case
# See ActiveRecord::Base method, '==='. Another way is to use object_id:
      when DirectoryPicture==model then Picture
      when FileTag         ==model then Tag
      end.all.map &method if :all==expected
      model.expects(:all).at_least_once.returns(expected.sort.reverse.
          map{|e| (p=model.new).expects(method).at_least_once.returns e; p} )
    end

# mock_model_bad_names
# Was, 'mock_directory_picture_bad_names', etc.
# Perhaps, change: instead, parameterize the model, making it:
# Invoke 'mock_model_bad_names(DirectoryPicture,expected)'.
# sub:
#   (none)

    def mock_model_bad_names(model,expected)
      model.expects(:find_bad_names).returns expected.sort.reverse
    end

# mock_model_simple
# Was: mock_directory_pictures - itself application-dependent
# Perhaps, change: instead, parameterize the model, making it:
# Instead, invoke 'mock_model_simple(DirectoryPicture,expected)'.
# sub:
#   mock_model

    def mock_model_simple(model,expected=:all)
      mock_model model, :name, expected
    end

# mock_model_unpaired_names
# Was: mock_unpaired_names
# Perhaps, change: instead, parameterize the model, making it:
# Instead, invoke 'mock_model_bad_names(DirectoryPicture,expected)'.
# sub:
#   (none)

    def mock_model_unpaired_names(model,expected)
      model.expects(:find_unpaired_names).at_least_once.returns(
          expected.sort.reverse)
    end

# model_names - good, as is
# sub:
#   (none)

    def model_names(model)
      model.capitalize.constantize.all.map &"#{'file' if 'picture'==model}name".
          to_sym
    end

# see_output - good, as is
# Note: required is, 'App.root'. Is this automatic, in Rails?
# sub:
#   (none)
# So, in a test, whether controller or view, you can say:
#   see_output
# or
#   see_output some_string
# and the generated web page will be copied, complete, into the file, 'out/see-output'.

    def see_output(s=nil)
      a = %w[rendered response].map{|e|(!respond_to? e) ? nil : (send e)}
      a.push(a.pop.body) if a.last
      (a.unshift s).compact!
      assert_present a, 'nothing defined'
      f=App.root.join('out/see-output').open 'w'
      f.print a.first
      f.close
    end

# series - good, as is
# sub:
#   (none)
# So you can say:
#   series 'aaa', 3
# and it will return
#   %w[aaa aab aac]

    def series(start,count=1)
      o=object=nil
      Array.new(count){o=o.blank? ? start : o.succ}
    end

# try_code - good, as is
# Note: change 'to_s' to 'join', for Ruby 1.9, since on Array.
# sub:
#   (none)
# Possibly useful while experimenting at the Rails console, when unsure how something gets passed, whether as a local variable, or an instance variable.
# TODO: Find out how really to do this.
# So, if you say:
#   class A < SomeTestClass
#   a=1; @a=2; try_code 'a'; end; A.new
# the console will print:
#    a.inspect:1
#   @a.inspect:2
# or if you say:
#   try_code 'bad_stuff'
# it will print:
#    bad_stuff.inspect:NameError: undefined local variable or method `a' for main:Object
#         from...
#   @bad_stuff.inspect:"nil"

    def try_code(a)
      a=[a] unless a.kind_of? Array
      code=a.product(['','@']).map(&:reverse).map &:to_s
      labels= code.map{|e| "#{e}.inspect:"}
      results=code.map do |e|
        begin
          (eval e).inspect
        rescue => error
          error
        end
      end
      labels.zip(results).flatten.map{|e| e.to_s+"\n"}
    end

  end
end
