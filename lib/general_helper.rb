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