# frozen_string_literal: true

module RubyJard
  module Decorators
    ##
    # Decorate Hash data structure, supports singleline and multiline form.
    class HashDecorator
      def initialize(generic_decorator)
        @generic_decorator = generic_decorator
        @attributes_decorator = RubyJard::Decorators::AttributesDecorator.new(generic_decorator)
      end

      def decorate_singleline(variable, line_limit:, depth: 0)
        spans = []
        spans << RubyJard::Span.new(content: '{', styles: :text_primary)
        spans += @attributes_decorator.inline_pairs(
          variable.each_with_index,
          total: variable.length, line_limit: line_limit - 2, process_key: true, depth: depth + 1
        )
        spans << RubyJard::Span.new(content: '}', styles: :text_primary)
      end

      def decorate_multiline(variable, first_line_limit:, lines:, line_limit:, depth: 0)
        if variable.size > lines * 1.5
          return do_decorate_multiline(variable, lines: lines, line_limit: line_limit, depth: depth)
        end

        singleline = decorate_singleline(variable, line_limit: first_line_limit)
        if singleline.map(&:content_length).sum < line_limit || variable.length <= 1
          [singleline]
        else
          do_decorate_multiline(variable, lines: lines, line_limit: line_limit, depth: depth)
        end
      end

      def match?(variable)
        RubyJard::Reflection.call_is_a?(variable, Hash)
      end

      private

      def do_decorate_multiline(variable, lines:, line_limit:, depth: 0)
        spans = [[RubyJard::Span.new(content: '{', styles: :text_primary)]]

        item_count = 0
        variable.each_with_index do |(key, value), index|
          spans << @attributes_decorator.pair(
            key, value, line_limit: line_limit, process_key: true, depth: depth + 1
          )
          item_count += 1
          break if index >= lines - 2
        end
        spans << last_line(variable.length, item_count)
      end

      def last_line(total, item_count)
        if total > item_count
          [
            RubyJard::Span.new(
              content: "▸ #{total - item_count} more...",
              margin_left: 2, styles: :text_dim
            ),
            RubyJard::Span.new(
              content: '}',
              styles: :text_primary
            )
          ]
        else
          [RubyJard::Span.new(content: '}', styles: :text_primary)]
        end
      end
    end
  end
end
