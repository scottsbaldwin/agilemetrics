class SprintsController < ApplicationController
  # GET /teams/1/sprints/1
  # GET /teams/1/spritns/1.json
  def show
	@team = Team.find(params[:team_id])
	@sprint = @team.sprints.find(params[:id])
	@summary_sprint = @sprint
	@first_sprint = @team.sprints.find(:first)
	@last_sprint = @team.sprints.find(:last)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sprint }
    end
  end

  # GET /teams/1/sprints/new
  # GET /teams/1/sprints/new.json
  def new
	@team = Team.find(params[:team_id])
    @sprint = @team.sprints.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team }
    end
  end

	# GET /teams/1/sprints/1/edit
	def edit
		@team = Team.find(params[:team_id])
		@sprint = @team.sprints.find(params[:id])
	end

	def create
		@team = Team.find(params[:team_id])
		@sprint = @team.sprints.create(params[:sprint])
		redirect_to team_path(@team)
	end

	# PUT /teams/1/sprints/1
	# PUT /teams/1/sprints/1.json
	def update
		@team = Team.find(params[:team_id])
		@sprint = @team.sprints.find(params[:id])

		respond_to do |format|
			if @sprint.update_attributes(params[:sprint])
				format.html { redirect_to [@sprint.team, @sprint], notice: 'Sprint was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @sprint.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@team = Team.find(params[:team_id])
		@sprint = @team.sprints.find(params[:id])
		@sprint.destroy
		redirect_to team_path(@team)
	end
end
