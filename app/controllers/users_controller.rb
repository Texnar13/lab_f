require 'digest/sha1'
require 'sessions_controller.rb'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    # ищем в сессии текущего пользователя
    @users.each do |user|
      @current_user = user if(user.id == session[:current_user_id])
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show

    # ищем аутентифицированного в сессии пользователя
    @current_user = User.where(:id => session[:current_user_id])[0]

    # отображаемый пользователь
    @view_user = User.find(params[:id])

    if(@view_user && @current_user)then
      # ищем заметки отображаемого пользователя
      # если пользователь просматривает свою страницу, то заметки можно показать все
      if(@view_user.id == @current_user.id) then
        @notes = @view_user.notes.all
      else
        @notes = @view_user.notes.where(:is_public => true)
      end
    else
      @notes = @view_user.notes.where(:is_public => true)
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new({
      mail: params[:mail],
      name: params[:name],
      password_digest: (SessionsController.hash_password params[:password])
    })

    respond_to do |format|
      if @user.save
        format.html { redirect_to "/users/#{@user.id}", notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update({
          mail: @user.mail,
          name: params[:name],
          password_digest: (SessionsController.hash_password params[:password])
        })
        format.html { redirect_to "/users/#{@user.id}", notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # проверяем, залогинен ли пользователь
    def require_login

    end

end
