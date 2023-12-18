using HorizonSideRobots

inverse(Side)::HorizonSide = HorizonSide((Int(Side)+2)%4)

function doubledist!(robot, side)
  if !isborder(robot,side)
    move!(robot,side)
    doubledist!(robot, side)
    if !isborder(robot, inverse(side))
      move!(robot,inverse(side))
      move!(robot, inverse(side))
    else
      return false
    end
  end
  return true
end

r = Robot("22.sit", animate = true)
print(doubledist!(r, Ost))