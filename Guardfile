# Copyright (C) 2015 Twitter, Inc.

guard :bundler do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |match| "spec/#{match[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }
end
