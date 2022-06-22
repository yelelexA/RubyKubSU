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
    self.department= department
    self.name= name
    self.salary=salary
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
    @salary = val if  Post.is_salary?(val)
  end

  def isfree=(val)
    @isfree = val if  Post.is_isfree?(val)
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
      "salary"=>self.salary,
      "isfree"=>self.isfree
    }
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









number="+89181311793"
a=Department.new("A",number)
b=Department.new("A","+89181311794")
c=Department.new("Z","+89181311795")
deps = Department_list.new()
a.duties_add("работать")
deps.Departments_add(a)
deps.Departments_add(b)
deps.Departments_add(c)
deps.Departments_cursor="A"
puts(deps)
deps.Departments_cursor.duties_add("не работать")
puts(deps)
deps.Departments_cursor= "Z"
puts(deps.Departments_cursor)
deps.Department_cursor_delete()
puts(deps)
deps.export_from_txt("text.txt")
di = Department_list.import_from_txt("text.txt")
di.Departments_cursor= "Z"
di.export_from_YAML("ya.yaml")
ro =Department_list.import_from_YAML("ya.yaml")
po1= Post.new("отдел продаж","продажник",2001,true)
po2= Post.new("отдел закупок","закупщик",5000,true)
po3= Post.new("клеар","уборщик",10000,false)
po = Post_list.new()
po.post_add(po1)
po.post_add(po2)
po.post_add(po3)
puts(po)
po.post_cursor= "продажник"
puts(po.post_cursor)
po.post_cursor="уборщик"
po.post_cursor_delete()
puts(po)
po.post_cursor="продажник"
po.post_cursor_update(po3)
puts(po)
puts(po.post_cursor)
puts "\n\n\n\n\n"
puts(po)
puts "\n\n\n\n\n"
puts(ro)
ro.Departments_cursor="A"
puts(ro.Departments_cursor)
ro.Departments_cursor.post_add(po1)
ro.Departments_cursor.post_add(po2)
ro.Departments_cursor.post_add(po3)
puts()
puts(ro.to_s_full)
ro.export_from_txt("text.txt")
ro.export_from_YAML("ya.yaml")
ro11 = Department_list.import_from_YAML("ya.yaml")
puts(ro11.to_s_full)
ro11.Departments_cursor="A"
puts(ro11.Departments_cursor.post_free)