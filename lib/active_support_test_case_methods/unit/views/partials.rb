# From webmaster-gallery/test/unit/views/partials/_shared.rb

module ActiveSupportTestCaseMethods
  module Unit
    module Views
      module Partials

        private

# controller_yield - good, as is

        def controller_yield
# Without setup_with_controller, another render appends the response, increasing
# any assert_select counts.
          (setup_with_controller; yield) if block_given?
        end

# render_partial - good, as is

        def render_partial(p,local_assigns={})
# ActionView::TestCase::Behavior#, which invokes ActionView::Rendering#:
          if local_assigns.blank? # Work around bugs:
            render :partial => p
          else
            render p, local_assigns
          end
          @partial=p.clone.insert p.index(?/)+1, '_'
        end

      end
    end
  end
end
