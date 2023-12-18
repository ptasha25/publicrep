using HorizonSideRobots

along!(r::Robot, side::HorizonSide, num_steps::Int) = 
for _ in 1:num_steps
    move!(r,side)
end

function shuttle!(stop_condition::Function, robot, side)
  n=0
  while stop_condition()
    n += 1
    along!(robot, side, n)
    side = inverse(side)
  end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2,4))

r = Robot("7.sit", animate = true)
shuttle!(() -> isborder(r, Nord), r, Ost)