class ApplicationController < ActionController::Base
  #protect_from_forgery with: :null_session
  #protect_from_forgery with: :exception, prepend: true
  # Воссоздать базу данных: rake db:drop db:create db:migrate
  # ActiveRecord::Base.connection.columns('notes').map(&:name) - вывод столбцов бд
  skip_before_action :verify_authenticity_token

end
