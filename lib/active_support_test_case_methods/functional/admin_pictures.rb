module ActiveSupportTestCaseMethods
  module Functional
    module AdminPictures

      private

# assert_flag - good, as is

      def assert_flag(*a)
        a.each{|e| assert_present assigns(e), "@#{e} not set."}
      end

# assert_flash_errors - good, as is

      def assert_flash_errors(e=nil)
        if e.blank?
          (r=@record).valid?
          e=r.errors
        end
        assert_equal e.full_messages.map{|s| s+'.'}.join(' '),
            flash[:error]||''
      end

    end
  end
end
