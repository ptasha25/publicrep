function fib_norecurs(n::Integer)
  F_prev = F_next = 1
  while n>0
    F_next, F_prev = F_next+F_prev, F_next
    n -= 1
  end
  return F_prev
end

print(fib_norecurs(5))