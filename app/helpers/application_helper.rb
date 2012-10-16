module ApplicationHelper

  include SharedHelper
  include JavascriptHelper

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

  def action? (*actions)
    actions.include?(action_name)
  end

  def heading (label, options = {})
    content_tag :h3, options do
      content_tag :span, label
    end
  end

  def describe (text)
    content_tag :div, stars(text), :class => "description"
  end

  def stars (text)
    text.gsub(/\*([^\*]+)\*/i, content_tag('strong', '\1')).html_safe
  end

  def avatar_image(user = current_user)
    (user && user.image) ? user.image.url : "/assets/default_avatar.png"
  end

  def popular_tags
    Tag.popular_tags
  end

  def popular_tag_array
    popular_tags.map(&:name)
  end

  def tag_links(topic)
    topic.tags.map do |tag|
      content_tag(:a,tag.name,href: topics_tag_path(tag))
    end.join(",").html_safe
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

  def detail_image (uploader, style, options = {})
    if image?(uploader)
      content_tag :div, :class => "detail-image" do
        centered { image_link(uploader, style) }
      end
    end
  end

  def topic_image(topic)
    topic.image ? topic.image.thumb("254x216").url : "no_image.png"
  end

  def link (model)
    case model
      when Product then link_to model.name, product_path(model)
      when User then link_to model.email, "#"
      else "-"
    end
  end

  def app_page (locals = {}, &block)
    content = capture(&block)
    render( :layout => "layouts/app", :locals => locals ) { content }
  end

  def header
    name = resource_class.to_s
    case action_name
      when :index then "Listing %s" % name.pluralize
      when :new then "Adding a %s" % name
      when :edit then "Updating a %s" % name
      when :show then "Viewing a %s" % name
    end
  end

  def quick_links
    case action_name
      when :show
        link_for(:edit) + link_for(:delete) + link_for(:back)
      when :new, :edit
        link_for(:back)
      when :index
        link_for(:add)
    end
  end

  def link_for (action, label = nil)
    case action
      when :add
        link_to label || "Add Another", new_resource_path, :class => "button"
      when :edit
        link_to label || "Edit", edit_resource_path, :class => "button"
      when :back
          link_to label || "Go Back", "/me", :class => "dark button"
      when :delete
        link_to label || "Delete", resource_path, :confirm => "Are you sure?", :method => :delete, :class => "button"
    end
  end

  def attr (label, value = nil, &block)
    content_tag(:div, :class => "attr") do
      value = capture(&block) if block_given?
      content_tag(:label, label) << value.to_s
    end
  end

  def active_link (label, path, *args)
    active = args.include?(params[:controller]) || args.any? { |value| value == true }
    link_to label, path, :class => active ? "active" : ""
  end

  def centered (&block)
    ('<table class="centered" cellspacing="0" cellpadding="0"><tr><td>%s</td></tr></table>' % capture(&block)).html_safe
  end

  def formatted (value)
    case value
      when Time then value.strftime("%m/%d/%Y at %I:%M%p").downcase
      else "-"
    end
  end

  def shorthand (value, options = {})
    case value
      when Time then ("%s ago" % time_ago_in_words(value)).capitalize
      when String then truncate(value, options)
      when TrueClass then "Yes"
      when FalseClass then "No"
      else "-"
    end
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

  def bookmarklet_url
    "javascript:(function() { (function(){ " +
    "window.open(\"#{request.base_url}\" +
     \"/topics/new?topic[subject]=\"+encodeURIComponent(document.title) +
     \"&topic[url]=\"+encodeURIComponent(window.location.href)); })() })();"
  end

  def twitter_url(topic)
    query_params = {
      url:  topic_url(topic),
      text: topic.ihave? ? "I Have Bought" : "I MightBuy",
      via: 'mightbuy'
    }.to_query

    "https://twitter.com/intent/tweet?#{query_params}"
  end
end
