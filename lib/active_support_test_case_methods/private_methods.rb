require 'active_support_test_case_methods/unit/views/layouts'
require 'active_support_test_case_methods/unit/views/partials'
require 'active_support_test_case_methods/unit/views'
require 'active_support_test_case_methods/unit/models'
require 'active_support_test_case_methods/functional/admin_pictures'
require 'active_support_test_case_methods/functional/application'
require 'active_support_test_case_methods/functional/sessions'
require 'active_support_test_case_methods/functional'
require 'active_support_test_case_methods/test_helper'

module ActiveSupportTestCaseMethods
  module PrivateMethods

    include ::ActiveSupportTestCaseMethods::Unit::Views::Layouts
    include ::ActiveSupportTestCaseMethods::Unit::Views::Partials
    include ::ActiveSupportTestCaseMethods::Unit::Views
    include ::ActiveSupportTestCaseMethods::Unit::Models
    include ::ActiveSupportTestCaseMethods::Functional::AdminPictures
    include ::ActiveSupportTestCaseMethods::Functional::Application
    include ::ActiveSupportTestCaseMethods::Functional::Sessions
    include ::ActiveSupportTestCaseMethods::Functional
    include ::ActiveSupportTestCaseMethods::TestHelper

  end
end
