class Department
    public attr_accessor :name, :number
    def initialize(name,number)
        self.name= name
        self.number= number
        @duties=[]
        @duties_index_now=0
    end

    def duties_empty?()
      @duties.size==0

    def transToString
      return "Name:#{self.name}  Phone number:#{self.number} Requirements:#{self.duties_read}"
    end

    def duties_add(dutie)
      @duties.push(dutie).uniq!()
    end
    def duties_read()
      sum=","
      @duties.each_with_index do |x,ind| 
        if(ind==@duties_index_now)
          sum+="{#{x}},"
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
      return @duties[duties_index_now].transToString if  !(self.duties_empty?)
    end
    def duties_cursor_update(dutie)
      @duties[@duties_index_now]=dutie if !((@duties.include?(dutie)) & (self.duties_empty?))
    end
    def duties_cursor_delete()
        @duties.delete_at(@duties_index_now) if !(self.duties_empty?) 
        @duties_index_now=0
    end
end

a=Department.new("1","2")
puts(a)
a.duties_add("a")
a.duties_add("b")
a.duties_add("c")
puts(a.duties_read)
a.duties_cursor("z")
a.duties_cursor_update("x")
puts(a.duties_read)
a.duties_cursor_delete
puts(a.duties_read)