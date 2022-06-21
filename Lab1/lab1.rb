 puts ('#123')
 puts "hello world1"
 print "hello world2\n"

 puts "Привет, #{ARGV[0]}"
 puts String.instance_methods

puts "Твой любимый ЯП?"
lang = STDIN.gets.chomp
case "ruby"
when STDIN.gets.chomp
	puts "подлиза"
else
	puts "а будет руби"
end

puts "Введи команду Ruby:"
rub=STDIN.gets.chomp
eval(rub)
puts "А теперь OS:"
rub=STDIN.gets.chomp
system(rub)



def sum_chi(chi)
    return chislo=chi.to_s.chars.inject(0){|sum,x| sum + x.to_i }
end
def max_chi(chi)
    return chislo=chi.to_s.chars.max
end
def min_chi(chi)
    return chislo=chi.to_s.chars.min
end
def mult_chi(chi)
    return chislo=chi.to_s.chars.inject(1){|sum,x| sum * x.to_i }
end
def prost(chi)
return x=(1..(chi/2)+1).select{|x| chi%x==0}.size<=1
end
def method_1(chi)
 return (1..(chi/2)+1).select{|x| prost(x) and chi%x==0}.max
end
def method_2(chi)
    return chislo=chi.to_s.chars.select{|x| x!=5 }.inject(1){|sum,x| sum * x.to_i }
end
def Nod(chi1,chi2)
 return chi1 if chi1==chi2
 return Nod([chi1,chi2].min,(chi1-chi2).abs)
end
def method_3(chi)
 return Nod(mult_chi(chi),(1..(chi)).select{|x| (not prost(x)) and chi%x==0 and x%2!=0}.max)
 end

if ARGV.size==0
    print("Hello world")

else 
    print("введите число")
    arg=STDIN.gets.chomp
    puts eval(ARGV[0]+"("+arg+")")
end


