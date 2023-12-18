using HorizonSideRobots

inverse(Side)::HorizonSide = HorizonSide((Int(Side)+2)%4)

function marklim!(robot, side)
  if isborder(robot, side)
    putmarker!(robot)
  else
    move!(robot, side)
    marklim!(robot, side)
    move!(robot, inverse(side))
  end
end

r = Robot(animate = true)
marklim!(r, Ost)