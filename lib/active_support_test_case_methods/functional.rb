module ActiveSupportTestCaseMethods
  module Functional

    private

# assert_filter - good, as is

    def assert_filter(filter)
      assert_filter_kind :before, filter, []
    end

# assert_filter_kind - good, as is

    def assert_filter_kind(kind,filter,sa=nil)
      if sa.blank? then skip_actions=[]
      else
        sa=[sa] unless sa.kind_of? Array
        skip_actions=[sa.map{|e| "action_name == '#{e}'"}.join ' || ']
      end
      desired=[filter, filter, kind, skip_actions]
      ours=['ApplicationController',(self.class.to_s.chomp 'Test')].
            map do |class_name|
        filter_chain.select{|e| e.klass.to_s==class_name}
      end.flatten 1
      have=ours.map{|e| [e.raw_filter, e.filter, e.kind, e.per_key.fetch(
          :unless)]}
      assert have.include?(desired), ([
          'Found:', have.map{|e| e.uniq.inspect},
          'Desired:', ([filter,kind,sa].map{|e| e.inspect}.join ', '),
          ].join "\n")
    end

# assert_filter_skips - good, as is

    def assert_filter_skips(filter, actions)
      assert_filter_kind :before, filter, actions
    end

# assert_flash_blank - good, as is

    def assert_flash_blank
      assert_blank [:error,:notice].map{|e| [flash[e],flash.now[e]]}.to_s
    end

# assert_logged_in - good, as is

    def assert_logged_in
      assert_equal true, session[:logged_in]
    end

# assert_no_filter - good, as is

    def assert_no_filter(filter)
      assert_no_filter_kind :before, filter
    end

# assert_no_filter_kind - good, as is

    def assert_no_filter_kind(kind,filter)
      undesired=[filter, filter, kind]
      class_name=self.class.to_s.chomp 'Test'
      ours=filter_chain.select{|e| e.klass.to_s==class_name}
      have=ours.map{|e| [e.raw_filter, e.filter, e.kind]}
      assert_equal false, have.include?(undesired), ([
          'Found:', have.map{|e| e.uniq.inspect},
          'Undesired:', ([filter,kind].map{|e| e.inspect}.join ', '),
          ].join "\n")
    end

# assert_not_logged_in - good, as is

    def assert_not_logged_in
      assert_blank session[:logged_in]
    end

# assert_nothing_rendered - good, as is

    def assert_nothing_rendered
      assert_template # No template.
    end

# Needs tweaking
# assert_routing - needs tweaking

    def assert_routing(*args)
      k=:path
      path=case args.first
      when String then args.first
      when Hash   then args.first[k] end
      prefix='/webmas-gallery'
      path = prefix.present? && '/'==path ? '' : path
      case args.first
      when String
        args[0] = prefix + path
      when Hash
        args[0][k] = prefix + path
      end
      super *args 
    end

# filter - good, as is

    def filter
      @controller.send @filter
    end

# filter_chain - good, as is

    def filter_chain
# TODO: Maybe use api.rubyonrails.org/classes/ActionController/Testing/ClassMethods.html method, 'before_filters'.
      @controller._process_action_callbacks
    end

# pretend_logged_in - good, as is

    def pretend_logged_in
      session[:logged_in]=true
      set_cookies
    end

# set_cookies - good, as is

    def set_cookies
      request.cookies[:not_empty]='not_empty'
    end

# test_happy_path_response - good, as is

    def self.test_happy_path_response(action=nil)
      test "happy path" do
        happy_path
        if action.present?
          assert_redirected_to :action => action
        else
          assert_response :success
        end
      end
    end

# test_routing_tag - good, as is

    def self.test_routing_tag(directory_root=false)
      test "routing with and without tag should..." do
        cn=@controller_name.to_s
        h={:controller => cn, :action => @action.to_s}
        tag='some-tag'
        r=Pathname.new '/'
        c=r.join cn
# Allow controller name with tag:
        assert_routing (c.join tag).to_s, (h.merge :tag => tag)
        unless directory_root
# Option 1...:
# Allow controller name alone:
          assert_routing c.to_s, h
        else
# Option 2...:
# Disallow controller name alone:
          assert_raise(ActionController::RoutingError){assert_routing c.to_s, h}
# Allow directory root:
          assert_routing r.to_s, h
        end
      end
    end

  end
end
