class SessionsController < ApplicationController

  def entry # GET (страничка входа)
    # если пользователь уже залогинен перенаправляем его на его же страничку
    if(session[:current_user_id])then
      redirect_to "/users/#{session[:current_user_id]}", notice: 'Вы уже вошли в учетную запись!'
    end
  end


  def login # POST (запрос на аутентификацию, инициализация сессии)
    # если пользователь уже авторизован
    if(session[:current_user_id] != nil)then
      redirect_to "/users/#{session[:current_user_id]}", notice: 'Вы уже вошли в учетную запись!'
      return
    end
    # ищем пользователя в бд
    user = User.where(:mail => params[:mail])[0]
    # аутентификация
    if user && user[:password_digest] == SessionsController.hash_password(params[:password])
      # Устанавливаем значение сессии
      session[:current_user_id] = user.id
      redirect_to "/users/#{user.id}"
    else
      redirect_to '/entry', notice: 'Введены некорректные данные!'
    end
  end


  def logout # GET (запрос на выход из сессии)
    # Обнуляем ключ сессии
    session[:current_user_id] = nil
    # Обнуляем сессию полностью
    reset_session
    # перенаправляем на страничку входа
    redirect_to '/entry', notice: 'Вы успешно вышли!'
  end


  def not_found # GET страничка 404
  end


  private
    # хеширование паролей
    def self.hash_password(text)
      text = text.to_s + "**helloRAILS!!" + text.to_s
      10.times do |i|
        text = Digest::SHA1.hexdigest(text);
      end
      return text
    end

end
