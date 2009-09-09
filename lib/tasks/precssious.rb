namespace :precssious do
  
  desc 'Generates the stylesheets as static resources'
  task :generate => :environment do
    require 'precssious'
    
    if defined?(Rails)
      Precssious.directory = Rails.root.join('public', 'stylesheets') 
      Precssious.perform_preprocessing
    end
  end

end