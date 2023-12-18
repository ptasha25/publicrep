using HorizonSideRobots

function through_rectangles_into_angle(r,angle::NTuple{2,HorizonSide})
  num_steps=[]
  while !isborder(r,angle[1]) || !isborder(r,angle[2])
      push!(num_steps, movements!(r, angle[2]))
      push!(num_steps, movements!(r, angle[1]))
  end
  return num_steps
end

function movements!(r,side)
  num_steps=0
  while !isborder(r,side)
      move!(r,side)
      num_steps+=1
  end
  return num_steps
end

function movements!(r,sides::Tuple{HorizonSide, HorizonSide},num_steps::Vector{Any})
  for (i,n) in enumerate(num_steps)
      movements!(r, sides[mod(i-1, length(sides))+1], n)
  end
end

movements!(r,side,num_steps::Int) = for _ in 1:num_steps move!(r,side) end

function mark_centers(r)
  num_steps = through_rectangles_into_angle(r,(Sud,West))

  num_steps_to_ost = sum(num_steps[1:2:end])
  num_steps_to_nord = sum(num_steps[2:2:end])

  movements!(r,Nord,num_steps_to_nord)
  putmarker!(r)
  num_steps_to_sud = movements!(r,Nord)

  movements!(r,Ost,num_steps_to_ost)
  putmarker!(r)
  num_steps_to_west = movements!(r,Ost)

  movements!(r,Sud,num_steps_to_sud)
  putmarker!(r)
  movements!(r,Sud)

  movements!(r,West,num_steps_to_west)
  putmarker!(r)
  movements!(r,West)

  movements!(r,(Ost,Nord),num_steps)
end

r = Robot("5.sit", animate = true)
mark_centers(r)