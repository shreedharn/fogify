class FriendsController < FbBaseController
  before_filter :authenticate_user!
  include FogifyHelper::GraphHelper  #graph helper defined here

  # GET /friends
  # GET /friends.json
  def index
    @fb_id, access_token =  get_fb_info()
    @graph = get_graph(access_token)

    if @graph.nil?
      redirect_to '/auth/facebook'
    else
      friends = Hash.new
      begin
        explorer = Explorer.find_by_explorer_id(@fb_id)
        friend_id = (explorer.nil?) ? nil : explorer.friend_id

        top_friends = get_top_friends_likes(@graph,friend_id)
        unless top_friends.nil?
          top_friends.each do |friend_hash|
            if friends[friend_hash['user_id']].nil?
              friends[friend_hash['user_id']] = 1
            else
              friends[friend_hash['user_id']] = friends[friend_hash['user_id']] + 1
            end
          end
          @hashAsArrays = friends.to_a  # converts into two dimensional array
          @hashAsArrays = @hashAsArrays.sort_by{|k,v| v} #sort by value
          @hashAsArrays = @hashAsArrays.reverse
          @names = get_basic_users_info(@graph, friends.keys)
          friends = nil
        end
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @max_likes }
        end
      rescue => e
        @error_flag = true
      end
    end

  end

  # GET /friends/1
  # GET /friends/1.json
  def show
    @friend = Friend.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @friend }
    end
  end

  # GET /friends/new
  # GET /friends/new.json
  def new
    @friend = Friend.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @friend }
    end
  end

  # GET /friends/1/edit
  def edit
    @friend = Friend.find(params[:id])
  end

  # POST /friends
  # POST /friends.json
  def create
    @friend = Friend.new(params[:friend])

    respond_to do |format|
      if @friend.save
        format.html { redirect_to @friend, notice: 'Friend was successfully created.' }
        format.json { render json: @friend, status: :created, location: @friend }
      else
        format.html { render action: "new" }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /friends/1
  # PUT /friends/1.json
  def update
    @friend = Friend.find(params[:id])

    respond_to do |format|
      if @friend.update_attributes(params[:friend])
        format.html { redirect_to @friend, notice: 'Friend was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friends/1
  # DELETE /friends/1.json
  def destroy
    @friend = Friend.find(params[:id])
    @friend.destroy

    respond_to do |format|
      format.html { redirect_to friends_url }
      format.json { head :no_content }
    end
  end
end
