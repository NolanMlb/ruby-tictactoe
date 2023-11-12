# Use the official Ruby image
FROM ruby:3.1

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs

# Set the working directory
WORKDIR /usr/src/app

# Copy Gemfile and Gemfile.lock to install dependencies
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy the rest of the application
COPY . .

# Command to run the program
CMD ["./bin/start"]
