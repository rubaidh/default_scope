module Rubaidh
  module DefaultScope
    def self.included(base)
      base.extend(ActsMethods)
    end

    module ActsMethods
      def default_scope(options = {})
        # Extend by setting up the new find and count.
        unless extended_by.include? ClassMethods
          class_inheritable_accessor :default_scope_options
          extend ClassMethods
          class << self
            alias_method_chain :find, :default_scope
            alias_method_chain :count, :default_scope
          end
        end
        self.default_scope_options = options
      end
    end

    module ClassMethods
      def find_with_default_scope(*args)
        with_default_scope do
          find_without_default_scope(*args)
        end
      end

      def count_with_default_scope(*args)
        with_default_scope do
          count_without_default_scope(*args)
        end
      end

      private
      def with_default_scope
        with_scope(default_scope_options) do
          yield
        end
      end

    end
  end
end