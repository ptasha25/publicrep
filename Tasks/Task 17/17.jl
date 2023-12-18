using HorizonSideRobots

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))

function along!(stop_condition::Function, robot, side, num_maxsteps::Int)
  n = 0
  while n < num_maxsteps && stop_condition() == false
      n += 1
      move!(robot, side)
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

next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))

r = Robot("8.sit", animate = true)
spiral!(() -> ismarker(r), r)