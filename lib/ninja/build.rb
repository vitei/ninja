module Ninja
  class Build
    attr_reader :rule,
                :inputs,
                :output,
                :variables,
                :implicit_deps,
                :order_only_deps

    def initialize(desc={})
      Description.validate!(desc)

      @rule = desc[:rule]
      @inputs = [*desc[:inputs]]
      @output = desc[:output]
      @variables = desc.fetch(:variables, {})
      @implicit_deps = desc.fetch(:implicit_deps, {})
      @order_only_deps = desc.fetch(:order_only_deps, {})
    end

    module Description #:nodoc:
      def self.validate!(desc)
        # This might be overkill, but we want this to be idiot-proof.
        raise "Rule not specified." unless desc.include?(:rule)
         raise "Expected rule to be a string composed of [a-Z,0-9,-,_] characters." unless /\A([-\w]+?)+\z/.match(desc[:rule])

        raise "Inputs not specified." unless desc.include?(:inputs)
         # TODO(mtwilliams): Check type of elements.
         raise "Expected inputs to be an array of paths." unless desc[:inputs].is_a?(Array)
        raise "Output not specified." unless desc.include?(:output)
         # TODO(mtwilliams): Check if paths exist.
         raise "Expected output to be a path." unless desc[:output].is_a?(String)

         if desc.has_key?(:variables)
           desc[:variables].each do |name, value|
             raise "Expected name to be a string made of [a-Z,_,-,0-9] characters." unless /\w/.match(name)
           end
         end

         if desc.has_key?(:implicit_deps)
           raise "Expected implicit dependencies." unless ! desc[:implicit_deps].empty?

           desc[:implicit_deps].each do |dep|
             raise "Expected implicit dependencies to be non-nil" unless dep != nil
           end
         end

         if desc.has_key?(:order_only_deps)
           raise "Expected order only dependencies." unless ! desc[:order_only_deps].empty?

           desc[:order_only_deps].each do |dep|
             raise "Expected order only dependencies to be non-nil" unless dep != nil
           end
         end
      end
    end
  end
end
