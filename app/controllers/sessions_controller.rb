class SessionsController < ApplicationController

  def entry

  end

  def login
    user = User.where(:mail => params[:mail])[0]
    # аутентификация
    if user && user[:password_digest] == SessionsController.hash_password(params[:password])
      # Устанавливаем значение сессии
      session[:current_user_id] = user.id
      redirect_to "/users/#{user.id}"
    else
      redirect_to '/entry'
    end

  end

  def logout

    # Обнуляем ключ сессии
    session[:current_user_id] = nil
    # Обнуляем сессию полностью
    reset_session
    # на страничку входа
    redirect_to '/entry'
  end


  # хеширование паролей
  def self.hash_password text
    Digest::SHA1.hexdigest(text.to_s)
  end

end
