# frozen_string_literal: true

module RubyJard
  module Commands
    ##
    # Show a screen
    class ShowCommand < Pry::ClassCommand
      description 'Show a screen'
      banner <<-BANNER
        Usage: jard show [-h] [screen]
      BANNER
      match 'show'

      def initialize(context = {})
        super(context)

        @screens = context[:screens] || RubyJard::Screens
        @config = context[:config] || RubyJard.config
      end

      def process
        screen = args.first.to_s.strip

        if screen.empty?
          raise Pry::CommandError,
                "Please input one of the following: #{@screens.names.join(', ')}"
        end

        unless @screens.names.include?(screen)
          raise Pry::CommandError,
                "Screen `#{screen}` not found. Please input one of the following: #{@screens.names.join(', ')}"
        end

        @config.enabled_screens << screen
        @config.enabled_screens.uniq!

        RubyJard::ControlFlow.dispatch(:list)
      end
    end
  end
end
