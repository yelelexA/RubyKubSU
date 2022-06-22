require "yaml"

class Department

    include Comparable 

    public attr_accessor :name
    public attr_reader :number

    def initialize(name,number,duties=[],post_list=Post_list.new())
        self.name= name
        self.number= number
        @duties=duties
        @duties_index_now=0
        @post_list=post_list if Post_list.is_Post?(post_list)
    end

    def number=(val)
      @number=val if Department.number?(val)
    end

    def duties_empty?()
      @duties.size==0
    end

    def to_s()
      return "название:#{self.name}  номер телефона:#{self.number}  обязанности:#{self.duties_read}"
    end

    def duties_add(dutie)
      @duties.push(dutie).uniq!()
    end

    def duties_read()
      sum=","
      @duties.each_with_index do |x,ind| 
        if(ind==@duties_index_now)
          sum+="[#{x}],"
        else
          sum+="#{x},"
        end
      end
      return sum
    end

    def duties_cursor(dutie)
      @duties_index_now = @duties.find_index(dutie) if @duties.find_index(dutie)!= nil
    end

    def duties_cursor_read()
      return @duties[duties_index_now].to_s if  !(self.duties_empty?) 
    end

    def duties_cursor_update(dutie)
      @duties[@duties_index_now]= dutie if !((@duties.include?(dutie)) & (self.duties_empty?))
    end

    def duties_cursor_delete()
      @duties.delete_at(@duties_index_now) if !(self.duties_empty?) 
      @duties_index_now=0
    end

    def Department.number?(number)
      return /\+[0-9]{11}/.match?(number)
    end

    def duties_size()
      @duties.size()
    end

    def <=>(val)
      return 0 if self.name== val.name || self.number== val.number
      return 1 if self.duties_size() > val.duties_size()
      return -1
    end

    def as_hash 
      {
        "name"=> self.name,
        "number"=> self.number,
        "duties"=> @duties,
        "posts"=>@post_list.mass_hash
      }
    end

    def to_s_full()
      self.to_s()+" "+@post_list.to_s()
    end

    def post_cursor=(val)
      @post_list.post_cursor=(val)
    end

    def post_cursor()
      @post_list.post_cursor
    end

    def post_add(val)
      @post_list.post_add(val)
    end

    def post_cursor_update(val)
      @post_list.post_cursor_update(val)
    end

    def post_cursor_delete()
      @post_list.post_cursor_delete()
    end

    def post_read()
      @post_list.post_read()
    end

    def post_free()
      @post_list.select{|x| x.isfree == false}
    end
end

class Department_list

  include Enumerable

  def initialize(departmens=[])
    @Department_list=departmens if Department_list.is_Departments?(departmens) || departmens.size==0
    self.Departments_cursor= nil
  end

  def Department_list.is_Departments?(val)
    c=true
    val.each{|x| c=false if !x.is_a?(Department)}
    return c
  end

  def each()

    for i in @Department_list do
      yield i
    end

  end

  def isempty?()
     @Department_list.size==0
  end

  def Departments_cursor=(val)
    @Department_cursor=@Department_list.find{|x|x.name==val} if !(self.isempty?)
  end

  def Departments_cursor()
    return @Department_cursor
  end

  def Departments_add(department)
    @Department_list.push(department) if !(@Department_list.include?(department))
  end

  def Department_cursor_delete()
    if !(self.isempty?) 
    @Department_list.delete(self.Departments_cursor ) 
    self.Departments_cursor= nil 
    end
  end

  def Department_read()
    sum=""
    self.each{|x| sum+=(x.to_s+"\n")}
    return sum
  end

  def Department_cursor_read()
    self.Departments_cursor.to_s
  end

  def Department_cursor_update(val)

    if  !@Department_list.include?(val)
      @Department_list[@Department_list.find_index{|x| x==self.Departments_cursor}]= val
      self.Departments_cursor= val
    end

  end

  def Department_list.import_from_txt(href)
    name=href[0,href.index(".")]
    name=name+".yaml"
    puts( system("del #{name}"))
    puts(system("ren #{href} #{name}"))
    rez=Department_list.import_from_YAML(name)
    puts( system("del #{href}"))
    puts(system("ren #{name} #{href}"))
    rez
  end

  def export_from_txt(href)
    name=href[0,href.index(".")]
    name=name+".yaml"
    self.export_from_YAML(name)
    puts ( system("del #{href}"))
    puts( system("ren #{name} #{href}"))
  end

  def to_s()
    self.Department_read()
  end

  def export_from_YAML(href)
    mass_dept=[]

    self.each{|x| mass_dept.push(x.as_hash)}
    File.open( href, 'w' ) do |out|
      YAML.dump( mass_dept, out )
    end
    
  end

  def Department_list.import_from_YAML(href)
    ya = YAML.load_file(href)
    mass_dept=[]

    ya.each do |x|
      name=x["name"]
      number=x["number"]
      duties=x["duties"]
      posts=Post_list.new()
      x["posts"].each{|y| posts.post_add(Post.new(y["department"],y["name"],y["salary"],y["isfree"]) )}
      dep= Department.new(name,number,duties,posts)
      mass_dept.push(dep)
    end

    new(mass_dept)
  end

  def to_s_full()
    sum=""
    self.each{|x| sum+=(x.to_s_full()+"\n")}
    return sum
  end

end

class Post
  include Comparable

  attr_reader :department,:name,:salary,:isfree

  def initialize(department,name,salary,isfree)
    @sal_creator= Salary_constructor.new()
    self.department= department
    self.name= name
    self.salary=  salary
    self.isfree=isfree
  end

  def Post.isPost?(department,name,salary,isfree)
    department.is_a?(String) & name.is_a?(String) & salary.is_a?(Integer) & (isfree.is_a?(TrueClass)|isfree.is_a?(FalseClass))
  end

   def Post.is_departments?(val)
    Post.isPost?(val," ",1,true)
  end

   def Post.is_name?(val)
    Post.isPost?("department",val,1,true)
  end

   def Post.is_salary?(val)
    Post.isPost?("department","name",val,true)
  end

   def Post.is_isfree?(val)
    Post.isPost?("department","name",1,val)
  end

  def department=(val)
    @department=val if Post.is_departments?(val)
  end

  def name=(val)
    @name =val if Post.is_name?(val)
  end

  def salary=(val) 
    @salary = @sal_creator.create_salary(val).get_salary 
  end

  def isfree=(val)
    @isfree = val if  Post.is_isfree?(val)
  end

  def salary
    @salary
  end

  def to_s()
    tf={
      true=>"да",
      false=>"нет"
    }
    "Должность:#{self.name} отдел:#{self.department} зарплата:#{self.salary} занята: #{tf[self.isfree]}"
  end

  def <=>(val)
    return 1 if self.isfree &  !val.isfree
    return -1
  end

  def as_hash 
    {
      "department"=>self.department,
      "name"=>self.name,
      "salary"=>@sal_creator.salary_param,
      "isfree"=>self.isfree
    }
  end

  class Salary_constructor

    attr_accessor :salary_param

    def initialize() 
    end
    
    def create_salary(hash={})
      self.salary_param=hash
      salary= Fix_sal.new(hash[:fixsal])
      salary=Rub_sal.new(salary,hash[:rub_sal])
      salary=Percent_sal.new(salary,hash[:percent_sal])
      salary=Fine_sal.new(salary,hash[:fine_sal])
      salary=Prem_sal.new(salary,hash[:prem_sal])
      salary
    end

  class Salary

    def get_salary()
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end

  class Fix_sal < Salary

    def initialize(fixed)
      @fixed =fixed
    end

    def get_salary()
      @fixed
    end
  end

  class Decorator_salary < Salary
    attr_accessor :salary
    def initialize(salary)
      self.salary=salary
    end

    def get_salary
      self.salary.get_salary
    end
  end

  class Rub_sal < Decorator_salary
    def initialize(salary,add_rub)
      @add_rub=add_rub
      super(salary)
    end

    def get_salary()
      self.salary.get_salary + @add_rub
    end
  end

  class Percent_sal < Decorator_salary
    def initialize(salary,percent)
      super(salary)
      @percent=percent
    end

    def get_salary()
      r=rand() 
      salary=self.salary.get_salary
     return salary + salary*@percent/100 if r<0.5
     return salary
    end
  end

  class Fine_sal < Decorator_salary
    def initialize(salary,fine)
      super(salary)
      @fine=fine
    end

    def get_salary()
      self.salary.get_salary -  @fine
    end
  end

  class Prem_sal < Decorator_salary
    def initialize(salary,percent)
      super(salary)
      @percent=percent
    end

    def get_salary()
      salary=self.salary.get_salary
     return salary + salary*@percent/100
    end
  end
  end

  def get_salary(val)
     @salary= @sal_creator.create_salary(val).get_salary
  end
end

class Post_list
  include Enumerable
  def initialize(posts=[])
    @post_list=posts if Post_list.is_Post?(posts) || posts.size==0
    self.post_cursor= nil
  end

  def Post_list.is_Post?(posts)
    c=true
    posts.each{|x| c=false if !x.is_a?(Post)}
    return c
  end

  def each()
    for i in @post_list do
      yield i
    end
  end

  def isempty?()
    @post_list.size==0
  end

  def post_cursor=(val)
    @post_cursor=@post_list.find{|x| x.name== val} if !(self.isempty?)
  end

  def post_cursor()
    return @post_cursor
  end

  def post_add(post)
    @post_list.push(post)  if !(@post_list.include?(post))
  end

  def post_cursor_delete()

    if !(self.isempty?) 
      @post_list.delete(self.post_cursor) 
       self.post_cursor=nil 
    end

  end

  def post_read()
    sum=""
    self.each{|x| sum+=(x.to_s+"\n")}
    return sum
  end

  def post_cursor_read()
    self.post_cursor.to_s
  end

  def post_cursor_update(val)
      @post_list[@post_list.find_index{|x| x==self.post_cursor}]= val
      self.post_cursor= val.name 
  end

  def to_s()
    self.post_read()
  end
  
  def mass_hash()
    list = []
    @post_list.each{|x| list.push(x.as_hash)}
    return list
  end
  end