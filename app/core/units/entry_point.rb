# frozen_string_literal: true

module Units
  module EntryPoint
    extend ActiveSupport::Concern

    delegate :call, to: :action

    included do
      attr_accessor :action
    end

    class_methods do
      def call(...)
        new(...).call
      end
    end
  end
end
