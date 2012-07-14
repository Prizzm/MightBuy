class UploadController < ApplicationController  

  def accept
    upload = Upload.create :image => request.raw_post
    
    respond_to do |wants|
      wants.json { render :json => {
        :success => true,
        :id => upload.id,
        :thumb => absolute_url(upload.image.thumb('90x90').url)
      }}
    end
  end
  
  def acceptMobile
    upload = Upload.create :image => params[:image]

    respond_to do |wants|
      wants.json { render :json => {
        :success => true,
        :id => upload.id,
        :url => absolute_url(upload.image.url)
      }}
    end
  end
  
  private
  
    def absolute_url (*args)
      URI.join(root_url, *args).to_s
    end
  
end