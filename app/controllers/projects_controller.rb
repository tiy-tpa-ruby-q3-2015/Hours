include TimeSeriesInitializer

class ProjectsController < ApplicationController
  def index
    @projects = Project.unarchived.by_last_updated.page(params[:page]).per(7)

    @hours_entry = Hour.new
    last_hour_entry = current_user.hours.last
    if last_hour_entry
      @hours_entry.project_id = last_hour_entry.project_id
      @hours_entry.category_id = last_hour_entry.category_id
    end

    @mileages_entry = Mileage.new
    last_mileage_entry = current_user.mileages.last
    if last_mileage_entry
      @mileages_entry.project_id  = last_mileage_entry.project_id
    end

    @activities = Hour.by_last_created_at.limit(30)
  end

  def show
    @time_series = time_series_for(resource)
  end

  def edit
    resource
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to root_path, notice: t(:project_created)
    else
      render action: "new"
    end
  end

  def update
    if resource.update_attributes(project_params)
      redirect_to project_path(resource), notice: t(:project_updated)
    else
      render action: "edit"
    end
  end

  private

  def entry_type
    request.fullpath == mileage_entry_path ? "mileages" : "hours"
  end

  def resource
    @project ||= Project.find_by_slug(params[:id])
  end

  def project_params
    params.require(:project).
      permit(:name, :billable, :client_id, :archived, :description, :budget)
  end
end
