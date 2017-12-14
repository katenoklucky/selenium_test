def ascending? (array)
  result = true
  array.reduce { |l, r| break unless result &= (l[0] <= r[0]); l }
  result
end

def descending? (array)
  result = true
  array.reduce { |l, r| break unless result &= (l[0] >= r[0]); l }
  result
end

def generate_random_value(count_symbols)
  random_value = ''
  count_symbols.times{ random_value << ((rand(2)==1?65:97) + rand(25)).chr }
  random_value
end