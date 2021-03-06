class User_Task
  include DataMapper::Resource

  property :id, Serial
  property :id_user, Integer
  property :id_task, Integer
  property :title, String
  property :estimated_time, Integer
  property :real_time, Integer
  property :limit_date, Date

  validates_presence_of :title
  validates_presence_of :limit_date
  
end
