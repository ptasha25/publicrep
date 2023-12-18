using HorizonSideRobots

moves!(r::Robot, side::HorizonSide, num_steps::Int) = 
for _ in 1:num_steps
    move!(r,side)
end

function find_passage(r)
  n = 0
  side = Ost
  while isborder(r,Nord)==true
    n += 1
    moves!(r, side, n)
    side = inverse(side)
  end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2,4))

r = Robot("7.sit", animate = true)
find_passage(r)