using HorizonSideRobots

function inverse(Side)::HorizonSide
  return HorizonSide((Int(Side)+2)%4)
end

function HorizonSideRobots.isborder(robot, Side::NTuple{2, HorizonSide})::Bool
  if !isborder(robot, Side[1])
    move!(robot, Side[1])
  else return 1
  end
  if !isborder(robot, Side[2])
    move!(robot, Side[2])
  else
    move!(robot, inverse(Side[1]))
    return 1
  end
  move!(robot, inverse(Side[2]))
  move!(robot, inverse(Side[1]))
  return 0
end

function HorizonSideRobots.move!(robot, Side::NTuple{2, HorizonSide})
  move!(robot, Side[1])
  move!(robot, Side[2])
end

function main(robot)
  sides = (Ost, Nord)
  while !isborder(robot, sides)
    move!(robot, sides)
    putmarker!(robot)
  end
  sides = (inverse(sides[1]), inverse(sides[2]))
  while ismarker(robot)
    move!(robot, sides)
  end
  while !isborder(robot, sides)
    move!(robot, sides)
    putmarker!(robot)
  end
  sides = (inverse(sides[1]), inverse(sides[2]))
  while ismarker(robot)
    move!(robot, sides)
  end
  sides = (West, Nord)
  while !isborder(robot, sides)
    move!(robot, sides)
    putmarker!(robot)
  end
  sides = (inverse(sides[1]), inverse(sides[2]))
  while ismarker(robot)
    move!(robot, sides)
  end
  while !isborder(robot, sides)
    move!(robot, sides)
    putmarker!(robot)
  end
  sides = (inverse(sides[1]), inverse(sides[2]))
  while ismarker(robot)
    move!(robot, sides)
  end
  putmarker!(robot)
end

r = Robot("4.sit", animate = true)
main(r)