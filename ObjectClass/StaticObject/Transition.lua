--[[
  トランジションの親クラス
  アニメーションにはself.tw.frame (0~1)を用いる
]]
Transition = {
    c_transition = nil;
    new = function(room,time1,time2,type1,type2)
        local obj = instance(Transition,StaticObject)
        obj.name = "基本遷移オブジェクト"
        obj.toRoom = room
        obj.status = Enum:new{"IN","OUT"};
        obj.status_now = obj.status.IN

        --tween用
        obj.time1 = time1 or 1
        obj.time2 = time2 or 1
        obj.type1 = type1 or tween.easing.outBounce
        obj.type2 = type2 or tween.easing.outBounce
        obj.tw = {frame = 0}
        obj.tween = tween.new(obj.time1,obj.tw, {frame = 1}, obj.type1)
        return obj
    end;
    update = function(self,dt)
        --現在稼働中
        --すでに他が遷移中ならkill　そうでないなら登録
        if Transition.c_transition == nil or Transition.c_transition == self then
          --継続
          Transition.c_transition = self
        else
          self.kill = true
          debugger:print("すでにシーンの遷移中です。次フレームでこのトランジションを削除します")
        end

        local switch={}
        switch[self.status.IN]=function()
          local finish = self.tween:update(dt)
          if finish then
            SceneManager.changeScene(self.toRoom)
            self.status_now = self.status.OUT
            self.tween = tween.new(self.time2,self.tw, {frame = 0}, self.type2)
          end
        end
        switch[self.status.OUT]=function()
          local finish = self.tween:update(dt)
          if finish then
            self.kill = true
            Transition.c_transition = nil
          end
        end
        switch[self.status_now]()
    end;
    drawGUI = function(self)
      local switch={}
      switch[self.status.IN]=function()
        self:drawIN()
      end
      switch[self.status.OUT]=function()
        self:drawOUT();
      end
      switch[self.status_now]()
      g.setColor(255,255,255)
    end;
    transition = function(room,class)
        if class == nil then addS(Transition.new(room))
        else addS(class.new(room)) end
    end;

    -------上書き----------
    drawIN = function(self)
      local t = self.tw.frame
      g.setColor(16,16,32,t*255)
      love.graphics.rectangle("fill", g_x+W/2*(1-t), g_y+H/2*(1-t),W*t,H*t)
    end;

    drawOUT = function(self)
      local t = self.tw.frame
      g.setColor(16,16,32,t*255)
      love.graphics.rectangle("fill", g_x+W/2*(1-t), g_y+H/2*(1-t),W*t,H*t)
    end;
}

--適当なトランジション
T_normal = {
  new = function(room)
    local obj = instance(T_normal,Transition,room,1,1,nil,nil)
    return obj
  end;
  drawIN = function(self)
    local t = self.tw.frame
    g.setColor(16,16,t*255,t*255)
    love.graphics.rectangle("fill", g_x+W/2*(1-t), g_y+H/2*(1-t),W*t,H*t)
  end;
  drawOUT = function(self)
    local t = self.tw.frame
    g.setColor(16,16,t*255,t*255)
    love.graphics.rectangle("fill", g_x+W/2*(1-t), g_y+H/2*(1-t),W*t,H*t)
  end;
};