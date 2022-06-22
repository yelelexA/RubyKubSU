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
      super(salary)
      @add_rub=add_rub
    end
    def get_salary()
      self.salary.get_salary + @add_sub
    end
  end
  class Percent_sal < Decorator_salary
    def initialize(salary,percent)
      super(salary)
      @percent=percent
    end
    def get_salary()
      r=rand() 
     return self.salary.get_salary + self.salary.get_salary*@percent/100 if r<0.5
     return self.salary.get_salary
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
     return self.salary.get_salary + self.salary.get_salary*@percent/100
    end
  end