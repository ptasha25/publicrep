using HorizonSideRobots

function InPoint(robot, step_sud, step_west)
  while !isborder(robot, Sud)
    move!(robot, Sud)
    step_sud += 1
  end
  while !isborder(robot, West)
    move!(robot, West)
    step_west += 1
  end
  return step_sud, step_west
end

function InPoint(robot)
  while !isborder(robot, Sud)
    move!(robot, Sud)
  end
  while !isborder(robot, West)
    move!(robot, West)
  end
end

function moves!(robot::Robot, side::HorizonSide, num::Int)
  for _ in 1:num
    move!(robot, side)
  end
end

function to_start(robot, step_sud, step_west)
  moves!(robot, Nord, step_sud)
  moves!(robot, Ost, step_west)
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

module NNChessMarker
    using HorizonSideRobots
    import Main.inverse

    export mark_chess

    X_COORDINATE=0
    Y_COORDINATE=0

    CELL_SIZE = 0

    function mark_chess(r::Robot,n::Int)
      global CELL_SIZE
      CELL_SIZE = n

      side=Ost
      mark_row(r,side)
      while !isborder(r,Nord)
        move_decart!(r,Nord)
        side = inverse(side)
        mark_row(r,side)
      end
    end

    function mark_row(r::Robot, side::HorizonSide)       
      putmarker_chess!(r)
      while !isborder(r,side)
        move_decart!(r,side)
        putmarker_chess!(r)
      end
    end

    function putmarker_chess!(r)
      if (mod(X_COORDINATE, 2*CELL_SIZE) in 0:CELL_SIZE-1) && (mod(Y_COORDINATE, 2*CELL_SIZE) in 0:CELL_SIZE-1) 
        putmarker!(r)
      end
      if !(mod(X_COORDINATE, 2*CELL_SIZE) in 0:CELL_SIZE-1) && !(mod(Y_COORDINATE, 2*CELL_SIZE) in 0:CELL_SIZE-1) 
        putmarker!(r)
      end
    end

    function move_decart!(r,side)
        global X_COORDINATE, Y_COORDINATE
        if side==Nord
            Y_COORDINATE+=1
        elseif side==Sud
            Y_COORDINATE-=1
        elseif side==Ost
            X_COORDINATE+=1
        else
            X_COORDINATE-=1
        end
        move!(r,side)
    end

end

r = Robot("4.sit", animate = true)
step_sud = 0
step_west = 0
step_sud, step_west = InPoint(r, step_sud, step_west)
NNChessMarker.mark_chess(r, 4)
InPoint(r)
to_start(r, step_sud, step_west)