class ApplicationController < Sinatra::Base

  # set :views, Proc.new { File.join(root, "../views/") }

  helpers do
    def object_link(object)
      if object.respond_to? "slug"
        id = object.slug
      else
        id = object.id
      end
      "/#{object.class.to_s.downcase.pluralize}/#{id}"
    end
  end


  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :method_override
  #  set :public_folder, File.dirname(__FILE__) + '/static'
  end

  get '/' do
    erb :"/application/root"
  end

end
