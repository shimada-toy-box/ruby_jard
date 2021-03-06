# frozen_string_literal: true

module RubyJard
  class Layouts
    NarrowVerticalLayout = RubyJard::Templates::LayoutTemplate.new(
      min_width: 40,
      min_height: 24,
      fill_height: false,
      children: [
        RubyJard::Templates::LayoutTemplate.new(
          height_ratio: 80,
          width_ratio: 100,
          children: [
            RubyJard::Templates::ScreenTemplate.new(
              screen: :source,
              height_ratio: 60
            ),
            RubyJard::Templates::ScreenTemplate.new(
              screen: :variables,
              height_ratio: 40
            )
          ]
        ),
        RubyJard::Templates::ScreenTemplate.new(
          height: 2,
          screen: :menu
        )
      ]
    )
  end
end
RubyJard::Layouts.add_layout('narrow-vertical', RubyJard::Layouts::NarrowVerticalLayout)
