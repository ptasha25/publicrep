using HorizonSideRobots

function tolim!(robot, side)
  if !isborder(robot, side)
    mark_field(robot, side)
  end
end

function mark_field(robot, side)
  move!(robot, side)
  putmarker!(robot)
  if !isborder(robot, side)
    move!(robot, side)
  end
  tolim!(robot, side)
end


r = Robot(animate = true)
tolim!(r, Ost)