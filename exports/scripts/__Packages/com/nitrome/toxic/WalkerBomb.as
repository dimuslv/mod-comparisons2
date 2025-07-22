class com.nitrome.toxic.WalkerBomb extends MovieClip
{
   var anim;
   var game;
   var vx;
   var vy;
   var dir;
   var start_dir;
   var state;
   var bottom_boundary;
   var right_boundary;
   var left_boundary;
   var top_boundary;
   var max_vx = 2;
   var max_vy = 6;
   var fall_vy = 0;
   var jump_vy = -12;
   var INERTIA = 0.92;
   var GRAVITY = 1;
   var max_slope = 16;
   var landed = false;
   var on_conveyor = false;
   var prev_dir = 100;
   var chid = 2324;
   function WalkerBomb()
   {
      super();
   }
   function getBombType()
   {
      return com.nitrome.toxic.Global.BOMB_WALKER;
   }
   function doPause()
   {
      _root._stop(this.anim);
   }
   function doUnpause()
   {
      _root._play(this.anim);
   }
   function init(game, x, y, vx, vy)
   {
      this.game = game;
      this._x = x;
      this._y = y;
      this.vx = vx;
      this.vy = vy;
      if(vx > 0)
      {
         this.dir = com.nitrome.toxic.Global.RIGHT;
      }
      else if(vx < 0)
      {
         this.dir = com.nitrome.toxic.Global.LEFT;
      }
      this.start_dir = this.dir;
      this.state = com.nitrome.toxic.Global.START;
      this.adjustToFloor();
      this.updateAnim();
   }
   function initPlayer(game, x, y, d, s, player_vx, player_vy, flag)
   {
      this.game = game;
      this._x = x;
      this._y = y;
      if(s == com.nitrome.toxic.Global.DUCK)
      {
         this.vx = 0;
         this.vy = 0;
      }
      else if(s == com.nitrome.toxic.Global.STAND)
      {
         if(d == com.nitrome.toxic.Global.LEFT)
         {
            if(flag == true)
            {
               this.vx = 0;
               this.vy = -3;
            }
            else
            {
               this.vx = -3;
               this.vy = -3;
            }
         }
         else if(d == com.nitrome.toxic.Global.RIGHT)
         {
            if(flag == true)
            {
               this.vx = 0;
               this.vy = -3;
            }
            else
            {
               this.vx = 3;
               this.vy = -3;
            }
         }
      }
      else if(s == com.nitrome.toxic.Global.WALK)
      {
         if(d == com.nitrome.toxic.Global.LEFT)
         {
            if(flag == true)
            {
               this.vx = 0;
               this.vy = -3;
            }
            else
            {
               this.vx = -3 + player_vx;
               this.vy = -3;
            }
         }
         else if(d == com.nitrome.toxic.Global.RIGHT)
         {
            if(flag == true)
            {
               this.vx = 0;
               this.vy = -3;
            }
            else
            {
               this.vx = 3 + player_vx;
               this.vy = -3;
            }
         }
      }
      else if(s == com.nitrome.toxic.Global.JUMP || s == com.nitrome.toxic.Global.FALL)
      {
         if(d == com.nitrome.toxic.Global.LEFT)
         {
            if(flag == true)
            {
               this.vx = 0;
               this.vy = -3 + player_vy;
            }
            else
            {
               this.vx = -3 + player_vx;
               this.vy = -3 + player_vy;
            }
         }
         else if(d == com.nitrome.toxic.Global.RIGHT)
         {
            if(flag == true)
            {
               this.vx = 0;
               this.vy = -3 + player_vy;
            }
            else
            {
               this.vx = 3 + player_vx;
               this.vy = -3 + player_vy;
            }
         }
      }
      if(this.vx > 0)
      {
         this.dir = com.nitrome.toxic.Global.RIGHT;
      }
      else if(this.vx < 0)
      {
         this.dir = com.nitrome.toxic.Global.LEFT;
      }
      else
      {
         this.dir = d;
      }
      this.start_dir = this.dir;
      this.adjustToFloor();
      this.state = com.nitrome.toxic.Global.START;
      if(this.vx == 0 && this.vy == 0)
      {
         this.start_dir = d;
         if(this.dir == com.nitrome.toxic.Global.LEFT)
         {
            this.vx = - this.max_vx;
         }
         else if(this.dir == com.nitrome.toxic.Global.RIGHT)
         {
            this.vx = this.max_vx;
         }
         this.state = com.nitrome.toxic.Global.WALK;
      }
   }
   function doExplode()
   {
      this.game.createExplosion(this._x,this._y,this._name,com.nitrome.toxic.Global.BOMB_WALKER);
   }
   function finishExplode()
   {
   }
   function getFinishedExplode()
   {
      return true;
   }
   function main()
   {
      this.updateAnim();
      var _loc4_;
      var _loc2_;
      var _loc3_;
      if(this.state == com.nitrome.toxic.Global.START)
      {
         this.landed = false;
         _loc4_ = this.checkVertWalls(this.vx);
         this._x += _loc4_;
         this._y += this.checkHorizWalls(this.vy);
         _loc2_ = Math.abs(this.vx);
         _loc2_ *= this.INERTIA;
         if(this.vx > 0)
         {
            this.vx = _loc2_;
         }
         else if(this.vx < 0)
         {
            this.vx = - _loc2_;
         }
         _loc2_ = Math.abs(this.vy);
         _loc2_ *= this.INERTIA;
         if(this.vy > 0)
         {
            this.vy = _loc2_;
         }
         else if(this.vy < 0)
         {
            this.vy = - _loc2_;
         }
         this.vy += this.GRAVITY;
         if(Math.abs(this.vy) < 0.5 && this.landed == true)
         {
            this.vy = 0;
            this.adjustToFloor();
         }
         if(Math.abs(this.vx) < 0.01)
         {
            this.vx = 0;
         }
         if(this.getOnGround(this._x,this._y + this.bottom_boundary._y) == true)
         {
            this.dir = this.start_dir;
            if(this.dir == com.nitrome.toxic.Global.LEFT)
            {
               this.vx = - this.max_vx;
            }
            else if(this.dir == com.nitrome.toxic.Global.RIGHT)
            {
               this.vx = this.max_vx;
            }
            this.state = com.nitrome.toxic.Global.WALK;
         }
      }
      else if(this.state == com.nitrome.toxic.Global.WALK)
      {
         if(this.dir == com.nitrome.toxic.Global.LEFT)
         {
            _loc3_ = this.right_boundary._x;
         }
         else if(this.dir == com.nitrome.toxic.Global.RIGHT)
         {
            _loc3_ = this.left_boundary._x;
         }
         this._x += this.checkWalls(this.vx);
         this.adjustToFloor();
         this.checkConveyorBelts();
         if(this.getOnGround(this._x + _loc3_,this._y + this.bottom_boundary._y) == false)
         {
            this.vy = this.fall_vy;
            this.state = com.nitrome.toxic.Global.FALL;
            return undefined;
         }
      }
      else if(this.state == com.nitrome.toxic.Global.FALL)
      {
         this.vy = this.vy + 1;
         if(this.vy > this.max_vy)
         {
            this.vy = this.max_vy;
         }
         this._y += this.checkFloor(this.vy);
         this.adjustToFloor();
         if(this.getOnGround(this._x,this._y + this.bottom_boundary._y) == true)
         {
            this.state = com.nitrome.toxic.Global.WALK;
         }
      }
      else if(this.state == com.nitrome.toxic.Global.JUMP)
      {
         this.vy = this.vy + 1;
         if(this.vy > this.max_vy)
         {
            this.vy = this.max_vy;
         }
         if(this.vy < 0)
         {
            this._y += this.checkCeiling(this.vy);
         }
         else
         {
            this._y += this.checkFloor(this.vy);
         }
         this._x += this.checkWalls(this.vx);
         if(this.getOnGround(this._x,this._y + this.bottom_boundary._y) == true)
         {
            this.state = com.nitrome.toxic.Global.WALK;
         }
      }
   }
   function startJump()
   {
      if(this.getOnGround(this._x,this._y + this.bottom_boundary._y) == true)
      {
         this.vy = this.jump_vy;
         this.state = com.nitrome.toxic.Global.JUMP;
      }
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
      this.prev_dir = this.dir;
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
            _loc6_ = this._x + this.right_boundary._x;
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
            _loc6_ = this._x + this.left_boundary._x;
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
   function checkVertWalls(v)
   {
      var _loc5_;
      var _loc6_;
      var _loc3_;
      var _loc2_;
      if(v != 0)
      {
         if(v > 0)
         {
            _loc5_ = new Array(-8,-6,-4,-2,0,2,4,6);
            _loc6_ = this._x + this.right_boundary._x;
            _loc3_ = 0;
            while(_loc3_ < Math.abs(v))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  if(this.game.getSceneryCollision(_loc6_ + _loc3_,this._y + _loc5_[_loc2_]) == true)
                  {
                     this.vx = v * -1;
                     this.dir = com.nitrome.toxic.Global.LEFT;
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
            _loc5_ = new Array(-8,-6,-4,-2,0,2,4,6);
            _loc6_ = this._x + this.left_boundary._x;
            _loc3_ = 0;
            while(_loc3_ < Math.abs(v))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  if(this.game.getSceneryCollision(_loc6_ - _loc3_,this._y + _loc5_[_loc2_]) == true)
                  {
                     this.vx = v * -1;
                     this.dir = com.nitrome.toxic.Global.RIGHT;
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
   function checkHorizWalls(v)
   {
      var _loc5_;
      var _loc6_;
      var _loc3_;
      var _loc2_;
      if(v != 0)
      {
         if(v > 0)
         {
            _loc5_ = new Array(-6,-4,-2,0,2,4,6,8);
            _loc6_ = this._y + this.bottom_boundary._y;
            _loc3_ = 0;
            while(_loc3_ < Math.abs(v))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  if(this.game.getSceneryCollision(this._x + _loc5_[_loc2_],_loc6_ + _loc3_) == true)
                  {
                     if(this.vy > 1)
                     {
                        this.vy = this.vy - 1;
                     }
                     this.vy = v * -1;
                     this.landed = true;
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
            _loc5_ = new Array(-8,-6,-4,-2,0,2,4,6);
            _loc6_ = this._y + this.top_boundary._y;
            _loc3_ = 0;
            while(_loc3_ < Math.abs(v))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  if(this.game.getSceneryCollision(this._x + _loc5_[_loc2_],_loc6_ - _loc3_) == true)
                  {
                     this.vy = v * -1;
                     this.landed = true;
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
   function adjustToFloor()
   {
      var _loc3_;
      var _loc2_;
      if(this.getInGround(this._x,this._y + this.bottom_boundary._y) == true)
      {
         if(this.vy >= 0)
         {
            _loc3_ = false;
            _loc2_ = 1;
            while(_loc2_ <= this.max_slope)
            {
               if(this.getOnGround(this._x,this._y + this.bottom_boundary._y - _loc2_) == true)
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
   function checkWalls(v)
   {
      var _loc2_ = new Array(-6,-12,-18);
      var _loc7_;
      var _loc5_;
      var _loc6_;
      var _loc3_;
      if(v > 0)
      {
         _loc7_ = this.right_boundary._x;
         if(!(this.getInWall(this._x + _loc7_ + v,this._y + _loc2_[0]) == true || this.getInWall(this._x + _loc7_ + v,this._y + _loc2_[1]) == true || this.getInWall(this._x + _loc7_ + v,this._y + _loc2_[2]) == true))
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
         _loc7_ = this.left_boundary._x;
         if(!(this.getInWall(this._x + _loc7_ + v,this._y + _loc2_[0]) == true || this.getInWall(this._x + _loc7_ + v,this._y + _loc2_[1]) == true || this.getInWall(this._x + _loc7_ + v,this._y + _loc2_[2]) == true))
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
   function getInWall(x, y)
   {
      if(this.game.getSceneryCollision(x,y) == true)
      {
         return true;
      }
      return false;
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
   function checkCeiling(v)
   {
      v = Math.abs(Math.round(v));
      var _loc2_ = 1;
      while(_loc2_ <= v)
      {
         if(this.getInWall(this._x,this._y + this.top_boundary._y - _loc2_) == true)
         {
            return - _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
      return - v;
   }
}
