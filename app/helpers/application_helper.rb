module ApplicationHelper
  
  # Controller Helpers
  
  def action_name
    params[:action].to_sym
  end

  def controller_name
    params[:controller].parameterize.to_sym
  end

  def classes
    "#{controller_name}-section #{action_name}-page"
  end
  
  # Image Helper
  def image (uploader, options = {}, &block)
    if uploader.blank?
      options.reverse_merge! :class => "no-image"
      content_tag(:div, nil, options)
    else
      options.reverse_merge! :class => "with-image"
      content_tag :table, options do
        content_tag :tr do
          content_tag :td do
              yield(uploader)
          end
        end
      end
    end
  end
  
  # Others

  def image? (uploader)
    !uploader.blank?
  end
  
  def detail_image (uploader, style)
    if image?(uploader)
      content_tag :div, :class => "detail-image" do
        centered { image_link(uploader, style) }
      end
    end
  end

  def link (model)
    case model
      when Product then link_to model.name, product_path(model)
      when User then link_to model.email, "#"
      when Invites::Invite then link_to invited_url(model.code), invited_path(model.code)
      else "-"
    end
  end

  def app_page (&block)
    render :layout => "layouts/app", &block
  end
  
  def header_for (action)
    name = resource_class.to_s
    case action
      when :index then "Listing %s" % name.pluralize
      when :new then "Adding a %s" % name
      when :edit then "Updating a %s" % name
      when :show then "Viewing a %s" % name
    end
  end
  
  def attr (label, value = nil, &block)
    unless value.blank?
      content_tag(:div, :class => "attr") do
        value = capture(&block) if block_given?
        content_tag(:label, label) << value
      end
    end
  end
  
  def selected_link (label, path, *controllers)
    selected = controllers.include?(params[:controller])
    link_to label, path, :class => selected ? "selected" : ""
  end
  
  def centered (&block)
    ('<table class="centered"><tr><td>%s</td></tr></table>' % yield).html_safe
  end
  
  def formatted (value)
    case value
      when Time then value.strftime("%m/%d/%Y at %I:%M%p").downcase
      else "-"
    end
  end
  
  def shorthand (value, options = {})
    case value
      when Time then ("%s ago." % time_ago_in_words(value)).capitalize
      when String then truncate(value, options)
      when TrueClass then "Yes"
      when FalseClass then "No"
      else "-"
    end
  end
  
  def image_link (uploader, style)
    link_to image_tag(uploader.send(style)), uploader.url, :class => "image-link", :target => "_blank"
  end
  
  def list_for (*headers, &block)

    options      = headers.extract_options!
    objects      = options[:collection] || collection
    with_actions = !(options[:actions?] == false)
    table_html   = options[:table_html] || { :class => "collection" }
    actions      = proc do |object|
      [
        link_to( "View", resource_path(object) ),
        link_to( "Edit", edit_resource_path(object) ),
        link_to("Delete", resource_path(object), :confirm => "Are you sure?", :method => :delete )
      ].compact.join(" ").html_safe
    end
    
    # If we should include actions, then push the name to the header.
    headers.push("Actions") if with_actions
    
    # If not empty, create the table.
    content_tag :table, table_html do
    
      content_tag(:thead) do
        headers.map do |label|
          content_tag :th, label
        end.join.html_safe
      end <<
  
      content_tag(:tbody) do
        objects.map do |object|
          content_tag(:tr) do
            capture(object, &block).tap do |string|
              string << content_tag(:td, actions.call(object), :class => "actions") if with_actions
            end
          end
        end.join.html_safe
      end
    
    end
    
  end
  
  def go_back (path)
    link_to "Go Back", path, :class => "button dark"
  end
  
  # Meta
  
  def like (url)
    code = <<-EOF
      <div id="fb-root"></div>
      <script>(function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) {return;}
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
        fjs.parentNode.insertBefore(js, fjs);
      }(document, 'script', 'facebook-jssdk'));</script>

      <div class="fb-like" data-href="#{url}" data-send="true" data-width="450" data-show-faces="false"></div>
    EOF
    
    code.html_safe
  end
  
  def meta (options = {})
    image = options[:image]
    url   = options[:url] || root_url
    site  = options[:site] || "Prizzm"
    title = options[:title] || resource_class.to_s.split("::").last.pluralize
    desc = options[:desc]

    display_meta_tags \
      :site => site,
      :title => title,
      :description => desc,
      :open_graph => {
        :type => "website",
        :url  => url,
        :title => title,
        :site_name => site,
        :description => desc,
        :image => image
      }
  end
  
  # Gaug.es helper :)
  def gaug
    script = <<-EOF
      <script type="text/javascript">
        var _gauges = _gauges || [];
        (function() {
          var t   = document.createElement('script');
          t.type  = 'text/javascript';
          t.async = true;
          t.id    = 'gauges-tracker';
          t.setAttribute('data-site-id', '4e8d448af5a1f52966000005');
          t.src = '//secure.gaug.es/track.js';
          var s = document.getElementsByTagName('script')[0];
          s.parentNode.insertBefore(t, s);
        })();
      </script>
    EOF

    Struct.new(:es)
      .new(script.html_safe)
  end
  
end
