class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :set_project

  # GET /tasks or /tasks.json
  def index
    # @tasks = Task.where(project_id: @project.id)
    @tasks = @project.tasks
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.project_id = @project.id

    respond_to do |format|
      if @task.save
        format.html { redirect_to project_task_url(@project, @task), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to project_task_url(@project, @task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to project_tasks_url(@project), notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def change_status
    begin
      task_service.change_status(task_id: params[:task_id].to_i)

      respond_to do |format|
        format.html { redirect_to project_tasks_url(@project), notice: 'Task was successfull updated.' }
        format.json { head :no_content }
      end
    rescue TaskNotFoundException => e
      respond_to do |format|
        format.html { redirect_to project_tasks_url(@project), notice: e.message }
        format.json { { notice: e.message } }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :date_start, :date_end, :state, :project_id)
    end

    def set_project
      @project ||= Project.find_by(id: params[:project_id].to_i)
    end

    def task_service
      @task_service ||= TaskService.new
    end
end
