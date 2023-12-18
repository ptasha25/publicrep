using HorizonSideRobots

function tolim!(robot, side)
  if !isborder(robot, side)
    move!(robot,side)
    tolim!(robot, side)
  end
end

r = Robot(animate = true)
tolim!(r, Ost)