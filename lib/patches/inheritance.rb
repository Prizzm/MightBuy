class ActiveRecord::Reflection::AssociationReflection
  def build_association(*opts, &block)
    col = klass.inheritance_column.to_sym
    if (h = opts.first).is_a? Hash and (type = h.symbolize_keys[col])
      opts.first[col].to_s.constantize.new(*opts, &block)
    elsif klass.abstract_class?
      raise "#{klass.to_s} is an abstract class and can not be directly instantiated"
    else
      klass.new(*opts, &block)
    end
  end
end