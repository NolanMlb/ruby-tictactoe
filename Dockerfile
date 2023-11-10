# Utilisez une image officielle de Ruby
FROM ruby:3.1

# Installez les dépendances nécessaires (si vous en avez)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs 

# Créez et définissez le répertoire de travail
WORKDIR /usr/src/app

# Copiez le Gemfile et le Gemfile.lock pour installer les dépendances
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copiez le reste de l'application
COPY . .

# Commande pour exécuter le programme
CMD ["./bin/start"]
