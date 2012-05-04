Financial::Application.routes.draw do
  devise_for :users, :skip => [:passwords, :registrations]
  mount RailsAdmin::Engine => ''
end
