require 'digest/sha1'
require 'sessions_controller.rb'

class UsersController < ApplicationController
  before_action :getShowUserByParamsId, only: [:show, :edit, :update, :destroy]
  before_action :getCurrentUserFromSession


  def index # GET (страница со всеми пользователями)
    @viewAllUsers = User.all
  end


  def new # GET (страница создания пользователя)
    # если пользователь уже зашел под какой-то записью
    if(@currentUser)then
      redirect_to "/users/#{@currentUser.id}", notice: 'Вы уже зашли в учетную запись и не можете создать новую пока не выйдете'
      return
    end
  end


  def create # POST (создание пользователя)

    # если пользователь уже зашел под какой-то записью
    if(@currentUser)then
      redirect_to "/users/#{@currentUser.id}", notice: 'Вы уже зашли в учетную запись и не можете создать новую'
      return
    end

    @currentUser = User.new({
      mail: params[:mail],
      name: params[:name],
      password_digest: (SessionsController.hash_password params[:password])
    })

    respond_to do |format|
      if @currentUser.save
        format.html { redirect_to "/entry", notice: 'Пользователь успешно создан!' }
        format.json { render :show, status: :created, location: @currentUser }
      else
        format.html { render :new }
        format.json { render json: @currentUser.errors, status: :unprocessable_entity }
      end
    end
  end


  def show # GET (страница пользователя)
    # если отображаемый переданный пользователь не существует
    if(!@viewUser)then
      redirect_to '/err404', notice: 'Пользователь с таким адресом не найден!'
      return
    end
    # если в сессии есть пользователь и он и есть отображаемый
    if(@currentUser && @viewUser.id == @currentUser.id)then
      # если пользователь просматривает свою страницу, то заметки можно показать все
      @notes = @viewUser.notes.all
    else
      # ищем заметки отображаемого пользователя
      @notes = @viewUser.notes.where(:is_public => true)
    end
  end


  def edit # GET (страница редактирования отображаемого пользователя)

    # если отображаемый переданный пользователь не существует
    if(!@viewUser)then
      redirect_to "/err404", notice: 'Пользователь с таким адресом не найден!'
      return
    end

    # проверяем, может ли текущий пользователь редактировать отображаемого
    if(!@currentUser || @currentUser.id != @viewUser.id)then
      redirect_to "/users/#{@viewUser.id}", notice: 'У вас нет прав на редактирование этого пользователя'
    end
  end


  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update # POST (изменение настроек пользователя)

    # если отображаемый переданный пользователь не существует
    if(!@viewUser)then
      redirect_to "/err404", notice: 'Пользователь с таким адресом не найден!'
      return
    end

    # пользователь может менять только свою страницу
    if(!@currentUser || @viewUser.id != @currentUser.id)then
      redirect_to "/users/#{@viewUser.id}", notice: 'У вас нет прав на изменение этого пользователя!'
      return
    end

    # обновляем пользователя новыми полями (если какое-то поле пустое, то оно не меняется)
    respond_to do |format|
      if @viewUser.update({
          mail: @viewUser.mail,
          name: (params[:name] == nil ? @viewUser.name : params[:name]),
          password_digest: (params[:password] == nil ? @viewUser.password_digest : (SessionsController.hash_password params[:password]))
        })
        format.html { redirect_to "/users/#{@viewUser.id}", notice: 'Пользователь изменен' }
        format.json { render :show, status: :ok, location: @viewUser }
      else
        format.html { render :edit, notice: 'Error' }
        format.json { render json: @viewUser.errors, status: :unprocessable_entity }
      end
    end

  end


  def destroy # DELETE (Удаление пользователя)

    # если отображаемый переданный пользователь не существует
    if(!@viewUser)then
      redirect_to "/err404", notice: 'Пользователь с таким адресом не найден!'
      return
    end

    # пользователь может менять только свою страницу
    if(!@currentUser || @viewUser.id != @currentUser.id)then
      redirect_to "/users/#{@viewUser.id}", notice: 'У вас нет прав на удаление этого пользователя!'
      return
    end

    @viewUser.destroy
    respond_to do |format|
      format.html { redirect_to '/', notice: 'Пользователь успешно удален!' }
      format.json { head :no_content }
    end

    # Обнуляем ключ сессии
    session[:current_user_id] = nil
    # Обнуляем сессию полностью
    reset_session
    # перенаправляем на страничку входа
    redirect_to '/entry', notice: 'Пользователь удален!'

  end


  private
    # отображаемый пользователь (возвращает nil если пользователь не найден)
    def getShowUserByParamsId
      @viewUser = User.find_by(id: params[:id])
    end

    # ищем аутентифицированного в сессии пользователя
    def getCurrentUserFromSession
      if(session[:current_user_id])then
        @currentUser = User.find_by(id: session[:current_user_id]);
        # на всякий случай чистим сессию
        if(@currentUser == nil)then
          redirect_to '/logout'
        end
      else
        @currentUser = nil;
      end

    end

end
