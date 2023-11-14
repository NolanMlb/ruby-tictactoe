require 'dry/system'

AppContainer.register_provider(:greet) do
  start do
    puts "The app starts"
  end
end
