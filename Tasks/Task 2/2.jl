using HorizonSideRobots

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

function putmarkers!(r::Robot, side::HorizonSide)
  while isborder(r,side)==false
    move!(r,side)
    putmarker!(r)
  end
end

function mark_frame_perimetr!(r::Robot)
  num_sud = moves!(r, Sud)
  num_west = moves!(r, West)

  for side in (Nord, Ost, Sud, West)
    putmarkers!(r, side)
  end

  moves!(r, Nord, num_sud)
  moves!(r, Ost, num_west)
end

r = Robot("temp.sit", animate = true)
mark_frame_perimetr!(r)