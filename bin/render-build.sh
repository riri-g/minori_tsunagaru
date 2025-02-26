#!/usr/bin/env bash
# exit on error
set -o errexit

apt-get update && apt-get install -y libpq-dev
bundle install
bundle exec rails assets:precompile
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:migrate
bundle exec rails db:seed