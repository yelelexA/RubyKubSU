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

###############################################################

def summ(num)
    return chislo=num.to_s.chars.inject(0){|sum,x| sum + x.to_i }
end
def maxx(num)
    return chislo=num.to_s.chars.max
end
def minn(num)
    return chislo=num.to_s.chars.min
end
def multip(num)
    return chislo=num.to_s.chars.inject(1){|sum,x| sum * x.to_i }
end
def prost(num)
return x=(1..(num/2)+1).select{|x| num%x==0}.size<=1
end
def method_1(num)
 return (1..(num/2)+1).select{|x| prost(x) and num%x==0}.max
end
def method_2(num)
    return chislo=num.to_s.chars.select{|x| x!=5 }.inject(1){|sum,x| sum * x.to_i }
end
def Nod(num1,num2)
 return num1 if num1==num2
 return Nod([num1,num2].min,(num1-num2).abs)
end
def method_3(num)
 return Nod(multip(num),(1..(num)).select{|x| (not prost(x)) and num%x==0 and x%2!=0}.max)
 end

if ARGV.size==0
    print("Hello world")

else 
    print("введите число")
    arg=STDIN.gets.chomp
    puts eval(ARGV[0]+"("+arg+")")
end

###############################################################

def mult(arg)
multt=1
for i in arg do
    multt*=i
end
return multt
end

def sum(arg)
summ=0
for i in arg do
    summ+=i
end
return summ
end

def min(arg)
    min=arg[0]
    for i in arg do
        if min>i
            min=i
        end
    end
return min
end

def max(arg)
max=arg[0]
for i in arg do
    if max<i
        max=i
    end
end
return max
end

if ARGV[1]=="abc" then
    puts "Enter Array"
    string=(STDIN.gets.chomp).split(",").map!{|x| x.to_i}
else
    string = File.open(ARGV[2],"r"){ |file| file.read }
string=string.split(",").map!{|x| x.to_i}
end

puts eval(ARGV[0]+"(string)")

###############################################################

