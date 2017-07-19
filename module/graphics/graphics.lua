function love.graphics.rectangle_c(mode,x,y,width,height)
    love.graphics.rectangle(mode,x-width/2,y-height/2,width,height)
end
function love.graphics.rectangle_d(mode,x,y,width,height,deg)
    love.graphics.polygon(mode, x + width*math.cos(deg + math.pi/4), y - height*math.sin(deg+ math.pi/4), x + width*math.cos(deg+ math.pi*3/4), y - height*math.sin(deg+ math.pi*3/4), x + width*math.cos(deg+ math.pi*5/4), y - height*math.sin(deg+ math.pi*5/4), x + width*math.cos(deg+ math.pi*7/4), y - height*math.sin(deg+ math.pi*7/4))
end

--始点が左上
function love.graphics.quarter(_mode,_x,_y,_width,_height,_depth,_z)
    local x,y,z,width,height,depth
    x = _x
    y = _y
    z = _z or 0

    local angle = math.pi/6

    depth = _depth
    height = _height
    width = _width

    local c_r, c_g, c_b, c_a = love.graphics.getColor()

    local a = {x,y - z}
    local b = {x + width * math.cos(angle), y - width * math.sin(angle) - z}
    local c = {x + width * math.cos(angle) + height * math.cos(angle),y- width * math.sin(angle) + height * math.sin(angle) - z}
    local d = {x + height * math.cos(angle),y + height * math.sin(angle) - z}

    g.setColor(c_r*4/4,c_g*4/4,c_b*4/4,c_a)
    love.graphics.polygon(_mode,a[1],a[2],b[1],b[2],c[1],c[2],d[1],d[2])
    g.setColor(c_r*1.5/4,c_g*2/4,c_b*1.0/4,c_a)
    love.graphics.polygon(_mode,a[1],a[2],d[1],d[2],d[1],d[2] + depth,a[1],a[2] + depth)
    g.setColor(c_r*1.0/4,c_g*1.5/4,c_b*1.75/4,c_a)
    love.graphics.polygon(_mode,c[1],c[2],d[1],d[2],d[1],d[2] + depth,c[1],c[2] + depth)

    g.setColor(c_r,c_g,c_b,c_a)

end
--始点位置がクォータービュー的
function love.graphics.w_quarter(_mode,_x,_y,_width,_height,_depth,_z)
    local angle = math.pi/6
    love.graphics.quarter(_mode,_x - _width * math.cos(angle),_y + _width *  math.sin(angle),_width,_height,_depth,_z)
end
--クォーターワールド限定
function love.graphics.wq_quarter(_mode,_x,_y,i,j,width_per,height_per,_width,_height,_depth,_z)
    local angle = math.pi/6
    love.graphics.w_quarter(_mode,_x - i*width_per*math.cos(angle) + j*height_per*math.cos(angle),_y + (i-1)*width_per*math.sin(angle) + (j-1)*height_per*math.sin(angle),_width,_height,_depth,_z)
end

function love.graphics.print_c(text,x,y,r,sx,sy,ox,oy,kx,ky)
    local font = love.graphics.getFont()
    local width =font:getWidth(text)
    local height =font:getHeight(text)
    local sx = sx or 1
    local sy = sy or 1
    love.graphics.print(text,x-width/2*sx,y-height/2*sy,r,sx,sy,ox,oy,kx,ky)
end

---指定範囲をカットしてdraw
function love.graphics.cut(_x,_y,_w,_h,f)
  local x,y,w,h = love.graphics.getScissor()
    love.graphics.intersectScissor(x + (_x)*camWindowScale,y + (_y)*camWindowScale, _w*camWindowScale, _h*camWindowScale )
    f()
  love.graphics.setScissor(x,y,w,h)
end
