using HorizonSideRobots

function inverse(Side)::HorizonSide
  return HorizonSide((Int(Side)+2)%4)
end

function MarkerRam(robot, side)
  while !ismarker(robot)
    while isborder(robot, HorizonSide((Int(side)+1)%4)) && !ismarker(robot)
      putmarker!(robot)
      move!(robot, side)
    end
    if !ismarker(robot)
      putmarker!(robot)
      side = HorizonSide((Int(side)+1)%4)
      move!(robot, side)
    end
  end
end

function Perimetr(robot)
  for side in (Ost, Nord, West, Sud)
    while !isborder(robot, side)
      move!(robot, side)
      putmarker!(robot)
    end
  end
end

function Find(robot, side)
  while !isborder(robot, Nord)
    if !isborder(robot, side)
      move!(robot, side)
    else
      move!(robot, Nord)
      side = inverse(side)
    end
  end
end

function to_start(robot, step_west, step_sud)
  while step_west != 0 || step_sud != 0
    while !isborder(robot, Ost) && step_west != 0
      move!(robot, Ost)
      step_west -= 1
    end
    while !isborder(robot, Nord) && step_sud != 0
      move!(robot, Nord)
      step_sud -= 1
    end
  end
end

function InPoint(robot, step_west, step_sud)
  while !isborder(robot, West)
    move!(robot, West)
    step_west += 1
    while !isborder(robot, Sud)
      move!(robot, Sud)
      step_sud += 1
    end
  end
  step_west, step_sud
end

function InPoint(robot)
  while !isborder(robot, West)
    move!(robot, West)
    while !isborder(robot, Sud)
      move!(robot, Sud)
    end
  end
end

function main(robot)
  step_west = 0
  step_sud = 0
  step_west, step_sud = InPoint(r, step_west, step_sud)
  side = Ost
  Find(robot, side)
  MarkerRam(robot, side)
  InPoint(robot)
  Perimetr(robot)
  to_start(robot, step_west, step_sud)
end

r = Robot("5.sit", animate = true)
main(r)