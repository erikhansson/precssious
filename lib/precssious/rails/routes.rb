
ActionController::Routing::Routes.draw do |map|
  map.connect "#{Precssious.web_path}/:id/:filename.css", :controller => 'precssious', :action => 'show'
end
