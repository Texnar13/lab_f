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
  get '/users/:id' => 'users#show'
  get '/users/:id/edit' => 'users#edit'
  delete '/users/:id/remove' => 'users#destroy'

  post '/users/new' => 'users#create'
  post '/users/:id/save' => 'users#update'

  # заметки
  get '/users/:id/notes/new' => 'notes#new'
  get  '/users/:id/notes/:note_id/change' => 'notes#change'

  post  '/users/:id/notes/new' => 'notes#create'
  post  '/users/:id/notes/:note_id/change' => 'notes#update'

  delete  '/users/:id/notes/:note_id/delete' => 'notes#delete'

end
