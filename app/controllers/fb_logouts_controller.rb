class FbLogoutsController < FbBaseController
  # GET /fb_logouts
  # GET /fb_logouts.json
  def index
    auth_rec = get_auth_rec
    unless auth_rec.nil?
      auth_rec.access_token = nil
      auth_rec.save
    end
    fb_id, access_token =  get_fb_info()
    explorer = Explorer.find_by_explorer_id(fb_id)
    unless explorer.nil?
      explorer.friend_id=nil
      explorer.save
    end

    redirect_to destroy_user_session_path

  end

  # GET /fb_logouts/1
  # GET /fb_logouts/1.json
  def show
    @fb_logout = FbLogout.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fb_logout }
    end
  end

  # GET /fb_logouts/new
  # GET /fb_logouts/new.json
  def new
    @fb_logout = FbLogout.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fb_logout }
    end
  end

  # GET /fb_logouts/1/edit
  def edit
    @fb_logout = FbLogout.find(params[:id])
  end

  # POST /fb_logouts
  # POST /fb_logouts.json
  def create
    @fb_logout = FbLogout.new(params[:fb_logout])

    respond_to do |format|
      if @fb_logout.save
        format.html { redirect_to @fb_logout, notice: 'Fb logout was successfully created.' }
        format.json { render json: @fb_logout, status: :created, location: @fb_logout }
      else
        format.html { render action: "new" }
        format.json { render json: @fb_logout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fb_logouts/1
  # PUT /fb_logouts/1.json
  def update
    @fb_logout = FbLogout.find(params[:id])

    respond_to do |format|
      if @fb_logout.update_attributes(params[:fb_logout])
        format.html { redirect_to @fb_logout, notice: 'Fb logout was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fb_logout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fb_logouts/1
  # DELETE /fb_logouts/1.json
  def destroy
    @fb_logout = FbLogout.find(params[:id])
    @fb_logout.destroy

    respond_to do |format|
      format.html { redirect_to fb_logouts_url }
      format.json { head :no_content }
    end
  end
end
