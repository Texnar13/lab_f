Rails.application.routes.draw do
  root 'users#index'

# / => users#show
  # сессия
  get '/entry' => 'sessions#entry'
  post '/entry' => 'sessions#login'
  get '/logout' => 'sessions#logout'

  # поользователь
  get '/users' => 'users#index'
  get '/users/new' => 'users#new'
  get '/users/:id' => 'users#show', constraints: { id: /\d{1,}/ }
  get '/users/:id/edit' => 'users#edit', constraints: { id: /\d{1,}/ }

  post '/users/new' => 'users#create'
  post '/users/:id/save' => 'users#update', constraints: { id: /\d{1,}/ }
  delete '/users/:id/remove' => 'users#destroy', constraints: { id: /\d{1,}/ }#, defaults: { format: 'jpg' }

  # заметки
  post  '/users/:id/notes/new' => 'notes#create', constraints: { id: /\d{1,}/ }
  post  '/users/:id/notes/:note_id/change' => 'notes#update', constraints: { id: /\d{1,}/, note_id: /\d{1,}/ }
  delete  '/users/:id/notes/:note_id/delete' => 'notes#delete', constraints: { id: /\d{1,}/, note_id: /\d{1,}/ }


  # запросы "нетуда"
  get '/err404' => 'sessions#not_found'
  get '/*other', to: redirect('/err404')

end
