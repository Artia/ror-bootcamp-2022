class TaskService < ApplicationService 
    def create_task (task)
        is_saved = task.save
        project_service.update_percent_complete(project_id: task.project_id)
        is_saved ? true : false
    end

    def destroy_task (task_id:)
        task = find.task(task_id: task_id)
        raise TaskNotFoundException if task.blank?
        task.destroy
        project_service.update_percent_complete(project_id: task.project_id)
    end

    def edit_task (task_id:, task_params:)
        task = find.task(task_id: task_id)
        raise TaskNotFoundException if task.blank?
        task.save
        project_service.update_percent_complete(project_id: task.project_id)
    end

    def change_status(task_id:)
        task = find_task(task_id: task_id)
        raise TaskNotFoundException if task.blank?
        task = task_update(task, state: !task.state)
        task.save
        project_service.update_percent_complete(project_id: task.project_id)
    end

    private

    def find_task(task_id:)
        Task.find_by(id: task_id)
    end


    def task_update(task, args = {})
        task.assign_attributes(args)
        task
    end

    def project_service
        @project_service ||= ProjectService.new
    end
end