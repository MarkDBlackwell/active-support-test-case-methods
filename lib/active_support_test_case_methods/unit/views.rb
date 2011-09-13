module ActiveSupportTestCaseMethods
  module Unit
    module Views

      private

# 

      def assert_partial(*args)
        p=c=nil
        [args].flatten.each do |e|
          p=e if e.kind_of? String
          c=e if e.kind_of? Integer
        end
        p=@partial if p.blank?
        c=1 if c.blank?
 # ActionController::TemplateAssertions:
        assert_template :partial => p, :count => c
      end

# 

      def check_pretty_html_source(*args)
# TODO: remove array, 'type' (just show types in a comment, above). Use undef?
        type   = %w[  section  div            tag  other  ]
        prefix = %w[  <!--     <div\ class="  <           ]
        suffix = %w[  -->      "                          ]
        args.map!{|e| e=[] if e.blank?; e=[e] unless e.kind_of? Array; e}
        args=Array.new(type.length,[]).fill(nil,args.length){|i| args.at i}
# print args.inspect
        source=try(:rendered) || response.body
        big=Regexp.union( (0...args.length).map{|i|
            Regexp.new "#{prefix.at i}#{Regexp.union args.at i}#{suffix.at i}"} )
        line_start=Regexp.new %r"^#{big}"
        nl="\n"
# So far, the application has not required repeating this substitution:
        altered=source.gsub line_start, nl
        s=altered.clone.gsub! big, ''
        return if s.blank?
        anywhere_in_line=s.split nl
        a= altered.split nl
        flunk (0...a.length).reject{|i| a.at(i)==(anywhere_in_line.at i)}.map{|i|
            [(a.at i), (anywhere_in_line.at i), '']}.flatten.join nl
      end

# 

      def static_asset_matcher(s)
# TODO def static_asset_matcher(s) # Lost the digits; don't know why.
        e=Regexp.escape base_uri.join s
        Regexp.new %r"\A#{e}\d*\z"
      end

    end
  end
end
