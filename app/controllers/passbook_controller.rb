class PassbookController < PassbookManager
  before_filter :verify_anti_forge_token
   
  def pass
    send_file @token.pass_path, type: 'application/vnd.apple.pkpass', disposition: 'attachment', filename: "pass.pkpass"
  end
  
  def generate
    pkpass_path = generatePass(@token)
<<<<<<< HEAD
    @token.update_attribute("pass_path", pkpass_path)
=======
>>>>>>> beee975eb7874222a38ae3a348f534bb208d4297
    
    @token.update_attribute("pass_path", pkpass_path)
    
    respond_to do |format|
      format.pkpass { send_file pkpass_path, type: 'application/vnd.apple.pkpass', disposition: 'attachment', filename: "pass.pkpass" }
      format.json { render :text => {:error => nil, :pass => {:url => {:path => @token.path, :url => @token.url()}}}.to_json }
      format.xml { render :text => {:error => nil, :pass => {:url => {:path => @token.path, :url => @token.url()}}}.to_xml }
      format.html { render :text => "This is a internal API for use by MightBuy and it's affiliates and partners.  This API Request has been marked as unauthorized.  This event has been logged."}
    end
  end
  
  private
    def verify_anti_forge_token
      @token = AntiForgeToken.find_by_value(params[:aftoken])
      token = @token
      if token then
        if !token.active then
          head :unauthorized
        else
          if !params[:debug] == "C1953BA851F2C3DC4AEAB07D89B63158B36D01E195EFB88E2568CC91C2AE37E8" then
            token.update_attribute("active", false)
          end
        end
      else
        head :unauthorized
      end
    end

end
