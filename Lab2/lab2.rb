class Department
    attr_accessor :name, :number
    def initialize(name,number)
        self.name= name
        self.number= number
    end
    def transToString
      return "Name:#{self.name}  Phone number:#{self.number}"
    end
end