class ExplorersController < ApplicationController
  include FogifyHelper::GraphHelper #graph helper defined here
  before_filter :authenticate_user!

  # GET /explorers
  # GET /explorers.json
  def index
    @explorers = Explorer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @explorers }
    end
  end

  # GET /explorers/1
  # GET /explorers/1.json
  def show
    @explorer = Explorer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @explorer }
    end
  end

  # GET /explorers/new
  # GET /explorers/new.json
  def new
    @explorer = Explorer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @explorer }
    end
  end

  # GET /explorers/1/edit
  def edit
    @explorer = Explorer.find(params[:id])
  end

  # POST /explorers
  # POST /explorers.json
  def create
    explorer_profile = nil
    user_auth = current_user.authentications
    this_auth = user_auth.where("uemail = :uemail AND provider = :provider",
                                {:provider => 'facebook', :uemail => current_user.email}).first

    if (this_auth.nil? || this_auth.access_token.nil?)
      redirect_to '/auth/facebook'
    else
      @graph = Koala::Facebook::API.new(this_auth.access_token)
      explorer_profile = @graph.get_object("me")

      @explorer = Explorer.find_or_create_by_explorer_id(explorer_profile['id'])
      friend_name = params['explorer']['friend_id']
      @explorer.friend_id= nil
      match_friend = {}
      unless friend_name.nil? || friend_name.empty?
        friend_name = friend_name.downcase
        friends_list = get_friends_of_me(@graph, nil)
        friends_list.try(:each) do |friend_info|
           unless (friend_info['name'] = friend_info['name'].downcase).index(friend_name).nil?
            if @explorer.friend_id.nil?
              @explorer.friend_id = friend_info['uid']
              match_friend = friend_info
            elsif (friend_info['name'].index(match_friend['name']) != nil)
              @explorer.friend_id = friend_info['uid']
              match_friend = friend_info
            end
          end
        end
      else
        @explorer.friend_id = nil
      end
      if match_friend.nil?
        friend_name = 'default'
      else
        friend_name = match_friend['name']
      end
      respond_to do |format|
        if @explorer.save
          format.html { redirect_to albums_path, notice: "Mode switched to #{friend_name}" }
          format.json { render json: @explorer, status: :created, location: @explorer }
        else
          format.html { render action: "new" }
          format.json { render json: @explorer.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /explorers/1
  # PUT /explorers/1.json
  def update
    @explorer = Explorer.find(params[:id])

    respond_to do |format|
      if @explorer.update_attributes(params[:explorer])
        format.html { redirect_to @explorer, notice: 'Explorer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @explorer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /explorers/1
  # DELETE /explorers/1.json
  def destroy
    @explorer = Explorer.find(params[:id])
    @explorer.destroy

    respond_to do |format|
      format.html { redirect_to explorers_url }
      format.json { head :no_content }
    end
  end
end
