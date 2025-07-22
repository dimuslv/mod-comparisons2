class ClockDisp
{
   var m_text;
   var m_freeze;
   var m_pause;
   var m_frames;
   var m_prefix;
   static var instanceCount = 0;
   static var instances = new Array();
   static var instanceDriver = null;
   static var m_frameRate = 30;
   function ClockDisp(register, x, y)
   {
      ClockDisp.instances[register] = this;
      this.m_text = ClockDisp.instanceDriver.createTextField("CDTimer" + register,register,x,y,160,25);
      ClockDisp.instanceCount++;
      this.m_freeze = 0;
      this.m_pause = false;
      this.m_frames = 0;
      this.m_prefix = "Time: ";
      this.setTextFormat(18,"Consolas");
      this.m_text.background = true;
   }
   static function initDriver(newMovieClip)
   {
      ClockDisp.instanceDriver = newMovieClip;
   }
   static function enterFrame()
   {
      var i = 0;
      while(i < ClockDisp.instanceCount)
      {
         ClockDisp(ClockDisp.instances[i]).update();
         i++;
      }
   }
   static function destroyAll()
   {
      ClockDisp.instanceCount = 0;
      ClockDisp.instances = new Array();
      ClockDisp.instanceDriver = null;
   }
   function update()
   {
      if(!this.m_pause)
      {
         ++this.m_frames;
      }
      if(this.m_freeze == 0)
      {
         this.m_text.text = this.m_prefix.concat(this.cvt(this.m_frames));
      }
      else
      {
         --this.m_freeze;
      }
   }
   function setTextFormat(size, font)
   {
      var _loc4_ = new TextFormat();
      _loc4_.size = size;
      _loc4_.font = font;
      this.m_text.setNewTextFormat(_loc4_);
      return this;
   }
   function setPosition(x, y)
   {
      this.m_text.x = x;
      this.m_text.y = y;
      return this;
   }
   function satShow(show)
   {
      this.m_text.visible = show;
      return this;
   }
   function setPause(pause)
   {
      this.m_pause = pause;
      return this;
   }
   function setFreeze(frames)
   {
      this.m_freeze = frames;
      return this;
   }
   function setFrames(i)
   {
      this.m_frames = i;
      return this;
   }
   function setTextPrefix(t)
   {
      this.m_prefix = t;
      return this;
   }
   function cvt(f)
   {
      if(f <= 0)
      {
         return "00:00.000";
      }
      var _loc2_ = "";
      _loc2_ += f / (60 * ClockDisp.m_frameRate) < 10 ? "0" : "";
      _loc2_ += int(f / (60 * ClockDisp.m_frameRate));
      _loc2_ += ":";
      f %= 60 * ClockDisp.m_frameRate;
      _loc2_ += f / ClockDisp.m_frameRate < 10 ? "0" : "";
      _loc2_ += int(f / ClockDisp.m_frameRate);
      _loc2_ += ".";
      f %= ClockDisp.m_frameRate;
      f *= 1000;
      f /= ClockDisp.m_frameRate;
      _loc2_ += f < 100 ? "0" : "";
      _loc2_ += f < 10 ? "0" : "";
      return _loc2_ + int(f);
   }
}
