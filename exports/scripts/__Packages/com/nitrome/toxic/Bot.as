class com.nitrome.toxic.Bot extends MovieClip
{
   var anim;
   var game;
   var hive;
   var dir;
   var start_dir;
   var state;
   var wall_boundary_right;
   var wall_boundary_left;
   var prev_dir;
   var vx = 0;
   var vy = 0;
   var max_vx = 1;
   var max_vy = 6;
   var fall_vy = 0;
   var max_slope = 16;
   var on_conveyor = false;
   var debris_right = new Array({id:13,x:-3,y:-6},{id:12,x:3,y:-5});
   var debris_left = new Array({id:11,x:3,y:-6},{id:10,x:-3,y:-5});
   var done_splash = false;
   function Bot()
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
   function init(game, hive, dir)
   {
      this.game = game;
      this.hive = hive;
      this.dir = dir;
      this.start_dir = dir;
      this.updateAnim();
      this.state = com.nitrome.toxic.Global.FALL;
      if(dir == com.nitrome.toxic.Global.LEFT)
      {
         this.vx = - this.max_vx;
      }
      else if(dir == com.nitrome.toxic.Global.RIGHT)
      {
         this.vx = this.max_vx;
      }
      this.vy = 0;
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
      if(this.state == com.nitrome.toxic.Global.FALL)
      {
         this.doFall();
         this.checkFallOff();
      }
      else if(this.state == com.nitrome.toxic.Global.WALK)
      {
         this.doWalk();
      }
   }
   function doWalk()
   {
      if(this.getOnGround(this._x,this._y) == false)
      {
         this.vy = this.fall_vy;
         this.state = com.nitrome.toxic.Global.FALL;
         return undefined;
      }
      this._x += this.checkWalls(this.vx);
      this.adjustToFloor();
      this.checkConveyorBelts();
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
   function checkWalls(v)
   {
      var _loc2_ = new Array(-10,-15);
      var _loc7_;
      var _loc5_;
      var _loc6_;
      var _loc3_;
      if(v > 0)
      {
         _loc7_ = this.wall_boundary_right._x;
         if(!(this.getInWall(this._x + _loc7_ + v,this._y + _loc2_[0]) == true || this.getInWall(this._x + _loc7_ + v,this._y + _loc2_[1]) == true))
         {
            return v;
         }
         _loc5_ = 1;
         while(_loc5_ <= this.max_vx)
         {
            _loc6_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(this.getInWall(this._x + _loc7_ + v - _loc5_,this._y + _loc2_[_loc3_]) == false)
               {
                  _loc6_ = _loc6_ + 1;
               }
               _loc3_ = _loc3_ + 1;
            }
            if(_loc6_ == _loc2_.length)
            {
               this.changeDirection();
               return v - _loc5_;
            }
            _loc5_ = _loc5_ + 1;
         }
      }
      else if(v < 0)
      {
         _loc7_ = this.wall_boundary_left._x;
         if(!(this.getInWall(this._x + _loc7_ + v,this._y + _loc2_[0]) == true || this.getInWall(this._x + _loc7_ + v,this._y + _loc2_[1]) == true))
         {
            return v;
         }
         _loc5_ = 1;
         while(_loc5_ <= this.max_vx)
         {
            _loc6_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(this.getInWall(this._x + _loc7_ + v + _loc5_,this._y + _loc2_[_loc3_]) == false)
               {
                  _loc6_ = _loc6_ + 1;
               }
               _loc3_ = _loc3_ + 1;
            }
            if(_loc6_ == _loc2_.length)
            {
               this.changeDirection();
               return v + _loc5_;
            }
            _loc5_ = _loc5_ + 1;
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
   function getOnScreen()
   {
      if(this.hitTest(_root.screen_test) == true)
      {
         return true;
      }
      return false;
   }
   function updateAnim()
   {
      if(this.dir != this.prev_dir)
      {
         if(this.dir == com.nitrome.toxic.Global.LEFT)
         {
            this.gotoAndStop("left");
         }
         else if(this.dir == com.nitrome.toxic.Global.RIGHT)
         {
            this.gotoAndStop("right");
         }
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
      this.game.decrementSpawn(this.hive);
      if(this.start_dir == com.nitrome.toxic.Global.LEFT)
      {
         this.game.decrementSpawnLeft(this.hive);
      }
      else if(this.start_dir == com.nitrome.toxic.Global.RIGHT)
      {
         this.game.decrementSpawnRight(this.hive);
      }
      this.removeMovieClip();
   }
   function checkFallOff()
   {
      if(this._y > com.nitrome.toxic.Global.level_height - 64 && this.done_splash == false)
      {
         if(this.getOnScreen() == true)
         {
            this.game.doSplash(this._x,this._y + 15);
         }
         this.done_splash = true;
      }
      else if(this._y > com.nitrome.toxic.Global.level_height - 60)
      {
         this.game.removeRobot(this._name);
         this.game.decrementSpawn(this.hive);
         if(this.start_dir == com.nitrome.toxic.Global.LEFT)
         {
            this.game.decrementSpawnLeft(this.hive);
         }
         else if(this.start_dir == com.nitrome.toxic.Global.RIGHT)
         {
            this.game.decrementSpawnRight(this.hive);
         }
         this.removeMovieClip();
      }
   }
   function conveyor(xspeed)
   {
      this.on_conveyor = true;
      if(xspeed > 0)
      {
         if(xspeed > this.vx)
         {
            xspeed -= this.vx;
         }
      }
      else if(xspeed < 0)
      {
         if(xspeed < this.vx)
         {
            xspeed = - (Math.abs(xspeed) - Math.abs(this.vx));
         }
      }
      var _loc3_ = this.checkConveyorWalls(xspeed);
      this._x += _loc3_;
   }
   function checkConveyorBelts()
   {
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(this.hitTest(_root.game.object_holder) == true)
      {
         _loc4_ = new Object();
         _loc4_.xMin = this._x - 20;
         _loc4_.xMax = this._x + 20;
         _loc4_.yMin = this._y - 20;
         _loc4_.yMax = this._y + 20;
         _global.img = new flash.display.BitmapData(_loc4_.xMax - _loc4_.xMin,_loc4_.yMax - _loc4_.yMin,false);
         _loc5_ = new flash.geom.Matrix();
         _loc5_.tx -= _loc4_.xMin;
         _loc5_.ty -= _loc4_.yMin;
         _global.imgb.draw(_root.game.object_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
         _global.imgb.draw(_root.game.bomb_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,255,255,255),"difference");
         _loc6_ = _global.imgb.getColorBoundsRect(4294967295,4278255615);
         if(_loc6_.width != 0)
         {
            this.game.findConveyor(this);
         }
         _global.imgb.dispose();
         delete _global.imgb;
      }
   }
   function checkConveyorWalls(v)
   {
      var _loc4_;
      var _loc6_;
      var _loc3_;
      var _loc2_;
      if(v != 0)
      {
         if(v > 0)
         {
            _loc4_ = new Array(-6,-12,-18);
            _loc6_ = this._x + this.wall_boundary_right._x;
            _loc3_ = 0;
            while(_loc3_ < Math.abs(v))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  if(this.game.getSceneryCollision(_loc6_ + _loc3_,this._y + _loc4_[_loc2_]) == true)
                  {
                     return _loc3_;
                  }
                  _loc2_ = _loc2_ + 1;
               }
               _loc3_ = _loc3_ + 1;
            }
            return v;
         }
         if(v < 0)
         {
            _loc4_ = new Array(-6,-12,-18);
            _loc6_ = this._x + this.wall_boundary_left._x;
            _loc3_ = 0;
            while(_loc3_ < Math.abs(v))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  if(this.game.getSceneryCollision(_loc6_ - _loc3_,this._y + _loc4_[_loc2_]) == true)
                  {
                     return - _loc3_;
                  }
                  _loc2_ = _loc2_ + 1;
               }
               _loc3_ = _loc3_ + 1;
            }
            return v;
         }
      }
      return 0;
   }
}
