abstract type AbstractRobot end

mutable struct CountmarkersRobot <: AbstractRobot
    robot::Robot
    num_markers::Int64
end
 
get_base_robot(robot::CountmarkersRobot) = robot.robot

HSR.move!(robot::AbstractRobot, side) = move!(get_base_robot(robot), side)
HSR.isborder(robot::AbstractRobot, side) = isborder(get_base_robot(robot), side)
HSR.putmarker!(robot::AbstractRobot) = putmarker!(get_base_robot(robot))
HSR.ismarker(robot::AbstractRobot) = ismarker(get_base_robot(robot))
HSR.temperature(robot::AbstractRobot) = temperature(get_base_robot(robot))

function HSR.move!(robot::CountmarkersRobot, side) 
    move!(robot.robot, side)
    if ismarker(robot)
        robot.num_markers += 1
    end
end

mutable struct Coordinates
    x::Int
    y::Int
end

struct ChessRobotN <: AbstractRobot
    robot::Robot
    coordinates::Coordinates
    N::Int
    ChessRobotN(r,n) = new(r, Coordinates(0,0), N)
end

function HSR.move!(coord::Coordinates, side::HorizonSide)
    if side == Ost coord.x += 1
    elseif side == West coord.x -= 1
    elseif side == Nord coord.y += 1
    else coord.y -=  1
    end
end

get(coord::Coordinates) = (coord.x, coord.y)
get_base_robot(robot::ChessRobotN) = robot.robot

function HSR.move!(robot::ChessRobotN, side)
    move!(robot.robot, side)
    move!(robot.coordinates, side)
    x, y = get(robot.coordinates) .÷ N
    if ((abs(x) % 2) == 0 && (abs(y) % 2) == 0) || ((abs(x) % 2) == 1 && (abs(y) % 2) == 1)
        putmarker!(robot)
    end
end

N = 1
robot = ChessRobotN(Robot(animate=true, "30.sit"), N)
map = []
function mark_labirint!(robot::ChessRobotN) 
    x, y = get(robot.coordinates)
    flag = (x, y) in map
    if !flag
        push!(map, (x,y))
        for side in (Nord, West, Sud, Ost)
            if !isborder(robot, side) && !isborder(robot.coordinates, side, map)
                move!(robot, side)
                mark_labirint!(robot)
                move!(robot, inverse(side))
            end
        end
    end
end

function HSR.isborder(coord::Coordinates, side::HorizonSide, map)
    cx, cy = coord.x, coord.y
    if side == Ost cx += 1
    elseif side == West cx -= 1
    elseif side == Nord cy += 1
    else cy -=  1
    end
    return ((cx,  cy) in map)
end
mark_labirint!(robot)
