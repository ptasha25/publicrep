function fib_recurs(n::Integer, dict::Dict{Int, Int})
  if n in (0,1)
    return 1
  end
  if !haskey(dict, n-2)
    f_prevprev = fib_recurs(n-2, dict)
    get!(dict, n-2, f_prevprev)
  else
    f_prevprev = dict[n-2]
  end
  if !haskey(dict, n-1)
    f_prev = fib_recurs(n-1, dict)
    get!(dict, n-1, f_prev)
  else
    f_prev = dict[n-1]
  end
  return f_prevprev + f_prev
end

function memoize_fibonacci(n::Integer)
  dict = Dict{Int,Int}()
  return fib_recurs(n, dict)
end

print(memoize_fibonacci(5))