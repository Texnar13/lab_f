class NotesController < ApplicationController

  #GET страница создания заметки
  def new

  end


  #GET страница изменения заметки
  def change

  end


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
    note = Note.find(params[:note_id])
    note.destroy
    respond_to do |format|
      format.html
      format.json { head :no_content }
    end
  end

end
