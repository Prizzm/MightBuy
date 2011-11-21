module Model
  
  module Many
    
    extend ActiveSupport::Concern
    
    module ClassMethods
      
      def validates_many (name)
        validate do
          unless send(name).all?(&:valid?)
            errors.add(name)
          end
        end
      end
      
      # validate do
      #   unless emails.all?(&:valid?)
      #     errors.add(:emails)
      #   end
      # end
      
      def many (method, options = {})
        method = method.to_s
        klass  = options[:class_name]
        
        define_method method do
          @attributes[method] ||= []
        end
        
        define_method "#{method}=" do |array_or_hash|
          @attributes[method] = []
          constant = options[:class_name].constantize
          
          case array_or_hash
            when Array
              array_or_hash.each do |attributes|
                @attributes[method].push constant.new(attributes)
              end
            else
              array_or_hash.each do |key, attributes|
                @attributes[method].push constant.new(attributes)
              end
          end
        end
      end
      
    end
    
  end
  
  module Attributes
    
    extend ActiveSupport::Concern
    
    included do
      attr_accessor :attributes
    end
    
    module ClassMethods
      
      def attribute (name)
        name = name.to_s
        
        define_method name do
          @attributes[name]
        end
        
        define_method "#{name}=" do |value|
          @attributes[name] = value
        end
      end
      
    end
    
    module InstanceMethods
      
      def initialize (attrs = {})
        @attributes = {}
        attrs.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end
      
    end
    
  end
  
end