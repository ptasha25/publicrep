using HorizonSideRobots

function move_with_markers!(robot, side, step)
  move!(robot, side)
  step += 1
  if !isborder(robot, side)
    move!(robot, side)
    step += 1
    putmarker!(robot)
  end
  return step
end

function move_sum!(robot::Robot, side::HorizonSide, num::Int)
  for _ in 1:num
    move!(robot, side)
  end
end

function move2!(robot, side)
  move!(robot, side)
  if !isborder(robot, side)
    move!(robot, side)
  end
end

function InPoint(robot, step_sud, step_west)
  putmarker!(robot)
  while !isborder(robot, Sud)
    step_sud = move_with_markers!(robot, Sud, step_sud)
  end
  if !ismarker(robot) && !isborder(robot, West)
    move!(robot, West)
    step_west += 1
  end
  while !isborder(robot, West)
    step_west = move_with_markers!(robot, West, step_west)
  end
  return step_sud, step_west
end

function point_to(robot)
  while !isborder(robot, Sud)
    move!(robot, Sud)
  end
  while !isborder(robot, West)
    move!(robot, West)
  end
end

function main(robot)
  step_sud = 0
  step_west = 0
  step_sud, step_west = InPoint(r, step_sud, step_west)
  side = Ost
  if !ismarker(robot)
    move!(robot, side)
  end
  while !isborder(robot, Nord) || !isborder(robot, side)
    while !isborder(robot, side)
      putmarker!(robot)
      move2!(robot, side)
    end
    if !isborder(robot, Nord)
      side = inverse(side)
    end
    if ismarker(robot) && !isborder(robot, Nord)
      move!(robot, Nord)
      move!(robot, side)
    else
      if !isborder(robot, Nord)
        move!(robot, Nord)
      end
    end
  end
  point_to(robot)
  to_start(r, step_sud, step_west)
end

function to_start(robot, step_sud, step_west)
  move_sum!(robot, Nord, step_sud)
  move_sum!(robot, Ost, step_west)
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

r = Robot("temp.sit", animate = true)
main(r)