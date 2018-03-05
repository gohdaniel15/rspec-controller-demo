Rails.application.routes.draw do

  devise_for :admins
  resources :users do
    resources :posts
  end

end
