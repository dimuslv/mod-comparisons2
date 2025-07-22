class com.nitrome.toxic.MovingCannon extends MovieClip
{
   var anim;
   var game;
   var dir;
   var state;
   var vx;
   var player;
   var wall_boundary_right;
   var wall_boundary_left;
   var bullet_point;
   var prev_dir = 100;
   var prev_state = 100;
   var debris_right = new Array({id:21,x:6,y:-33},{id:22,x:-12,y:-42},{id:17,x:0,y:-14});
   var debris_left = new Array({id:19,x:-6,y:-33},{id:20,x:13,y:-42},{id:17,x:0,y:-14});
   var max_vx = 1;
   function MovingCannon()
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
   function init(game, dir, tall)
   {
      this.game = game;
      this.dir = dir;
      this.state = com.nitrome.toxic.Global.WALK;
      if(dir == com.nitrome.toxic.Global.LEFT)
      {
         this.vx = - this.max_vx;
      }
      else if(dir == com.nitrome.toxic.Global.RIGHT)
      {
         this.vx = this.max_vx;
      }
      this.updateAnim();
   }
   function main()
   {
      this._visible = this.getOnScreen();
      this.updateAnim();
      if(this.state == com.nitrome.toxic.Global.WALK)
      {
         this.doWalk();
         this.checkForPlayer();
      }
      else if(this.state == com.nitrome.toxic.Global.FIRE)
      {
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
   function checkForPlayer()
   {
      if(this.player == undefined)
      {
         this.player = _root.game.player_holder.player;
      }
      var _loc3_ = 10;
      while(_loc3_ <= 600)
      {
         if(this.dir == com.nitrome.toxic.Global.LEFT)
         {
            if(this.player.hitTest(this.game._x + this._x - _loc3_,this.game._y + this._y - 40,true) == true)
            {
               this.state = com.nitrome.toxic.Global.FIRE;
               return undefined;
            }
            if(this.game.getSceneryCollision(this._x - _loc3_,this._y - 40) == true)
            {
               this.state = com.nitrome.toxic.Global.WALK;
               return undefined;
            }
         }
         else if(this.dir == com.nitrome.toxic.Global.RIGHT)
         {
            if(this.player.hitTest(this.game._x + this._x + _loc3_,this.game._y + this._y - 40,true) == true)
            {
               this.state = com.nitrome.toxic.Global.FIRE;
               return undefined;
            }
            if(this.game.getSceneryCollision(this._x + _loc3_,this._y - 40) == true)
            {
               this.state = com.nitrome.toxic.Global.WALK;
               return undefined;
            }
         }
         _loc3_ += 10;
      }
      this.state = com.nitrome.toxic.Global.WALK;
   }
   function doWalk()
   {
      this._x += this.checkWalls(this.vx);
   }
   function checkWalls(v)
   {
      var _loc3_ = new Array(-10,-20,-30,-40);
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
      this.updateAnim();
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
      if(this.dir != this.prev_dir || this.state != this.prev_state)
      {
         this.gotoAndStop(com.nitrome.toxic.Global.state_string[this.state] + com.nitrome.toxic.Global.dir_string[this.dir]);
      }
   }
   function doFire()
   {
      this.game.fireBullet(this._x + this.bullet_point._x,this._y + this.bullet_point._y,this.dir);
   }
   function finishFire()
   {
      this.checkForPlayer();
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
   function getInWall(x, y)
   {
      if(this.game.getSceneryCollision(x,y) == true)
      {
         return true;
      }
      return false;
   }
}
