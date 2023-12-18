using HorizonSideRobots

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))

function shuttle!(stop_condition::Function, robot, side)
  n = 0
  real_steps = 0
  while stop_condition()
    n += 1
    movements!(robot, side, n)
    side = inverse(side)
    if !iseven(n)
      real_steps += 1
    end
  end
  return real_steps, inverse(side)
end

function inverse(Side)::HorizonSide
  return HorizonSide((Int(Side)+2)%4)
end

function movements!(r::Robot, side::HorizonSide, num_steps::Int)
  for _ in 1:num_steps
    move!(r,side)
  end
end

function along!(stop_condition::Function, robot, side, num_maxsteps::Int)
  n = 0
  while n < num_maxsteps && stop_condition() == false
    ortogonal_side = left(side)
    if !isborder(r, side)
      n += 1
      move!(robot, side)
    else
      num_steps, ortogonal_side = shuttle!(() -> isborder(r, side), r, ortogonal_side)
      move!(r, side)
      reverse_side = inverse(ortogonal_side)
      movements!(r, reverse_side, num_steps)
      n += 1
    end
  end
  return n
end

function spiral!(stop_condition::Function, robot; start_side = Nord, nextside::Function = left)
  side = start_side
  n = 0
  while stop_condition() == false
    if iseven(Int(side))
        n += 1
    end
    along!(stop_condition, robot, side, n)
    side = nextside(side)
    along!(stop_condition, robot, side, n)
    side = nextside(side)
  end
end

r = Robot("18b.sit", animate = true)
spiral!(() -> ismarker(r), r)