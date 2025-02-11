class DebugController < ApplicationController
    def migrate
      Rails.application.load_tasks
      Rake::Task['db:migrate'].invoke
      render plain: "Migration completed"
    end
  end