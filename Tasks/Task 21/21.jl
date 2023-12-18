using HorizonSideRobots

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)-1, 4))

function step!(robot, side)
  if !isborder(robot, side)
    move!(robot, side)
  else
    move!(robot, left(side))
    step!(robot, side)
    move!(robot, right(side))
  end
end

r = Robot("21.sit", animate = true)
step!(r, Ost)