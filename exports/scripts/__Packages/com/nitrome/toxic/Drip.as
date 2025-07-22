class com.nitrome.toxic.Drip extends MovieClip
{
   var anim;
   var clip;
   var game;
   var start_x;
   var start_y;
   var bottom_boundary;
   var falling = false;
   var y_speed = 5;
   var finish_drip = false;
   function Drip()
   {
      super();
   }
   function doPause()
   {
      this.anim.stop();
      this.clip.stop();
   }
   function doUnpause()
   {
      this.anim.play();
      this.clip.play();
   }
   function init(game, type)
   {
      this.game = game;
      if(type == 1)
      {
         this._x += 8;
         this._y += 49;
      }
      else if(type == 2)
      {
         this._x += 16;
         this._y += 44;
      }
      else if(type == 3)
      {
         this._x += 21;
         this._y += 45;
      }
      this.start_x = this._x;
      this.start_y = this._y;
   }
   function main()
   {
      if(this.getOnScreen() == true)
      {
         this._visible = true;
      }
      else
      {
         this._visible = false;
      }
      if(this.falling == true)
      {
         this._y += this.checkFloor(this.y_speed);
         if(this.getOnGround(this._x,this._y + this.bottom_boundary._y) == true)
         {
            this.startSplash();
         }
      }
   }
   function getOnScreen()
   {
      if(this.hitTest(_root.screen_test) == true)
      {
         return true;
      }
      return false;
   }
   function doExplode()
   {
      if(_root.game.explosion_holder.hitTest(this.start_x,this.start_y,true))
      {
         this.finish_drip = true;
      }
      else
      {
         this.game.checkRobotList(this._name);
      }
   }
   function startFall()
   {
      this.gotoAndStop("fall");
      this.falling = true;
   }
   function startSplash()
   {
      this.gotoAndStop("splash");
      this.falling = false;
   }
   function finishSplash()
   {
      if(this.finish_drip == true)
      {
         this.removeMovieClip();
      }
      else
      {
         this._x = this.start_x;
         this._y = this.start_y;
         this.gotoAndStop("drip");
      }
   }
   function getOnGround(x, y)
   {
      if(this.game.getSceneryCollision(x,y) == true)
      {
         if(this.game.getSceneryCollision(x,y - 1) == false)
         {
            return true;
         }
         return false;
      }
      return false;
   }
   function checkFloor(v)
   {
      v = Math.round(v);
      var _loc2_ = 1;
      while(_loc2_ <= v)
      {
         if(this.getInWall(this._x,this._y + this.bottom_boundary._y + _loc2_) == true)
         {
            return _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
      return v;
   }
   function getInWall(x, y)
   {
      if(this.game.getSceneryCollision(x,y) == true)
      {
         return true;
      }
      return false;
   }
}
