require 'dry/system'
require 'dry/inflector'
require 'pg'

class AppContainer < Dry::System::Container
  use :zeitwerk

  configure do |config|
    config.root = __dir__

    config.component_dirs.add "../src"

    config.inflector = Dry::Inflector.new do |inflections|
      inflections.acronym('TicTacToe')
      inflections.acronym('UI')
      inflections.acronym('UUID')
    end
  end
end

class AppContainer
  Deps = AppContainer.injector
end

AppContainer.finalize!
