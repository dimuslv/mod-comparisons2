class com.nitrome.toxic.WheelRobot extends MovieClip
{
   var anim;
   var dir;
   var game;
   var state;
   var fall_anim_count;
   var prev_dir;
   var prev_state;
   var wall_boundary_right;
   var wall_boundary_left;
   var vx = 0;
   var vy = 0;
   var max_vx = 2;
   var max_vy = 6;
   var fall_vy = 0;
   var max_slope = 16;
   var debris_right = new Array({id:61,x:-5,y:-43},{id:62,x:15,y:-32},{id:63,x:8,y:-14},{id:64,x:-15,y:-23});
   var debris_left = new Array({id:57,x:5,y:-43},{id:58,x:-14,y:-32},{id:59,x:-7,y:-14},{id:60,x:15,y:-22});
   var done_splash = false;
   function WheelRobot()
   {
      super();
   }
   function doPause()
   {
      this.anim.stop();
   }
   function doUnpause()
   {
      this.anim.play();
   }
   function init(dir, game)
   {
      this.dir = dir;
      this.game = game;
      this.state = com.nitrome.toxic.Global.WALK;
      this.updateAnim();
      if(dir == com.nitrome.toxic.Global.LEFT)
      {
         this.vx = - this.max_vx;
      }
      else if(dir == com.nitrome.toxic.Global.RIGHT)
      {
         this.vx = this.max_vx;
      }
      this.vy = 0;
      this.adjustToFloor();
   }
   function getOnScreen()
   {
      if(this.hitTest(_root.screen_test) == true)
      {
         return true;
      }
      return false;
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
      this.updateAnim();
      if(this.state == com.nitrome.toxic.Global.WALK)
      {
         this.doWalk();
      }
      else if(this.state == com.nitrome.toxic.Global.FALL)
      {
         this.doFall();
         this.checkFallOff();
      }
   }
   function doExplode()
   {
      this.game.createExplosion(this._x,this._y,this._name,100);
      if(this.dir == com.nitrome.toxic.Global.LEFT)
      {
         this.game.createDebris(this._x,this._y,this.debris_left);
      }
      else if(this.dir == com.nitrome.toxic.Global.RIGHT)
      {
         this.game.createDebris(this._x,this._y,this.debris_right);
      }
      this.removeMovieClip();
   }
   function doWalk()
   {
      if(this.getOnGround(this._x,this._y) == false)
      {
         this.fall_anim_count = 0;
         this.vy = this.fall_vy;
         this.state = com.nitrome.toxic.Global.FALL;
         return undefined;
      }
      this._x += this.checkWalls(this.vx);
      this.adjustToFloor();
   }
   function doFall()
   {
      this.vy = this.vy + 1;
      if(this.vy > this.max_vy)
      {
         this.vy = this.max_vy;
      }
      this._y += this.checkFloor(this.vy);
      if(this.getOnGround(this._x,this._y) == true)
      {
         this.state = com.nitrome.toxic.Global.WALK;
      }
   }
   function adjustToFloor()
   {
      var _loc3_;
      var _loc2_;
      if(this.getInGround(this._x,this._y) == true)
      {
         if(this.vy >= 0)
         {
            _loc3_ = false;
            _loc2_ = 1;
            while(_loc2_ <= this.max_slope)
            {
               if(this.getOnGround(this._x,this._y - _loc2_) == true)
               {
                  this._y -= _loc2_;
                  _loc3_ = true;
                  break;
               }
               _loc2_ = _loc2_ + 1;
            }
         }
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
   function getInGround(x, y)
   {
      if(this.game.getSceneryCollision(x,y) == true)
      {
         if(this.game.getSceneryCollision(x,y - 1) == true)
         {
            return true;
         }
         return false;
      }
      return false;
   }
   function getInWall(x, y)
   {
      if(this.game.getSceneryCollision(x,y) == true)
      {
         return true;
      }
      return false;
   }
   function getOverEdge(x, y)
   {
      var _loc2_ = 1;
      while(_loc2_ <= 32)
      {
         if(this.game.getSceneryCollision(x,y + _loc2_) == true)
         {
            return false;
         }
         _loc2_ = _loc2_ + 1;
      }
      return true;
   }
   function updateAnim()
   {
      if(this.state == com.nitrome.toxic.Global.FALL)
      {
         if(this.dir != this.prev_dir || this.state != this.prev_state)
         {
            this.fall_anim_count = this.fall_anim_count + 1;
            if(this.fall_anim_count >= 3)
            {
               this.gotoAndStop(com.nitrome.toxic.Global.state_string[this.state] + com.nitrome.toxic.Global.dir_string[this.dir]);
               this.prev_dir = this.dir;
               this.prev_state = this.state;
            }
         }
      }
      else
      {
         if(this.dir != this.prev_dir || this.state != this.prev_state)
         {
            this.gotoAndStop(com.nitrome.toxic.Global.state_string[this.state] + com.nitrome.toxic.Global.dir_string[this.dir]);
         }
         this.prev_dir = this.dir;
         this.prev_state = this.state;
      }
   }
   function checkWalls(v)
   {
      var _loc3_ = new Array(-10,-15);
      var _loc7_;
      var _loc5_;
      var _loc6_;
      var _loc4_;
      if(v > 0)
      {
         _loc7_ = this.wall_boundary_right._x;
         if(this.getInWall(this._x + _loc7_ + v,this._y + _loc3_[0]) == true || this.getInWall(this._x + _loc7_ + v,this._y + _loc3_[1]) == true)
         {
            _loc5_ = 1;
            while(_loc5_ <= this.max_vx)
            {
               _loc6_ = 0;
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  if(this.getInWall(this._x + _loc7_ + v - _loc5_,this._y + _loc3_[_loc4_]) == false)
                  {
                     _loc6_ = _loc6_ + 1;
                  }
                  _loc4_ = _loc4_ + 1;
               }
               if(_loc6_ == _loc3_.length)
               {
                  this.changeDirection();
                  return v - _loc5_;
               }
               _loc5_ = _loc5_ + 1;
            }
         }
         else
         {
            if(this.getOverEdge(this._x + _loc7_ + v,this._y) != true)
            {
               return v;
            }
            _loc5_ = 1;
            while(_loc5_ <= this.max_vx)
            {
               if(this.getOverEdge(this._x + _loc7_ + v - _loc5_,this._y) == false)
               {
                  this.changeDirection();
                  return v - _loc5_;
               }
               _loc5_ = _loc5_ + 1;
            }
         }
      }
      else if(v < 0)
      {
         _loc7_ = this.wall_boundary_left._x;
         if(this.getInWall(this._x + _loc7_ + v,this._y + _loc3_[0]) == true || this.getInWall(this._x + _loc7_ + v,this._y + _loc3_[1]) == true)
         {
            _loc5_ = 1;
            while(_loc5_ <= this.max_vx)
            {
               _loc6_ = 0;
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  if(this.getInWall(this._x + _loc7_ + v + _loc5_,this._y + _loc3_[_loc4_]) == false)
                  {
                     _loc6_ = _loc6_ + 1;
                  }
                  _loc4_ = _loc4_ + 1;
               }
               if(_loc6_ == _loc3_.length)
               {
                  this.changeDirection();
                  return v + _loc5_;
               }
               _loc5_ = _loc5_ + 1;
            }
         }
         else
         {
            if(this.getOverEdge(this._x + _loc7_ + v,this._y) != true)
            {
               return v;
            }
            _loc5_ = 1;
            while(_loc5_ <= this.max_vx)
            {
               if(this.getOverEdge(this._x + _loc7_ + v + _loc5_,this._y) == false)
               {
                  this.changeDirection();
                  return v + _loc5_;
               }
               _loc5_ = _loc5_ + 1;
            }
         }
      }
      else
      {
         this.vx = 0;
         return 0;
      }
   }
   function checkFloor(v)
   {
      v = Math.round(v);
      var _loc2_ = 1;
      while(_loc2_ <= v)
      {
         if(this.getInWall(this._x,this._y + _loc2_) == true)
         {
            return _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
      return v;
   }
   function changeDirection()
   {
      if(this.dir == com.nitrome.toxic.Global.LEFT)
      {
         this.dir = com.nitrome.toxic.Global.RIGHT;
         if(this.vx < 0)
         {
            this.vx = Math.abs(this.vx);
         }
      }
      else if(this.dir == com.nitrome.toxic.Global.RIGHT)
      {
         this.dir = com.nitrome.toxic.Global.LEFT;
         if(this.vx > 0)
         {
            this.vx = - this.vx;
         }
      }
   }
   function checkFallOff()
   {
      if(this._y > com.nitrome.toxic.Global.level_height - 64 && this.done_splash == false)
      {
         this.game.doSplash(this._x,this._y + 15);
         this.done_splash = true;
      }
      else if(this._y > com.nitrome.toxic.Global.level_height - 60)
      {
         this.game.removeRobot(this._name);
         this.removeMovieClip();
      }
   }
}
