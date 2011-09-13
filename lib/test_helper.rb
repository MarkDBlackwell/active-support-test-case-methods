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

  def mock_model(model,method,expected)
    expected=case
# See ActiveRecord::Base method, '==='. Another way is to use object_id:
    when DirectoryPicture==model then Picture
    when FileTag         ==model then Tag
    end.all.map &method if :all==expected
    model.expects(:all).at_least_once.returns(expected.sort.reverse.
        map{|e| (p=model.new).expects(method).at_least_once.returns e; p} )
  end

  def mock_unpaired_names(expected)
    DirectoryPicture.expects(:find_unpaired_names).at_least_once.returns(
        expected.sort.reverse)
  end

  def model_names(model)
    model.capitalize.constantize.all.map &"#{'file' if 'picture'==model}name".
        to_sym
  end

  def see_output(s=nil)
    a = %w[rendered response].map{|e|(!respond_to? e) ? nil : (send e)}
    a.push(a.pop.body) if a.last
    (a.unshift s).compact!
    assert_present a, 'nothing defined'
    f=App.root.join('out/see-output').open 'w'
    f.print a.first
    f.close
  end

  def series(start,count=1)
    o=object=nil
    Array.new(count){o=o.blank? ? start : o.succ}
  end

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
