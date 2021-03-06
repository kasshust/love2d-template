--NPCのテスト
TouchWindow = {
  new = function(text,x,y)
    local obj = instance(TouchWindow,Object,x,y)
    obj.text = text or "うんこ"
    obj.pos = Vector.new(x,y)
    obj.solid = HC.rectangle(obj.pos.x,obj.pos.y,16,16)
    obj.object = nil
    return obj
  end;

  step = function(self,dt)
    if controller.wasPressed("down") then
      self:collideWith("player",self.solid,function(other,delta)
          self.object = TextWindow.new(nil,self.text,W/2,H/2,W-20,70,10)
      end)
    end
    if self.object ~= nil then
      self.object:update(dt)
      if self.object.kill == true then self.object = nil end
    end
  end;

  draw = function(self)
    self.solid:draw("fill")
  end;
  drawGUI = function(self)
    if self.object ~= nil then self.object:drawGUI() end
  end
};
--ゲーム内のEventのテスト
TouchEvent = {
  new = function(text,x,y)
    local obj = instance(TouchEvent,Object,x,y)
    obj.pos = Vector.new(x,y)
    obj.solid = HC.rectangle(obj.pos.x,obj.pos.y,16,16)
    return obj
  end;

  step = function(self,dt)
    --if controller.wasPressed("down") then
      self:collideWith("player",self.solid,function(other,delta)
          g_eventmanager:add(CustomEvent.new(function(obj) obj.init = function(obj) other.operation = false obj.kill = true end end))
          g_eventmanager:add(CustomEvent.new(function(obj) obj.init = function(obj) other.operation = true obj.kill = true end end))
          self.kill = true
      end)
    --end
  end;
  draw = function(self)
    self.solid:draw("fill")
  end;
};
--ドアのテスト
TouchDoor = {
  new = function(x,y,room,num)
    local obj = instance(TouchDoor,Object,x,y)
    obj.pos = Vector.new(x,y)
    obj.solid = HC.rectangle(obj.pos.x,obj.pos.y,16,16)
    obj.room = room
    obj.num = num
    return obj
  end;
  step = function(self)
    if controller.wasPressed("down") then
      self:collideWith("player",self.solid,function(other,delta)
        g_manager.game.player.num = self.num
        trans(T_normal,BankaRoom,BankaMap[self.room])
      end)
    end
  end;

  draw = function(self)
    self.solid:draw("fill")
  end;
}

--effectのテスト
testEffect = {
    new = function(x,y)
      local obj = instance(testEffect,Object,x,y)
      obj.tw = {w = 16,h = 16,color = 230}
      obj.queue = Queue.new()
      obj.queue:enqueue(tween.new(1/5, obj.tw, {w = 0,h = 0,color = 230}, tween.easing.outBounce))
      obj.x = x or 0
      obj.y = y or 0
      return obj
    end;
    update = function(self,dt)
      local finish = self.queue:top():update(dt)
      if finish then
        self.queue:dequeue()
      end
      if self.queue:isEmpty() then
        self.kill = true
      end
    end;
    draw = function(self)
      g.setColor(self.tw.color,math.random(230,255),self.tw.color)
      g.setColor(255,255,self.tw.color)
      g.setColor(math.random(230,255),self.tw.color,math.random(230,255))
      love.graphics.ellipse("fill", self.x, self.y, self.tw.w, self.tw.h)
      g.setColor(255,255,255)
    end;
}

Wheel = {
   new = function(x,y,r)
     local obj = instance(Wheel,Object,x,y)
     obj.name = "wheel"
     obj.pos = Vector.new(x,y)
     --obj.animator = Animator.new(spr_test,16,16,1,1)
     obj.frame = 0
     obj.p_angle = 0
     obj.angle = 0
     obj.vangle = 0
     obj.aangle = 0
     obj.child = {}
     --obj.p = p
     obj.r = r
     obj.l = 2 * r * math.pi
     return obj
   end;
   step = function(self)
     self:rotate(60*2*math.pi/360)
   end;
   draw = function(self)
     self.animator:draw(self.pos.x,self.pos.y,-(self.angle + self.p_angle),1*self.r/8,1*self.r/8,8,8)
   end;
   add = function(self)
   end;
   rotate = function(self,add)
     self.angle = self.angle + add
   end
 }

Plate = {
   new = function(x,y,r)
     local obj = instance(Plate,Object,x,y,r)
     obj.pos = Vector.new(x,y)
     --obj.animator = Animator.new(spr_test,16,16)
     obj.frame = 0
     obj.p_angle = 0
     obj.angle = 0
     obj.vangle = 0
     obj.aangle = 0
     obj.child = {}
     obj.p = p
     obj.r = r
     obj.l = 2 * r * math.pi
     return obj
   end;
   step = function(self,dt)
     for i,v in ipairs(self.child) do
       v.obj.pos = Vector.new(self.pos.x + v.r*math.cos(v.angle+self.angle+self.p_angle),self.pos.y - v.r*math.sin(v.angle+self.angle+self.p_angle))
       v.obj.p_angle = self.angle + self.p_angle
     end
   end;
   draw = function(self)
    g.circle("line",self.pos.x,self.pos.y,self.r)
    g.line(self.pos.x,self.pos.y,self.pos.x + self.r * math.cos(self.angle + self.p_angle),self.pos.y - self.r * math.sin(self.angle + self.p_angle))
   end;
   add = function(self,obj,r,angle)
     local t = {}
     t.r = r
     t.angle = angle
     t.obj = obj
     table.insert(self.child,t)
   end;
   rotate = function(self,add)
     self.angle = self.angle + add
   end
 }

Obj_unko = {
   new = function(x,y)
     local obj = instance(Obj_unko,Object,x,y)
     obj.name = "Obj_unko"
     obj.plate = Plate.new(maid64.mouse.getX() + g_x,maid64.mouse.getY() + g_y,48)
     obj.plate2 = Plate.new(maid64.mouse.getX() + g_x,maid64.mouse.getY() + g_y,32)
     obj.plate2:add(Wheel.new(0,0,8),32,0*2*math.pi/360)
     obj.plate:add(Wheel.new(0,0,8),48,90*2*math.pi/360)
     obj.plate:add(Wheel.new(0,0,8),48,180*2*math.pi/360)
     obj.plate:add(obj.plate2,48,30*2*math.pi/360)
     obj.va = 0
     obj.va2 = 0
   end;
   step = function(self)
     local ac = math.random(-1,1)
     local ac2 = math.random(-1,1)


     self.va = self.va + ac
     self.va2 = self.va2 + ac2
     self.va = self.va * 0.98
     self.va2 = self.va2 * 0.98
     self.plate2:rotate(self.va/360*2*math.pi)
     self.plate:rotate(-self.va2/360*2*math.pi)
   end;
}


Smoke = {
    new = function(x,y)
      local obj = instance(Smoke,Object,x,y)
      obj.name = "Smoke"
      --obj.animator = Animator.new(sprite.test2,16,16,2+16*0,9+16*0,math.random(10,30))
      obj.vpos = Vector.new(math.random(-6,6),math.random(-6,6))
      obj.depth = -10000
      return obj
    end;
    step = function(self,dt)
      --self.animator:update(dt)
      self.vpos = self.vpos * 0.90
      self.pos = self.pos + self.vpos
      --if self.animator:isfinish() then  self.kill = true end
      self.kill = true
    end;
    draw = function(self)
      --self.animator:draw(self.pos.x,self.pos.y,0,1,1,8,8)
    end;
}

TestShot = {
   new = function(x,y,vsp,hsp)
     local obj = instance(TestShot,Object,x,y)
     obj.name = "TestShot"
     obj.tag = {"shot"}
     obj.vpos = Vector.new(vsp or 0,hsp or 0)
     obj.solid = HC.rectangle(x,y,6,4)
     obj.solid.other = obj
     obj.frame = 0
     return obj
   end;
   step = function(self,dt)
     self.pos = self.pos + self.vpos
     self.vpos = self.vpos * 0.99
     self.frame = self.frame + 1

     self.solid:moveTo(self.pos.x,self.pos.y)

     if self.frame > 10 then self.kill = true testEffect.new(self.pos.x,self.pos.y) end

     self:collideWith("top_collision",self.solid,function(other,delta)
       self.pos = self.pos + delta
       testEffect.new(self.pos.x,self.pos.y)
       self.kill = true
       g_soundmanager:play(ADDRESS.se .. "se_hit.wav")
     end)
   end;
   collision = function(self)
   end;
   draw = function(self)
     local xscale,yscale = math.abs(self.vpos.x/2) + 3 , math.abs(self.vpos.y/2) + 3
     g.setColor(ASE.DARKGRAY)
     g.ellipse("fill",self.pos.x - self.vpos.x,self.pos.y - self.vpos.y,xscale,yscale)
     g.setColor(ASE.LIGHTCYAN)
     g.ellipse("fill",self.pos.x - self.vpos.x/2,self.pos.y - self.vpos.y/2,xscale,yscale)
     g.setColor(ASE.WHITE)
     g.ellipse("fill",self.pos.x,self.pos.y,xscale,yscale)
   end;
 }

 Laser = {
    new = function(x,y)
      local obj = instance(Laser,MoveBlock,x,y,32,8,16,0)
      obj.name = "Laser"
      return obj
    end;
    step = function(self,dt)
      MoveBlock.step(self)
    end;
    draw = function(self)
      self.solid:draw()
      g.points(self.pos.x,self.pos.y)
    end;
  }
