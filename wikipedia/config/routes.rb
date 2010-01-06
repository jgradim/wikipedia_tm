ActionController::Routing::Routes.draw do |map|

	map.resources :events, :collection => { :search => :get } 

	map.root :controller => 'home', :action => 'index'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
