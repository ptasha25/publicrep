using HorizonSideRobots

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))

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
  ortogonal_side = left(side)
  reverse_side = inverse(ortogonal_side)
  while n < num_maxsteps && stop_condition() == false
    if !isborder(r, side)
      n += 1
      move!(robot, side)
    else
      num_steps = 0
      while isborder(r, side)
        move!(r, ortogonal_side)
        num_steps += 1
      end
      move!(r, side)
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

r = Robot("18a.sit", animate = true)
spiral!(() -> ismarker(r), r)