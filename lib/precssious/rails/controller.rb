class PrecssiousController < ActionController::Base
  
  def show
    css = Precssious.process_files(Dir["#{Precssious.directory}/#{params[:id]}/*.css"].sort, true)
    response.content_type = 'text/css'
    render :text => css
  end
      
end
