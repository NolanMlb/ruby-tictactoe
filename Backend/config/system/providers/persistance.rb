require 'dry/system'

AppContainer.register_provider(:persistance) do
  prepare do
    require 'rom'
    require 'rom-sql'
  end

  start do
    configuration = ROM::Configuration.new({
      :sql => [:sql, ENV['DATABASE_URL']],
      default: [:sql, ENV['DATABASE_URL']]
    })
    configuration.auto_registration(
      File.join(File.expand_path("."), "src", "persistance"),
      namespace: 'Persistance'
    )

    rom_container = ROM.container(configuration)

    register('persistance.container', rom_container)
  end
end
