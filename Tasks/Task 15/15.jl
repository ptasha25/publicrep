using HorizonSideRobots

function left(sides::NTuple{2, HorizonSide})
  return left(sides[1]), left(sides[2])
end

left(side::HorizonSide) = HorizonSide(mod(Int(side)+3, 4))


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

function move_if_possible!(r::Robot, direct_sides::NTuple{2, HorizonSide})::Bool
  if !isborder(r, direct_sides)
    move!(r, direct_sides)
    return true
  end
  orthogonal_sides = left(direct_sides[1])
  reverse_sides = inverse(orthogonal_sides)
  num_steps=0
  flag = false
  if !isborder(r, direct_sides[1])
    move!(r, direct_sides[1])
    flag = true
  end
  while isborder(r, direct_sides[1]) == true
    if isborder(r, orthogonal_sides) == false
      move!(r, orthogonal_sides)
      num_steps += 1
    else
      break
    end
  end
  if isborder(r,direct_sides[1]) == false
    move!(r, direct_sides[1])
    while isborder(r, reverse_sides) == true
      move!(r,direct_sides[1])
      num_steps += 1
    end
    result = true
  else
    result = false
  end
  if result == false
    movements!(r,reverse_sides, num_steps)
  else
    if flag == true
      num_steps += 1
      move!(r, reverse_sides)
      while num_steps > 0 && isborder(r, inverse(direct_sides[1]))
        move!(r, reverse_sides)
        num_steps -= 1
      end
      while num_steps > 0 && !isborder(r, inverse(direct_sides[1]))
        move!(r, inverse(direct_sides[1]))
        num_steps -= 1
      end
    else
      move!(r, reverse_sides)
      while num_steps > 0 && isborder(r, inverse(direct_sides[1]))
        move!(r, reverse_sides)
        num_steps -= 1
      end
      while num_steps > 0 && !isborder(r, inverse(direct_sides[1]))
        move!(r, inverse(direct_sides[1]))
        num_steps -= 1
      end
    end
  end
  if flag == true && result == false
    move!(r, inverse(direct_sides[1]))
  end
  return result
end

function movements!(r::Robot, side::HorizonSide, num_steps::Int)
  for _ in 1:num_steps
    move!(r,side)
  end
end

function movements!(r::Robot, sides::NTuple{2, HorizonSide}, num_steps::Int)
  for _ in 1:num_steps
    move_if_possible!(r,sides)
  end
end

function mark_kross(r)
  for sides in ((Ost, Nord), (West, Nord), (West, Sud), (Ost, Sud))
    num_steps = putmarkers!(r, sides)
    movements!(r,inverse(sides), num_steps)
  end
end

function putmarkers!(r::Robot,sides::NTuple{2, HorizonSide})
  num_steps=0 
  while move_if_possible!(r, sides) == true
      putmarker!(r)
      num_steps += 1
  end 
  return num_steps
end

function inverse(sides::NTuple{2, HorizonSide})
  return inverse(sides[1]), inverse(sides[2])
end

function inverse(Side)::HorizonSide
  return HorizonSide((Int(Side)+2)%4)
end

function main(r)
  putmarker!(r)
  mark_kross(r)
end

r = Robot("15.sit", animate = true)
main(r)