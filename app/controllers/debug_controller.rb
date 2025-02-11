class DebugController < ApplicationController
    skip_before_action :authenticate_user!, only: [:migrate]
    def migrate
      Rails.application.load_tasks
      Rake::Task['db:migrate'].invoke
      render plain: "Migration completed"
    end
  end