# From webmaster-gallery/test/unit/views/layouts/_shared.rb

module ActiveSupportTestCaseMethods
  module Unit
    module Views
      module Layouts

        private

# render_layout - good, as is
# To achieve the following invocation of render, for example:
#   render :file => App.root.join('app/views/layouts/application'), :locals =>
#       {:@suppress_buttons => true}
# Invoke in this way:
#   render_layout :@suppress_buttons => true
# Another way to do it:
#    @controller.instance_variable_set(:@suppress_buttons, true)

        def render_layout(filename, instance_variables={})
          render :file => filename, :locals => instance_variables
        end

      end
    end
  end
end
