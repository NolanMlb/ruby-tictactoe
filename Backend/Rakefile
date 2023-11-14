require 'rom/sql/rake_task'
require 'pry'

require_relative 'config/app'

namespace :db do
  task :setup do
    ROM::SQL::RakeSupport.env = AppContainer['persistance.container']
  end
end
