TaskManagement::App.controllers :user_tasks do
  

  get :new do
    @user_task = User_Task.new
    render 'user_tasks/new'
  end

  get :latest do
    @user_tasks_temp = User_Task.all
    @user_tasks = []
    @user_tasks_temp.each do |i|
      if(i.id_user == current_user.id)
        @user_tasks.push(i)
      end
    end
    render 'user_tasks/list'
  end 

  post :done do
    @user_tasks = User_Task.all
    @users_temp = User.find_all{|x| not x.is_teacher}
    @users_accomplish = []
    @users_not_accomplish = []
    @user_tasks.each do |ut|
      if(ut.id_task.to_s() == (params[:task_id]))
        @users_temp.each do |us|
          if(ut.id_user == us.id)
            @users_accomplish.push(us)
          end
        end
      end
    end
    @users_not_accomplish = @users_temp - @users_accomplish
    render 'user_tasks/done_list'
  end   

  post :create do
    @user_task_tmp = User_Task.find_all{|x| (x.id_user.to_s() == params[:user_id]) && (x.id_task.to_s() == params[:task_id])}
    if (@user_task_tmp[0] == nil)
      @user_task = User_Task.new
      @user_task.id_task = (params[:task_id])
      @user_task.id_user = (params[:user_id])
      @user_task.title = (params[:task_title])
      @user_task.limit_date = (params[:task_date])
      @user_task.save
      render 'user_tasks/new' 
    else
      @user_task = @user_task_tmp[0]
      render 'user_tasks/new' 
    end  
  end 

  post :update, :with => :id_user_task do
    @user_task = User_Task.get(params[:id_user_task])
    @user_task.update(params[:user_task])
    if(@user_task.estimated_time == '')
      flash[:error] = 'El tiempo estimado es obligatorio'
      @user_task.destroy
      redirect 'tasks/latest'
    end
    if(@user_task.real_time == '')
      @user_task.real_time = 0
    end
    if @user_task.save
      flash[:success] = 'Tarea guardada correctamente'
    else
      flash.now[:error] = 'Error al estimar la tarea'
    end
    redirect '/'
  end  


end
#   get :my do
#     @tasks = Task.find_by_owner(current_user)
#     render 'tasks/my_tasks'
#   end    

#   get :index do
#     @tasks = Task.all
#     render 'tasks/search'
#   end  

#   get :new do
#     @task = Task.new
#     render 'tasks/new'
#   end

#   get :latest do
#     @tasks = Task.all
#     render 'tasks/list'
#   end

#   get :edit, :with =>:task_id  do
#     @task = Task.get(params[:task_id])
#     # ToDo: validate the current user is the owner of the task
#     render 'tasks/edit'
#   end

#   get :apply, :with =>:task_id  do
#     @task = Task.get(params[:task_id])
#     # ToDo: validate the current user is the owner of the task
#     render 'tasks/apply'
#   end

#   post :create do
#     @task = Task.new(params[:task])
#     @task.owner = current_user
#     if @task.save
#       flash[:success] = 'Task created'
#       redirect '/tasks/my'
#     else
#       flash.now[:error] = 'Title is mandatory'
#       render 'tasks/new'
#     end  
#   end

#   post :update, :with => :task_id do
#     @task = Task.get(params[:task_id])
#     @task.update(params[:task])
#     if @task.save
#       flash[:success] = 'Task updated'
#       redirect '/tasks/my'
#     else
#       flash.now[:error] = 'Title is mandatory'
#       render 'tasks/edit'
#     end  
#   end

#   delete :destroy do
#     @task = Task.get(params[:task_id])
#     if @task.destroy
#       flash[:success] = 'Task deleted'
#     else
#       flash.now[:error] = 'Title is mandatory'
#     end
#     redirect 'tasks/my'
#   end

# end
