using HorizonSideRobots

inverse(Side)::HorizonSide = HorizonSide((Int(Side)+2)%4)

function tolim!(robot, side)
  if !isborder(robot, side)
    move!(robot,side)
    tolim!(robot, side)
  end
end

function to_symmetric_position(robot, side)
  if isborder(robot, side)
    tolim!(robot, inverse(side))
  else
    move!(robot,side)
    to_simmetric_position(robot, side)
    move!(robot,side)
  end
end

r = Robot("21.sit", animate = true)
to_symmetric_position(r, Ost)