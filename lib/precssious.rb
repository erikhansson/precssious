
require File.dirname(__FILE__) + "/precssious/rule"
require File.dirname(__FILE__) + "/precssious/value"
require File.dirname(__FILE__) + "/precssious/token"
require File.dirname(__FILE__) + "/precssious/preprocessor"


module Precssious
  
  def self.directory=(value); @directory = value; end
  def self.directory; @directory; end
  def self.web_path=(value); @web_path = value; end
  def self.web_path; @web_path; end


  ##
  # Loads the Precssious controller and adds routes to it. This route matches
  # [directory]/:id/:filename.css, which by default is stylesheets/:id/:filename.css.
  #
  def self.start_rails_controller
    yield self if block_given?

    @directory ||= Rails.root.join('public', 'stylesheets')
    @web_path ||= 'stylesheets'

    require "precssious/rails/controller"
    ActionController::Routing::Routes.add_configuration_file(File.join(File.dirname(__FILE__), 'precssious', 'rails', 'routes.rb'))
  end

  ##
  # Generates CSS with names matching the directory names from all the CSS files 
  # included in that directory. By default searches public/stylesheets for directories
  # to process (set Precssious.directory to change this).
  #
  def self.perform_preprocessing
    yield self if block_given?
    
    Dir["#{@directory}/*"].each do |dir|
      if File.directory?(dir)
        css = process_files(Dir["#{dir}/*.css"].sort, true)
        File.open "#{dir}/#{File.basename(dir)}.css", 'w' do |file|
          file.write css
        end
      end
    end
  end
  

  def self.process(input)
    Preprocessor.new(input).rules.map { |x| x.to_s }.join "\n"
  end

  def self.process_files(files, zero = false)
    result = zero ? [zero_css] : []
    files.each do |filename|
      File.open filename, 'r' do |file|
        result << '' << "/* #{File.basename(filename)} */"
        result << process(file.read)
      end
    end
    result.join "\n"
  end
  
  def self.zero_css
    "html{color:#000;background:#FFF;}body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td{margin:0;padding:0;}table{border-collapse:collapse;border-spacing:0;}fieldset,img{border:0;}address,caption,cite,code,dfn,em,strong,th,var{font-style:normal;font-weight:normal;}li{list-style:none;}caption,th{text-align:left;}h1,h2,h3,h4,h5,h6{font-size:100%;font-weight:normal;}q:before,q:after{content:'';}abbr,acronym {border:0;font-variant:normal;}sup {vertical-align:text-top;}sub {vertical-align:text-bottom;}input,textarea,select{font-family:inherit;font-size:inherit;font-weight:inherit;}input,textarea,select{*font-size:100%;}legend{color:#000;}"  
  end
  
  
end
