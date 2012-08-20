module Statistics
  
  class << self
    
    def for (model)
      case model
        when User then user(model)
        when Topic then topic(model)
      end
    end
    
    private
    
      def statistics (&block)
        {}.tap(&block)
      end
      
      def percent (of, total)
        value = ((of.to_f / total.to_f) * 100).to_i rescue 0
        ("%s<sup>%%</sup>" % value).html_safe
      end
    
      def user (model)
        statistics do |stats|
          sent       = model.shares.where(:type => Shares::Email)
          responded  = model.topic_responses.
                          select('DISTINCT visitor_code').
                          where("recommend_type IS NOT NULL")
          promoted   = responded.recommended
          recommends = model.topic_shares.where(:type => Shares::Recommend)
          tweets     = model.topic_shares.where(:type => Shares::Tweet)
          
          stats[:invites_sent] = sent.count
          stats[:responded] = percent(responded.count, sent.count)
          stats[:promoted] = percent(promoted.count, responded.count)
          stats[:recommended] = recommends.count
          stats[:tweeted] = tweets.count
        end
      end
      
      def topic (model)
        statistics do |stats|
          sent               = model.shares.where(:type => Shares::Email)
          responses          = model.responses.where('recommend_type IS NOT NULL')
          recommended        = model.responses.recommended
          undecided          = model.responses.undecided
          not_recommended    = model.responses.not_recommended
          social_shares      = model.shares.social
          unreplied          = model.responses.unreplied
          
          stats[:invites_sent]    = sent.count
          stats[:unreplied]       = unreplied.count
          stats[:recommended]     = percent(recommended.count, responses.count)
          stats[:undecided]       = percent(undecided.count, responses.count)
          stats[:not_recommended] = percent(not_recommended.count, responses.count)
          stats[:social_shares]   = social_shares.count
        end
      end
    
  end
  
end