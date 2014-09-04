# coding: utf-8
class TopicsController < ApplicationController
  def index
  end

  def show
    name = params[:id].strip
    @per_page = 10
    @topic = Topic.find_by_name(name)
    if @topic.blank?
      return render_404
    end
    @asks = Ask.all_in(:topics => [/#{name}/i]).normal.recent.paginate(:page => params[:page], :per_page => @per_page)
    set_seo_meta(@topic.name,:description => @topic.summary)

    if !params[:page].blank?
      render "/asks/index.js"
    end
  end
  
  def follow
    @topic = Topic.find_by_name(params[:id])
    if not @topic
      render :text => "0"
      return
    end
    current_user.follow_topic(@topic)
    render :text => "1"
  end
  
  def unfollow
    @topic = Topic.find_by_name(params[:id])
    if not @topic
      render :text => "0"
      return
    end
    current_user.unfollow_topic(@topic)
    render :text => "1"
  end

  def edit
    @topic = Topic.find(params[:id])
    render :layout => false
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.current_user_id = current_user.id
    @topic.cover = params[:topic][:cover]
    if @topic.save
      flash[:notice] = "Topics cover uploaded successfully."
    else
      flash[:alert] = "Topics cover upload failed，please check the picture you upload meets the format requirements."
    end
    redirect_to topic_path(@topic.name)
  end
end
