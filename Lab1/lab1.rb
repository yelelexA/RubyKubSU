#1
=begin	
1234
=end
# 1234
 puts ('#123')
 puts "hello world1"
 print "hello world2\n"

 #задание 2
 puts "Привет, #{ARGV[0]}"
# получаем методы класса String
 puts String.instance_methods

#задание 3
puts "Твой любимый ЯП?"
lang = STDIN.gets.chomp

case "ruby"
when STDIN.gets.chomp
	puts "подлиза"
else
	puts "а будет руби"
end

# задание 4
puts "Введи команду Ruby"
rub=STDIN.gets.chomp
eval(rub)
puts "А теперь OS"
rub=STDIN.gets.chomp
system(rub)