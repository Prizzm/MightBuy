class Api::V1::TopicsApiController < ApplicationController
  before_filter :find_topic, :only => [:show, :edit, :update, :destroy]

  # GET /topics
  # GET /topics.xml
  def index
    @topics = current_user.topics
  end
  
  def search
    @topics = current_user.topics.where("lower(subject) = ?", params[:q].downcase)
  end
  # GET /topics/1
  # GET /topics/1.xml
  def show
    
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = current_user.topics.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new()
    @topic.subject = params[:subject]
    @topic.price = params[:price]
    @topic.shortcode = Shortcode.new(40)
    @topic.user = current_user
    @topic.save
    
    render :text => @topic.to_json
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    respond_to do |wants|
      if @topic.update_attributes(params[:topic])
        flash[:notice] = 'Topic was successfully updated.'
        wants.html { redirect_to(@topic) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic.destroy

    respond_to do |wants|
      wants.html { redirect_to(topics_url) }
      wants.xml  { head :ok }
    end
  end

  private
    def find_topic
      @topic = Topic.find(params[:id])
    end

end
