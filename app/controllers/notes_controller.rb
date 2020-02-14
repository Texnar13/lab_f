class NotesController < ApplicationController
  before_action :getShowUserByParamsIdAndGetCurrentUserFromSession


  #POST создание заметки
  def create

    if(params[:id]) then
      note = Note.new({
        user_id: params[:id],
        title: params[:title],
        body: params[:body_text],
        is_public: params[:is_public],
        when_created: Time.now.strftime("%d/%m/%Y %H:%M:%S")
      })
      if note.save

        respond_to do |format|
          format.html
          format.json do
            render json: {
              note_id: note.id,
              title: note.title,
              body_text: note.body,
              is_public: note.is_public,
              when_created: note.when_created
            }
          end
        end

      end
    end

  end


  #POST применение изменений к заметке
  def update

    note = Note.find(params[:note_id])
    if(note)then
      if note.update({
          title: params[:title],
          body: params[:body_text],
          is_public: params[:is_public],
          when_created: note[:when_created]
        }) then

        respond_to do |format|
          format.html
          format.json do
            render json: {
              note_id: note.id,
              title: note.title,
              body_text: note.body,
              is_public: note.is_public,
              when_created: note.when_created
            }
          end
        end

      end
    end


  end


  #DELETE удаление заметки
  def delete

    isDestroyed = false
    answerStatus = 403
    # удаляем заметку
    note = Note.find(params[:note_id])
    if(note)then
      isDestroyed = note.destroy
      answerStatus = 200
    end

    respond_to do |format|
      format.html
      format.json { render json: { isDestroyed: isDestroyed }, status: answerStatus }
    end
  end


  private
    def getShowUserByParamsIdAndGetCurrentUserFromSession
      # отображаемый пользователь (возвращает nil если пользователь не найден)
      @viewUser = User.find_by(id: params[:id])
      # если отображаемый переданный пользователь не существует
      if(!@viewUser)then
        redirect_to "/err404", notice: 'Пользователь с таким адресом не найден!'
        return
      end

      # ищем аутентифицированного в сессии пользователя
      if(session[:current_user_id])then
        @currentUser = User.find_by(id: session[:current_user_id])
      else
        @currentUser = nil
      end
      # в случаен если пользователя нет в сесии или в сессии некорректный идентификатор
      if(@currentUser == nil)then
        # на всякий случай чистим сессию
        redirect_to '/logout'
      end
      # пользователь может менять только свою страницу
      if(!@currentUser || @viewUser.id != @currentUser.id)then
        redirect_to "/users/#{@viewUser.id}", notice: 'У вас нет прав на изменение этого пользователя!'
        return
      end

    end
end
