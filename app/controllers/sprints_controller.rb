class SprintsController < ApplicationController
  before_action :set_team, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :set_sprint, only: [:show, :edit, :update, :destroy]
  include SprintsHelper

  def show
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

  def new
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

  def edit
  end

  def create
    @sprint = @team.sprints.create(sprint_params)
    redirect_to team_path(@team)
  end

  def update
    respond_to do |format|
      if @sprint.update(sprint_params)
	format.html { redirect_to [@sprint.team, @sprint], notice: 'Sprint was successfully updated.' }
	format.json { head :no_content }
      else
	format.html { render action: "edit" }
	format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sprint.destroy
    redirect_to team_path(@team)
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_sprint
    @sprint = @team.sprints.find(params[:id])
  end

  def sprint_params
    params.require(:sprint).permit(:sprint_name, :end_date, :team_size, :working_days, :pto_days, :planned_velocity, :actual_velocity, :adopted_points, :unplanned_points, :found_points, :partial_points, :code_coverage, :nr_automated_tests, :note)
  end

end
