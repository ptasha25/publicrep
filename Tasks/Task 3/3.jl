using HorizonSideRobots

function inverse(Side)
  Side = HorizonSide((Int(Side)+2)%4)
end

function moves!(r::Robot, side::HorizonSide)
  num_steps=0
  while isborder(r,side)==false
    move!(r,side)
    num_steps+=1
  end
  return num_steps
end

function moves!(r::Robot,side::HorizonSide,num_steps::Int)
  for _ in 1:num_steps
    move!(r,side)
  end
end

function all!(robot, Side)
  while !isborder(robot, Side)
    move!(robot, Side)
    putmarker!(robot)
  end
end

function inpoint(robot)
  while !isborder(robot, Sud)
    move!(robot, Sud)
  end
  while !isborder(robot, West)
    move!(robot, West)
  end
end

function main(robot)
  num_sud = moves!(robot, Sud)
  num_west = moves!(robot, West)
  Side = Ost
  putmarker!(robot)
  all!(robot, Side)
  while !isborder(robot, Nord)
    move!(robot, Nord)
    putmarker!(robot)
    Side = inverse(Side)
    all!(robot, Side)
  end
  inpoint(robot)
  moves!(robot, Nord, num_sud)
  moves!(robot, Ost, num_west)
end

r = Robot("temp.sit", animate = true)
main(r)