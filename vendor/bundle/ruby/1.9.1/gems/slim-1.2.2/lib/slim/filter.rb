module Slim
  # Base class for Temple filters used in Slim
  #
  # This base filter passes everything through and allows
  # to override only some methods without affecting the rest
  # of the expression.
  #
  # @api private
  class Filter < Temple::HTML::Filter
    # Pass-through handler
    def on_slim_embedded(type, content)
      [:slim, :embedded, code, compile(content)]
    end

    # Pass-through handler
    def on_slim_control(code, content)
      [:slim, :control, code, compile(content)]
    end

    # Pass-through handler
    def on_slim_condcomment(condition, content)
      [:slim, :condcomment, condition, compile(content)]
    end

    # Pass-through handler
    def on_slim_output(code, escape, content)
      [:slim, :output, code, escape, compile(content)]
    end

    # Pass-through handler
    def on_slim_attrs(*attrs)
      [:slim, :attrs, *attrs.map {|a| compile(a) }]
    end

    # Pass-through handler
    def on_slim_tag(name, attrs, content = nil)
      tag = [:slim, :tag, name, compile(attrs)]
      content ? (tag << compile(content)) : tag
    end
  end
end
