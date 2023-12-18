using HorizonSideRobots

moves!(r, side::HorizonSide, num_steps) = for _ in 1:num_steps move!(r,side) end

function through_rectangles_into_angle(r,angle::NTuple{2,HorizonSide})
    num_steps=[]
    while !isborder(r,angle[1]) || !isborder(r,angle[2])
        push!(num_steps, moves!(r, angle[2]))
        push!(num_steps, moves!(r, angle[1]))
    end
    return num_steps
end

function moves!(r::Robot, sides::Tuple{HorizonSide, HorizonSide}, num_steps::Vector{Any})
    for (i,n) in enumerate(reverse!(num_steps))
        moves!(r, sides[mod(i-1, length(sides))+1], n) 
    end
end

function mark_angles(r)
    num_steps = through_rectangles_into_angle(r,(Sud,West))
    for side in (Nord,Ost,Sud,West)
        moves_wm!(r,side)
    end
    moves!(r,(Ost,Nord),num_steps)
end

function moves_wm!(r,side)
    num_steps=0
    while isborder(r,side)==false
        move!(r,side)
        putmarker!(r)
        num_steps+=1
    end
    return num_steps
end

function moves!(r,side)
    num_steps=0
    while isborder(r,side)==false
        move!(r,side)
        num_steps+=1
    end
    return num_steps
end

r = Robot("5.sit", animate = true)
mark_angles(r)