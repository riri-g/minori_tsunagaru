#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Updating package list..."
apt-get update && apt-get install -y libpq-dev

echo "Installing gems..."
bundle install

echo "Precompiling assets..."
bundle exec rails assets:precompile

echo "Running migrations..."
bundle exec rails db:migrate || (echo "Migration failed!" && exit 1)

echo "Seeding database..."
bundle exec rails db:seed

echo "Build completed successfully."