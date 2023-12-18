using HorizonSideRobots

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

function along!(robot, direct, num_steps)::Nothing
  for _ in 1:num_steps
    move!(robot, direct)
  end
end

function move_to_back!(robot, back_path)
  for next in back_path
    along!(robot, next.side, next.num_steps)
  end
end

function numsteps_along!(robot, direct)::Int
  num_steps = 0
  while !isborder(robot, direct)
    move!(robot, direct)
    num_steps += 1
  end
  return num_steps
end

function move_to_angle!(robot, angle=(Sud,West))
  back_path = NamedTuple{(:side, :num_steps), Tuple{HorizonSide, Int}}[]
  while !isborder(robot,angle[1]) || !isborder(robot, angle[2])
    push!(back_path, (side = inverse(angle[1]),
    num_steps = numsteps_along!(robot, angle[1])))
    push!(back_path, (side = inverse(angle[2]),
    num_steps = numsteps_along!(robot, angle[2])))
  end
  return back_path
end

function move_to_start!(robot)
  while !isborder(robot, West) || !isborder(robot, Sud)
    if !isborder(robot, West) 
      move!(robot, West)
    else
      move!(robot, Sud)
    end
  end
end

function num_horizontal_borders!(robot)
  back_path = move_to_angle!(robot)
  side = Ost
  num_borders = num_horizontal_borders!(robot, side)
  while !isborder(robot, Nord)
    move!(robot, Nord)
    side = inverse(side)
    num_borders += num_horizontal_borders!(robot,side)
  end
  move_to_start!(robot)
  move_to_back!(robot, back_path)
  return num_borders
end

function num_horizontal_borders!(robot, side)
  num_borders = 0
  state = 0
  space = 0
  while !isborder(robot, side)
    move!(robot, side)
    if state == 0
      if isborder(robot, Nord)
        if space == 1
          num_borders -= 1
          space = 0
        end
        state = 1
      end
    else
      if !isborder(robot, Nord)
        state = 0
        space += 1
        num_borders += 1
      end
    end
  end
  return num_borders
end

r = Robot("11.sit", animate = true)
print(num_horizontal_borders!(r))