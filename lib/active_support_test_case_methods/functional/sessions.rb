# From webmaster-gallery/test/functional/sessions/_shared.rb

module ActiveSupportTestCaseMethods
  module Functional
    module Sessions

      private

# login - good, as is

      def login(p=nil)
        p=get_password if p.blank?
        set_cookies
        post :create, :password => p
      end

# remove_read_permission - good, as is

      def remove_read_permission(path)
        mode=path.stat.mode
        path.chmod(mode ^ 0444) # Remove read permissions.
        begin assert_nothing_raised{yield}
        ensure path.chmod mode end
      end

    end
  end
end
