# Override mail sending in development.
if Rails.env.development?

  class DevelopmentMailInterceptor  
    def self.delivering_email(message)  
      message.subject = "[#{message.to}] #{message.subject}"  
      message.to = "mitchkthompson@gmail.com"  
    end  
  end
  
  Mail.register_interceptor(DevelopmentMailInterceptor)

end