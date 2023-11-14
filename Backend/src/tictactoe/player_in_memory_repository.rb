module TicTacToe
  class PlayerInMemoryRepository < ROM::Repository[:games]
    include AppContainer::Deps['persistance.container']

    def all
      players.to_a
    end

    def create(name)
      players.command(:create).call({
        id: SecureRandom.uuid,
        name: name
      })
    end
  end
end
