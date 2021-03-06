# frozen_string_literal: true

RSpec.describe 'Source screen', integration: true do
  let(:work_dir) { File.join(RSPEC_ROOT, '/integration/screens/source') }

  context 'when jard stops at top-level binding' do
    it 'displays correct line' do
      test = JardIntegrationTest.new(
        self, work_dir, 'record.top_level_example',
        "bundle exec ruby #{RSPEC_ROOT}/examples/top_level_example.rb"
      )
      test.start
      test.assert_screen
      test.send_keys('next', :Enter)
      test.assert_screen
      test.send_keys('next', :Enter)
      test.assert_screen
      test.send_keys('continue', :Enter)
      test.assert_screen
    ensure
      test.stop
    end
  end

  context 'when jard stops inside an instance method' do
    it 'displays correct line' do
      test = JardIntegrationTest.new(
        self, work_dir,
        'record.instance_method',
        "bundle exec ruby #{RSPEC_ROOT}/examples/instance_method_example.rb"
      )
      test.start
      test.assert_screen
      test.send_keys('continue', :Enter)
      test.assert_screen
      test.send_keys('continue', :Enter)
      test.assert_screen
      test.send_keys('continue', :Enter)
      test.assert_screen
    ensure
      test.stop
    end
  end

  context 'when jard stops within a nested method' do
    it 'displays correct line' do
      test = JardIntegrationTest.new(
        self, work_dir,
        'record.nested_method',
        "bundle exec ruby #{RSPEC_ROOT}/examples/nested_loop_example.rb"
      )
      test.start
      test.assert_screen
    ensure
      test.stop
    end
  end

  context 'when jard stops at the beginning of file or at the end of file' do
    it 'displays correct line' do
      test = JardIntegrationTest.new(
        self, work_dir,
        'record.end_of_file',
        "bundle exec ruby #{RSPEC_ROOT}/examples/start_of_file_example.rb"
      )
      test.start
      test.assert_screen
    ensure
      test.stop
    end
  end

  context 'when jard steps into a code evaluation' do
    it 'displays correct line' do
      test = JardIntegrationTest.new(
        self, work_dir,
        'record.code_evaluation',
        "bundle exec ruby #{RSPEC_ROOT}/examples/evaluation_example.rb"
      )
      test.start
      test.assert_screen
      test.send_keys('jard filter everything', :Enter)
      test.send_keys('step', :Enter)
      test.assert_screen
      test.send_keys('step-out', :Enter)
      test.send_keys('step', :Enter)
      test.assert_screen
    ensure
      test.stop
    end
  end

  context 'when stop at the end of a method' do
    it 'displays correct line' do
      test = JardIntegrationTest.new(
        self, work_dir,
        'record.end_of_method',
        "bundle exec ruby #{RSPEC_ROOT}/examples/end_of_method_example.rb"
      )
      test.start
      test.assert_screen
      test.send_keys('continue', :Enter)
      test.assert_screen
    ensure
      test.stop
    end
  end

  context 'when use jard with ruby -e' do
    it 'displays correct line' do
      test = JardIntegrationTest.new(
        self, work_dir,
        'record.ruby_e',
        "bundle exec ruby -e \"require 'ruby_jard'\njard\na = 100 + 300\""
      )
      test.start
      test.assert_screen
    ensure
      test.stop
    end
  end

  context 'when jumping into an ERB file' do
    it 'displays correct line' do
      test = JardIntegrationTest.new(
        self, work_dir,
        'record.erb_file',
        "bundle exec ruby #{RSPEC_ROOT}/examples/erb_evaluation.rb"
      )
      test.start
      test.assert_screen
    ensure
      test.stop
    end
  end
end
