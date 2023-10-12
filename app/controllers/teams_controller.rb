class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  include SprintsHelper
  include ForecastHelper

  def index
    @teams = Team.order("UPPER(name) asc")
    @active_teams = @teams.where(:is_archived => false)
    @archived_teams = @teams.where(:is_archived => true)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teams }
    end
  end

  def show
    @summary_sprint = last_complete_sprint(@team.sprints)
    @first_sprint = @team.sprints.first
    @last_sprint = @team.sprints.last
    @linear_regression = get_linear_regression_actual_velocity(@team.sprints, @last_sprint)
    @averages_set = last_n_sprints_inclusive(@team.sprints, @summary_sprint, 6)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @team }
    end
  end

  def averages
    @teams = Team.order("UPPER(name) asc")
    @active_teams = @teams.where(:is_archived => false)
    @archived_teams = @teams.where(:is_archived => true)

    respond_to do |format|
      format.html # averages.html.erb
      format.json { render json: @teams }
    end
  end

  def new
    @team = Team.new
    @team.owners = current_user.login if current_user != nil
    @team.build_trello_account

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team }
    end
  end

  def edit
    @team.build_trello_account if @team.trello_account.nil?
  end

  def create
    @team = Team.new(team_params)
    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { render action: "new" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end

  def forecast
    @team = Team.find(params[:team_id])
    acct = @team.trello_account
    proxy = TrelloProxy.create(acct[:public_key], acct[:read_token], acct[:board_id])
    board = proxy.board
    l = board.list_starts_with acct[:list_name_for_backlog]
    full_cards = l.cards(filter: :open)
    cards = process_cards(full_cards)
    respond_to do |format|
      format.json { render json: cards }
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :sprint_weeks, :owners, :is_archived, :test_certification, :day_of_week_for_meetings, trello_account_attributes: [:public_key, :read_token, :board_id, :list_name_for_backlog])
  end

  def process_cards(full_cards)
    cards = full_cards.map do |c|
      { name: c.name, url: c.url, estimate: size_of_card(c) }
    end
    cards
  end
end
