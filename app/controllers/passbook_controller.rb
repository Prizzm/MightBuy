class PassbookController < PassbookManager
  before_filter :verify_anti_forge_token
   
  def pass
    send_file @token.pass_path, type: 'application/vnd.apple.pkpass', disposition: 'attachment', filename: "pass.pkpass"
  end
  
  def generate
    pkpass_path = generatePass(@token)
    @token.update_attribute("pass_path", pkpass_path)
    
    if params[:d] == "t" then
      send_file pkpass_path, type: 'application/vnd.apple.pkpass', disposition: 'attachment', filename: "pass.pkpass"
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
          # token.update_attribute("active", false)
        end
      else
        head :unauthorized
      end
    end

end
