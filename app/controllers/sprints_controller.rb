class SprintsController < ApplicationController
	include SprintsHelper
  # GET /teams/1/sprints/1
  # GET /teams/1/spritns/1.json
  def show
	@team = Team.find(params[:team_id])
	@sprint = @team.sprints.find(params[:id])
	@summary_sprint = @sprint
	@first_sprint = @team.sprints.find(:first)
	@last_sprint = @team.sprints.find(:last)
	@linear_regression = get_linear_regression_actual_velocity(@team.sprints, @last_sprint)
	@averages_set = last_n_sprints_inclusive(@team.sprints, @summary_sprint, 6)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sprint }
    end
  end

  # GET /teams/1/sprints/new
  # GET /teams/1/sprints/new.json
  def new
	@team = Team.find(params[:team_id])
	@previous_sprint = @team.sprints.find(:last)
    @sprint = @team.sprints.new

	# guess the sprint name and end date
	t = Time.now
	@sprint.sprint_name = t.strftime "%Y.%m.%d"
	@sprint.end_date = t.strftime "%Y-%m-%d"
	# pre-populate some values from the previous sprint
	if @previous_sprint != nil
		@sprint.team_size = @previous_sprint.team_size if @previous_sprint.team_size != nil
		@sprint.working_days = @previous_sprint.working_days if @previous_sprint.working_days != nil
		@sprint.pto_days = @previous_sprint.pto_days if @previous_sprint.pto_days != nil
		# guess the planned velocity using the actual velocity from the prior sprint
		@sprint.planned_velocity = @previous_sprint.actual_velocity if @previous_sprint.actual_velocity != nil

		@sprint.code_coverage = @previous_sprint.code_coverage if @previous_sprint.code_coverage != nil
		@sprint.nr_manual_tests = @previous_sprint.nr_manual_tests if @previous_sprint.nr_manual_tests != nil
		@sprint.nr_automated_tests = @previous_sprint.nr_automated_tests if @previous_sprint.nr_automated_tests != nil
	end

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
