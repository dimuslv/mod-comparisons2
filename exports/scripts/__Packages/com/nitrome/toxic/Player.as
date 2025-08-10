class com.nitrome.toxic.Player extends MovieClip
{
   var anim;
   var dir;
   var state;
   var game;
   var wall_boundary_left;
   var wall_boundary_right;
   var lx;
   var rx;
   var prev_dir;
   var ceil_boundary;
   var prev_state;
   var vx = 0;
   var vy = 0;
   var max_slope = 20;
   var max_vx = 12;
   var max_vy = 12;
   var jump_vy = -16;
   var walljump_vy = -12;
   var hit_vy = -8;
   var fall_vy = 0;
   var wall_count = 0;
   var max_wall_count = 3;
   var fall_count = 0;
   var max_fall_count = 5;
   var wall_jump = false;
   var fall_anim_count = 0;
   var left_edge = false;
   var right_edge = false;
   var hit_ceiling = false;
   var hit = false;
   var hit_count = 0;
   var bomb_type = 1;
   var quickpause = false;
   var stage_6 = false;
   var found_secret = false;
   var chid = 2121;
   function Player()
   {
      super();
   }
   function doPause()
   {
      _root._stop(this.anim);
   }
   function doUnpause()
   {
      _root._play(this.anim);
   }
   function init(dir, x, y, game)
   {
      this.dir = dir;
      this.state = com.nitrome.toxic.Global.START;
      if(this.dir == com.nitrome.toxic.Global.LEFT)
      {
         this._x = x + 24;
      }
      else if(this.dir == com.nitrome.toxic.Global.RIGHT)
      {
         this._x = x + 8;
      }
      this._y = y;
      this.game = game;
      this.updateAnim();
      this.adjustToFloor();
   }
   function setBombType(bt)
   {
      this.bomb_type = bt;
   }
   function finishStart()
   {
      this.state = com.nitrome.toxic.Global.STAND;
      this.updateAnim();
   }
   function quickPause()
   {
      this.quickpause = true;
      this.vx = 0;
   }
   function finishQuickPause()
   {
      this.quickpause = false;
   }
   function getQuickPause()
   {
      return this.quickpause;
   }
   function checkAdjustScroll()
   {
      if(this.stage_6 == false)
      {
         if(this._y == 1280 && this._x > 1860)
         {
            this.game.smoothScroll();
            this.stage_6 == true;
         }
      }
   }
   function main()
   {
      if(this.quickpause == true)
      {
         if(this.state == com.nitrome.toxic.Global.JUMP)
         {
            this.doJump();
         }
         else if(this.state == com.nitrome.toxic.Global.FALL)
         {
            this.doFall();
         }
         else
         {
            this.state = com.nitrome.toxic.Global.STAND;
            this.updateAnim();
         }
      }
      else
      {
         this.checkAdjustScroll();
         this.updateAnim();
         this.checkScreenBounds();
         if(this.state != com.nitrome.toxic.Global.START)
         {
            if(this.state == com.nitrome.toxic.Global.STAND)
            {
               this.doStand();
               this.checkCollisions();
               this.checkPickUps();
            }
            else if(this.state == com.nitrome.toxic.Global.DUCK)
            {
               this.doDuck();
               this.checkCollisions();
               this.checkPickUps();
            }
            else if(this.state == com.nitrome.toxic.Global.WALK)
            {
               this.doWalk();
               this.checkCollisions();
               this.checkPickUps();
            }
            else if(this.state == com.nitrome.toxic.Global.JUMP)
            {
               this.doJump();
               this.checkCollisions();
               this.checkPickUps();
               this.checkFallOff();
            }
            else if(this.state == com.nitrome.toxic.Global.FALL)
            {
               this.doFall();
               this.checkCollisions();
               this.checkPickUps();
               this.checkFallOff();
            }
            else if(this.state == com.nitrome.toxic.Global.WALL)
            {
               this.doWall();
               this.checkCollisions();
               this.checkPickUps();
            }
            else if(this.state != com.nitrome.toxic.Global.HIT)
            {
               if(this.state == com.nitrome.toxic.Global.DIE)
               {
                  this._y = this._y + 1;
                  this.adjustToFloor();
               }
               else if(this.state == com.nitrome.toxic.Global.END)
               {
               }
            }
         }
         if(this.hit_count > 0)
         {
            this.hit_count = this.hit_count - 1;
            if(this.hit_count % 3 == 0)
            {
               this._alpha = 20;
            }
            else
            {
               this._alpha = 100;
            }
         }
         else
         {
            this._alpha = 100;
         }
         this.checkMines();
      }
   }
   function checkScreenBounds()
   {
      var _loc2_ = this._x + this.wall_boundary_left._x;
      var _loc3_ = this._x + this.wall_boundary_right._x;
      if(_loc2_ < 0)
      {
         this._x += _loc2_ * -1;
      }
      if(_loc3_ > com.nitrome.toxic.Global.level_width)
      {
         this._x -= _loc3_ - com.nitrome.toxic.Global.level_width;
      }
   }
   function startTransport(secret)
   {
      this.found_secret = secret;
      this.state = com.nitrome.toxic.Global.END;
      this.updateAnim();
   }
   function finishEnd()
   {
      if(this.found_secret == true)
      {
         this.game.levelCompleteBonus();
      }
      else
      {
         this.game.levelComplete();
      }
   }
   function conveyor(xspeed)
   {
      if(this.state == com.nitrome.toxic.Global.WALK || this.state == com.nitrome.toxic.Global.STAND)
      {
         this._x += this.checkConveyorWalls(xspeed,false);
      }
      else if(this.state == com.nitrome.toxic.Global.DUCK)
      {
         this._x += this.checkConveyorWalls(xspeed,true);
      }
   }
   function checkPickUps()
   {
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(this.hitTest(_root.game.object_holder) == true)
      {
         _loc4_ = new Object();
         _loc4_.xMin = this._x - 30;
         _loc4_.xMax = this._x + 30;
         _loc4_.yMin = this._y - 50;
         _loc4_.yMax = this._y + 2;
         _global.img = new flash.display.BitmapData(_loc4_.xMax - _loc4_.xMin,_loc4_.yMax - _loc4_.yMin,false);
         _loc5_ = new flash.geom.Matrix();
         _loc5_.tx -= _loc4_.xMin;
         _loc5_.ty -= _loc4_.yMin;
         _global.img.draw(_root.game.object_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
         _global.img.draw(_root.game.player_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,255,255,255),"difference");
         _loc6_ = _global.img.getColorBoundsRect(4294967295,4278255615);
         Utils.updateVisBitmap("Object",_global.img);
         if(_loc6_.width != 0)
         {
            this.game.findCollectObject();
            this.game.findConveyor(this);
         }
         _global.img.dispose();
         delete _global.img;
      }
   }
   function checkCollisions()
   {
      var _loc4_ = new Object();
      _loc4_.xMin = this._x - 30;
      _loc4_.xMax = this._x + 30;
      _loc4_.yMin = this._y - 50;
      _loc4_.yMax = this._y + 2;
      var _loc5_ = new flash.geom.Matrix();
      _loc5_.tx -= _loc4_.xMin;
      _loc5_.ty -= _loc4_.yMin;
      var _loc7_;
      if(this.hit == false && this.hit_count == 0)
      {
         _global.img = new flash.display.BitmapData(_loc4_.xMax - _loc4_.xMin,_loc4_.yMax - _loc4_.yMin,false);
         _global.img.draw(_root.game.danger_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
         _global.img.draw(_root.game.explosion_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
         _global.img.draw(_root.game.laser_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
         _global.img.draw(_root.game.missile_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
         _global.img.draw(_root.game.player_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,255,255,255),"difference");
         _loc7_ = _global.img.getColorBoundsRect(4294967295,4278255615);
         Utils.updateVisBitmap("Damage",_global.img);
         if(_loc7_.width == 0)
         {
            _global.img.dispose();
            delete _global.img;
         }
         else
         {
            this.startHit();
            _global.img.dispose();
            delete _global.img;
         }
      }
      _global.img5 = new flash.display.BitmapData(_loc4_.xMax - _loc4_.xMin,_loc4_.yMax - _loc4_.yMin,false);
      _global.img5.draw(_root.game.acid_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
      _global.img5.draw(_root.game.player_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,255,255,255),"difference");
      Utils.updateVisBitmap("Acid",_global.img5);
      var _loc6_ = _global.img5.getColorBoundsRect(4294967295,4278255615);
      if(_loc6_.width != 0)
      {
         this.forcedGameOver();
         this.game.doSplash(this._x,this._y + 15);
      }
      _global.img5.dispose();
      delete _global.img5;
   }
   function checkMines()
   {
      this.game.checkMineProximity(this._x,this._y - this._height * 0.5);
   }
   function checkFallOff()
   {
      if(this._y > com.nitrome.toxic.Global.level_height - 64)
      {
         this.forcedGameOver();
         this.game.doSplash(this._x,this._y + 15);
      }
   }
   function calculateDistance(b)
   {
      this.lx = this._x + this.wall_boundary_left._x;
      this.rx = this._x + this.wall_boundary_right._x;
      var _loc4_ = 35;
      var _loc3_ = 35;
      if(this.getInGround(this.lx,this._y) == true)
      {
         _loc4_ = 0;
      }
      if(this.getInGround(this.rx,this._y) == true)
      {
         _loc3_ = 0;
      }
      var _loc2_ = 0;
      while(_loc2_ <= 34)
      {
         if(this.getInAir(this.lx,this._y + _loc2_) != true)
         {
            if(this.getOnGround(this.lx,this._y + _loc2_) == true)
            {
               _loc4_ = _loc2_;
               break;
            }
         }
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ <= 34)
      {
         if(this.getInAir(this.rx,this._y + _loc2_) != true)
         {
            if(this.getOnGround(this.rx,this._y + _loc2_) == true)
            {
               _loc3_ = _loc2_;
               break;
            }
         }
         _loc2_ = _loc2_ + 1;
      }
      if(_loc4_ > 0 && _loc4_ >= 32 && _loc3_ == 0)
      {
         this.left_edge = true;
      }
      else
      {
         this.left_edge = false;
      }
      if(_loc3_ > 0 && _loc3_ >= 32 && _loc4_ == 0)
      {
         this.right_edge = true;
      }
      else
      {
         this.right_edge = false;
      }
      if(b == true)
      {
         if(_loc4_ >= 32 && _loc3_ < _loc4_)
         {
            this.left_edge = true;
         }
         if(_loc3_ >= 32 && _loc4_ < _loc3_)
         {
            this.right_edge = true;
         }
      }
   }
   function forcedGameOver()
   {
      if(Utils.invulnerable || Utils.noDeath)
      {
         return undefined;
      }
      this.startDie();
      _root.health_panel.loseAllHealth();
   }
   function startHit()
   {
      if(Utils.invulnerable)
      {
         return undefined;
      }
      this.hit = true;
      this.hit_count = 60;
      this.vy = this.hit_vy;
      this.state = com.nitrome.toxic.Global.JUMP;
      this.updateAnim();
      _root.sfx.playSound("hit");
      _root.health_panel.loseHealth();
   }
   function finishHit()
   {
      if(this.hit_count < 40)
      {
         this.prev_dir = 100;
         this.hit = false;
         this.updateAnim();
      }
   }
   function startDie()
   {
      this.state = com.nitrome.toxic.Global.DIE;
   }
   function finishDie()
   {
      this.game.gameOver();
   }
   function doStand()
   {
      if(this.hit == true)
      {
         this.finishHit();
      }
      this.calculateDistance(false);
      this.vy = 0;
      if(this.vx != 0)
      {
         this.vx = Math.round(this.vx);
         if(this.vx > 0)
         {
            this.vx -= 2;
            if(this.vx <= 0)
            {
               this.vx = 0;
            }
         }
         else if(this.vx < 0)
         {
            this.vx += 2;
            if(this.vx >= 0)
            {
               this.vx = 0;
            }
         }
         else
         {
            this.vx = 0;
         }
         this._x += this.checkWalls(this.vx,false);
      }
      if(com.nitrome.toxic.Global.DOWN_PRESSED == true)
      {
         this.state = com.nitrome.toxic.Global.DUCK;
         return undefined;
      }
      if(com.nitrome.toxic.Global.UP_PRESSED == true)
      {
         this.startJump();
         return undefined;
      }
      if(com.nitrome.toxic.Global.DIR_PRESSED != -1)
      {
         if(this.left_edge == true)
         {
            if(this.getOnGround(this.rx,this._y) == true)
            {
               this.state = com.nitrome.toxic.Global.WALK;
               this.dir = com.nitrome.toxic.Global.DIR_PRESSED;
            }
         }
         else if(this.right_edge == true)
         {
            if(this.getOnGround(this.lx,this._y) == true)
            {
               this.state = com.nitrome.toxic.Global.WALK;
               this.dir = com.nitrome.toxic.Global.DIR_PRESSED;
            }
         }
         else if(this.getOnGround(this._x,this._y) == true)
         {
            this.state = com.nitrome.toxic.Global.WALK;
            this.dir = com.nitrome.toxic.Global.DIR_PRESSED;
         }
      }
      else
      {
         if(this.left_edge == true)
         {
            if(this.getOnGround(this.rx,this._y) == false)
            {
               this.fall_anim_count = 0;
               this.vy = this.fall_vy;
               this.state = com.nitrome.toxic.Global.FALL;
               return undefined;
            }
         }
         else if(this.right_edge == true)
         {
            if(this.getOnGround(this.lx,this._y) == false)
            {
               this.fall_anim_count = 0;
               this.vy = this.fall_vy;
               this.state = com.nitrome.toxic.Global.FALL;
               return undefined;
            }
         }
         else if(this.getOnGround(this._x,this._y) == false)
         {
            this.fall_anim_count = 0;
            this.vy = this.fall_vy;
            this.state = com.nitrome.toxic.Global.FALL;
            return undefined;
         }
         this.adjustToFloor();
      }
   }
   function doWalk()
   {
      if(this.hit == true)
      {
         this.finishHit();
      }
      this.calculateDistance(false);
      if(com.nitrome.toxic.Global.DOWN_PRESSED == true)
      {
         this.state = com.nitrome.toxic.Global.DUCK;
         return undefined;
      }
      if(com.nitrome.toxic.Global.UP_PRESSED == true)
      {
         this.startJump();
         return undefined;
      }
      if(this.left_edge == true && this.getOnGround(this.rx,this._y) == false)
      {
         this.fall_anim_count = 0;
         this.vy = this.fall_vy;
         this.state = com.nitrome.toxic.Global.FALL;
         return undefined;
      }
      if(this.right_edge == true && this.getOnGround(this.lx,this._y) == false)
      {
         this.fall_anim_count = 0;
         this.vy = this.fall_vy;
         this.state = com.nitrome.toxic.Global.FALL;
         return undefined;
      }
      if(this.left_edge == false && this.right_edge == false && this.getOnGround(this._x,this._y) == false)
      {
         this.fall_anim_count = 0;
         this.vy = this.fall_vy;
         this.state = com.nitrome.toxic.Global.FALL;
         return undefined;
      }
      if(com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.LEFT)
      {
         if(Math.abs(this.vx) < this.max_vx)
         {
            if(this.vx > 0)
            {
               this.vx -= 1.5;
            }
            else
            {
               this.vx = this.vx - 1;
            }
         }
         else
         {
            if(this.vx > 0)
            {
               this.vx -= 1.5;
            }
            if(Math.abs(this.vx) > this.max_vx)
            {
               this.vx = - this.max_vx;
            }
         }
         this.state = com.nitrome.toxic.Global.WALK;
         this.dir = com.nitrome.toxic.Global.DIR_PRESSED;
      }
      else if(com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.RIGHT)
      {
         if(Math.abs(this.vx) < this.max_vx)
         {
            if(this.vx < 0)
            {
               this.vx += 1.5;
            }
            else
            {
               this.vx = this.vx + 1;
            }
         }
         else
         {
            if(this.vx < 0)
            {
               this.vx += 1.5;
            }
            if(Math.abs(this.vx) > this.max_vx)
            {
               this.vx = this.max_vx;
            }
         }
         this.state = com.nitrome.toxic.Global.WALK;
         this.dir = com.nitrome.toxic.Global.DIR_PRESSED;
      }
      else if(this.left_edge == true)
      {
         if(this.getOnGround(this.rx,this._y) == false)
         {
            this.fall_anim_count = 0;
            this.vy = this.fall_vy;
            this.state = com.nitrome.toxic.Global.FALL;
            return undefined;
         }
         this.state = com.nitrome.toxic.Global.STAND;
      }
      else if(this.right_edge == true)
      {
         if(this.getOnGround(this.lx,this._y) == false)
         {
            this.fall_anim_count = 0;
            this.vy = this.fall_vy;
            this.state = com.nitrome.toxic.Global.FALL;
            return undefined;
         }
         this.state = com.nitrome.toxic.Global.STAND;
      }
      else
      {
         if(this.getOnGround(this._x,this._y) == false)
         {
            this.fall_anim_count = 0;
            this.vy = this.fall_vy;
            this.state = com.nitrome.toxic.Global.FALL;
            return undefined;
         }
         this.state = com.nitrome.toxic.Global.STAND;
      }
      this._x += this.checkWalls(this.vx,false);
      this.adjustToFloor();
   }
   function doFall()
   {
      this.calculateDistance(false);
      this.vy = this.vy + 1;
      if(this.vy > this.max_vy)
      {
         this.vy = this.max_vy;
      }
      this._y += this.checkFloor(this.vy);
      if(com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.LEFT)
      {
         if(Math.abs(this.vx) < this.max_vx)
         {
            if(this.vx > 0)
            {
               this.vx -= 1.5;
            }
            else
            {
               this.vx = this.vx - 1;
            }
         }
         else
         {
            if(this.vx > 0)
            {
               this.vx -= 1.5;
            }
            if(Math.abs(this.vx) > this.max_vx)
            {
               this.vx = - this.max_vx;
            }
         }
         this.dir = com.nitrome.toxic.Global.DIR_PRESSED;
      }
      else if(com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.RIGHT)
      {
         if(Math.abs(this.vx) < this.max_vx)
         {
            if(this.vx < 0)
            {
               this.vx += 1.5;
            }
            else
            {
               this.vx = this.vx + 1;
            }
         }
         else
         {
            if(this.vx < 0)
            {
               this.vx += 1.5;
            }
            if(Math.abs(this.vx) > this.max_vx)
            {
               this.vx = this.max_vx;
            }
         }
         this.dir = com.nitrome.toxic.Global.DIR_PRESSED;
      }
      else if(this.vx > 0)
      {
         this.vx = this.vx - 1;
      }
      else if(this.vx < 0)
      {
         this.vx = this.vx + 1;
      }
      else
      {
         this.vx = 0;
      }
      this.wall_jump = false;
      this._x += this.checkWalls(this.vx,false);
      if(this.wall_jump == true)
      {
         if(this.dir == com.nitrome.toxic.Global.LEFT && com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.LEFT || this.dir == com.nitrome.toxic.Global.RIGHT && com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.RIGHT)
         {
            this.wall_count = this.wall_count + 1;
            if(this.wall_count >= this.max_wall_count)
            {
               this.startWall();
               return undefined;
            }
         }
      }
      if(this.vy > 0)
      {
         this.adjustToFloor();
      }
      if(this.left_edge == true)
      {
         if(this.getOnGround(this.rx,this._y) == true)
         {
            if(com.nitrome.toxic.Global.UP_PRESSED == false)
            {
               com.nitrome.toxic.Global.can_jump = true;
            }
            if(this.vx == 0)
            {
               this.state = com.nitrome.toxic.Global.STAND;
            }
            else
            {
               this.state = com.nitrome.toxic.Global.WALK;
            }
         }
      }
      else if(this.right_edge == true)
      {
         if(this.getOnGround(this.lx,this._y) == true)
         {
            if(com.nitrome.toxic.Global.UP_PRESSED == false)
            {
               com.nitrome.toxic.Global.can_jump = true;
            }
            if(this.vx == 0)
            {
               this.state = com.nitrome.toxic.Global.STAND;
            }
            else
            {
               this.state = com.nitrome.toxic.Global.WALK;
            }
         }
      }
      else if(this.getOnGround(this._x,this._y) == true)
      {
         if(com.nitrome.toxic.Global.UP_PRESSED == false)
         {
            com.nitrome.toxic.Global.can_jump = true;
         }
         if(this.vx == 0)
         {
            this.state = com.nitrome.toxic.Global.STAND;
         }
         else
         {
            this.state = com.nitrome.toxic.Global.WALK;
         }
      }
   }
   function doDuck()
   {
      if(this.vx != 0)
      {
         this.vx = Math.round(this.vx);
         if(this.vx > 0)
         {
            this.vx -= 2;
            if(this.vx <= 0)
            {
               this.vx = 0;
            }
         }
         else if(this.vx < 0)
         {
            this.vx += 2;
            if(this.vx >= 0)
            {
               this.vx = 0;
            }
         }
         else
         {
            this.vx = 0;
         }
         this._x += this.checkWalls(this.vx,true);
      }
      this.adjustToFloor();
      if(com.nitrome.toxic.Global.DOWN_PRESSED == false)
      {
         this.state = com.nitrome.toxic.Global.STAND;
      }
   }
   function startJump()
   {
      if(com.nitrome.toxic.Global.can_jump == true)
      {
         this.vy = this.jump_vy;
         this.state = com.nitrome.toxic.Global.JUMP;
         com.nitrome.toxic.Global.can_jump = false;
         _root.sfx.playSound("jump");
         if(this.hit == false)
         {
            this.game.broadcastJump();
         }
      }
   }
   function startWallJump()
   {
      if(com.nitrome.toxic.Global.can_jump == true)
      {
         this.vy = this.walljump_vy;
         this.state = com.nitrome.toxic.Global.JUMP;
         _root.sfx.playSound("jump");
         com.nitrome.toxic.Global.can_jump = false;
      }
   }
   function doJump()
   {
      this.calculateDistance(true);
      this.hit_ceiling = false;
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
      if(com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.LEFT)
      {
         if(Math.abs(this.vx) < this.max_vx)
         {
            if(this.vx > 0)
            {
               this.vx -= 1.5;
            }
            else
            {
               this.vx = this.vx - 1;
            }
         }
         else
         {
            if(this.vx > 0)
            {
               this.vx -= 1.5;
            }
            if(Math.abs(this.vx) > this.max_vx)
            {
               this.vx = - this.max_vx;
            }
         }
         this.dir = com.nitrome.toxic.Global.DIR_PRESSED;
      }
      else if(com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.RIGHT)
      {
         if(Math.abs(this.vx) < this.max_vx)
         {
            if(this.vx < 0)
            {
               this.vx += 1.5;
            }
            else
            {
               this.vx = this.vx + 1;
            }
         }
         else
         {
            if(this.vx < 0)
            {
               this.vx += 1.5;
            }
            if(Math.abs(this.vx) > this.max_vx)
            {
               this.vx = this.max_vx;
            }
         }
         this.dir = com.nitrome.toxic.Global.DIR_PRESSED;
      }
      else if(this.vx > 0)
      {
         this.vx = this.vx - 1;
      }
      else if(this.vx < 0)
      {
         this.vx = this.vx + 1;
      }
      else
      {
         this.vx = 0;
      }
      this.wall_jump = false;
      this._x += this.checkWalls(this.vx,false);
      if(this.wall_jump == true)
      {
         if(this.dir == com.nitrome.toxic.Global.LEFT && com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.LEFT || this.dir == com.nitrome.toxic.Global.RIGHT && com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.RIGHT)
         {
            this.wall_count = this.wall_count + 1;
            if(this.wall_count >= this.max_wall_count)
            {
               this.startWall();
               return undefined;
            }
         }
      }
      if(this.vy > 0 && this.hit_ceiling == false)
      {
         this.adjustToFloor();
      }
      if(this.left_edge == true)
      {
         if(this.getOnGround(this.rx,this._y) == true)
         {
            if(com.nitrome.toxic.Global.UP_PRESSED == false)
            {
               com.nitrome.toxic.Global.can_jump = true;
            }
            if(this.vx == 0)
            {
               this.state = com.nitrome.toxic.Global.STAND;
            }
            else
            {
               this.state = com.nitrome.toxic.Global.WALK;
            }
         }
      }
      else if(this.right_edge == true)
      {
         if(this.getOnGround(this.lx,this._y) == true)
         {
            if(com.nitrome.toxic.Global.UP_PRESSED == false)
            {
               com.nitrome.toxic.Global.can_jump = true;
            }
            if(this.vx == 0)
            {
               this.state = com.nitrome.toxic.Global.STAND;
            }
            else
            {
               this.state = com.nitrome.toxic.Global.WALK;
            }
         }
      }
      else if(this.getOnGround(this._x,this._y) == true)
      {
         if(com.nitrome.toxic.Global.UP_PRESSED == false)
         {
            com.nitrome.toxic.Global.can_jump = true;
         }
         if(this.vx == 0)
         {
            this.state = com.nitrome.toxic.Global.STAND;
         }
         else
         {
            this.state = com.nitrome.toxic.Global.WALK;
         }
      }
   }
   function startWall()
   {
      this.state = com.nitrome.toxic.Global.WALL;
      this.wall_count = 0;
      this.fall_count = 0;
      this.vy = 0;
      this.vx = 0;
      com.nitrome.toxic.Global.can_jump = true;
   }
   function doWall()
   {
      if(this.hit == true)
      {
         this.finishHit();
      }
      this._y = this._y + 1;
      if(this.dir == com.nitrome.toxic.Global.LEFT && com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.LEFT)
      {
         this.fall_count = 0;
         if(this.getOnGround(this._x,this._y) == true)
         {
            this.state = com.nitrome.toxic.Global.STAND;
            return undefined;
         }
         if(this.getInGround(this._x,this._y) == true)
         {
            this.state = com.nitrome.toxic.Global.STAND;
            this.adjustToFloor();
            return undefined;
         }
         if(this.getOnWall(this._x - 13,this._y - 30) == false)
         {
            this.fall_anim_count = 0;
            this.state = com.nitrome.toxic.Global.FALL;
            return undefined;
         }
      }
      else if(this.dir == com.nitrome.toxic.Global.RIGHT && com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.RIGHT)
      {
         this.fall_count = 0;
         if(this.getOnGround(this._x,this._y) == true)
         {
            this.state = com.nitrome.toxic.Global.STAND;
            return undefined;
         }
         if(this.getInGround(this._x,this._y) == true)
         {
            this.state = com.nitrome.toxic.Global.STAND;
            this.adjustToFloor();
            return undefined;
         }
         if(this.getOnWall(this._x + 13,this._y - 30) == false)
         {
            this.fall_anim_count = 0;
            this.state = com.nitrome.toxic.Global.FALL;
            return undefined;
         }
      }
      else if(this.dir == com.nitrome.toxic.Global.LEFT && com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.RIGHT)
      {
         this.vx = 6;
         this.startWallJump();
      }
      else if(this.dir == com.nitrome.toxic.Global.RIGHT && com.nitrome.toxic.Global.DIR_PRESSED == com.nitrome.toxic.Global.LEFT)
      {
         this.vx = -6;
         this.startWallJump();
      }
      else
      {
         this.fall_count = this.fall_count + 1;
         if(this.fall_count >= this.max_fall_count)
         {
            this.fall_anim_count = 0;
            this.state = com.nitrome.toxic.Global.FALL;
            if(this.dir == com.nitrome.toxic.Global.LEFT)
            {
               this.dir = com.nitrome.toxic.Global.RIGHT;
            }
            else if(this.dir == com.nitrome.toxic.Global.RIGHT)
            {
               this.dir = com.nitrome.toxic.Global.LEFT;
            }
         }
      }
   }
   function checkCeiling(v)
   {
      var _loc3_;
      if(this.dir == com.nitrome.toxic.Global.LEFT)
      {
         _loc3_ = -1;
      }
      else if(this.dir == com.nitrome.toxic.Global.RIGHT)
      {
         _loc3_ = 1;
      }
      var _loc4_;
      var _loc2_;
      if(v < 0)
      {
         _loc4_ = this.ceil_boundary._y;
         if(this.getInWall(this._x + 6 * _loc3_,this._y + _loc4_) == true)
         {
            _loc2_ = 1;
            while(_loc2_ < Math.abs(this.jump_vy))
            {
               if(this.getInWall(this._x + 6 * _loc3_,this._y + _loc4_ + _loc2_) == false)
               {
                  this.vy = this.fall_vy;
                  return v + _loc2_;
               }
               _loc2_ = _loc2_ + 1;
            }
         }
         else if(this.getInWall(this._x + 1 * _loc3_,this._y + _loc4_) == true)
         {
            _loc2_ = 1;
            while(_loc2_ < Math.abs(this.jump_vy))
            {
               if(this.getInWall(this._x + 1 * _loc3_,this._y + _loc4_ + _loc2_) == false)
               {
                  this.vy = this.fall_vy;
                  return v + _loc2_;
               }
               _loc2_ = _loc2_ + 1;
            }
         }
         else if(this.getInWall(this._x + 12 * _loc3_,this._y + _loc4_) == true)
         {
            _loc2_ = 1;
            while(_loc2_ < Math.abs(this.jump_vy))
            {
               if(this.getInWall(this._x + 12 * _loc3_,this._y + _loc4_ + _loc2_) == false)
               {
                  this.vy = this.fall_vy;
                  return v + _loc2_;
               }
               _loc2_ = _loc2_ + 1;
            }
         }
         else
         {
            _loc2_ = 1;
            while(_loc2_ < Math.abs(v))
            {
               if(this.getInWall(this._x + 6 * _loc3_,this._y + _loc4_ - _loc2_) == true)
               {
                  this.vy = this.fall_vy;
                  this.hit_ceiling = true;
                  return - _loc2_ - 2;
               }
               if(this.getInWall(this._x + 1 * _loc3_,this._y + _loc4_ - _loc2_) == true)
               {
                  this.vy = this.fall_vy;
                  this.hit_ceiling = true;
                  return - _loc2_ - 2;
               }
               if(this.getInWall(this._x + 12 * _loc3_,this._y + _loc4_ - _loc2_) == true)
               {
                  this.vy = this.fall_vy;
                  this.hit_ceiling = true;
                  return - _loc2_ - 2;
               }
               _loc2_ = _loc2_ + 1;
            }
         }
      }
      return v;
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
   function checkWalls(v, duck)
   {
      var _loc2_;
      if(duck == true)
      {
         _loc2_ = new Array(-2,-5,-10,-15,-20);
      }
      else
      {
         _loc2_ = new Array(-16,-20,-25,-30,-35);
      }
      var _loc6_;
      var _loc5_;
      var _loc4_;
      var _loc7_;
      if(v > 0)
      {
         _loc6_ = this.wall_boundary_right._x;
         if(!(this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[0]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[1]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[2]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[3]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[4]) == true))
         {
            if(Utils.inaccuratePhysics)
            {
               return v;
            }
            _loc5_ = 1;
            while(_loc5_ <= this.max_vx)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  if(this.getInWall(this._x + _loc6_ + _loc5_,this._y + _loc2_[_loc4_]) == true)
                  {
                     this.wall_jump = true;
                     if(v < _loc5_)
                     {
                        return v;
                     }
                     this.vx = 0;
                     return _loc5_ - 1;
                  }
                  _loc4_ = _loc4_ + 1;
               }
               _loc5_ = _loc5_ + 1;
            }
            return v;
         }
         _loc5_ = 1;
         while(_loc5_ <= this.max_vx)
         {
            _loc7_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(this.getInWall(this._x + _loc6_ + v - _loc5_,this._y + _loc2_[_loc4_]) == false)
               {
                  _loc7_ = _loc7_ + 1;
               }
               _loc4_ = _loc4_ + 1;
            }
            if(_loc7_ == _loc2_.length)
            {
               this.vx = v - _loc5_;
               this.wall_jump = true;
               return v - _loc5_;
            }
            _loc5_ = _loc5_ + 1;
         }
      }
      else if(v < 0)
      {
         _loc6_ = this.wall_boundary_left._x;
         if(!(this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[0]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[1]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[2]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[3]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[4]) == true))
         {
            _loc5_ = 1;
            while(_loc5_ <= this.max_vx)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  if(this.getInWall(this._x + _loc6_ - _loc5_,this._y + _loc2_[_loc4_]) == true)
                  {
                     this.wall_jump = true;
                     if(Math.abs(v) < _loc5_)
                     {
                        return v;
                     }
                     this.vx = 0;
                     return - (_loc5_ - 1);
                  }
                  _loc4_ = _loc4_ + 1;
               }
               _loc5_ = _loc5_ + 1;
            }
            return v;
         }
         _loc5_ = 1;
         while(_loc5_ <= this.max_vx)
         {
            _loc7_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(this.getInWall(this._x + _loc6_ + v + _loc5_,this._y + _loc2_[_loc4_]) == false)
               {
                  _loc7_ = _loc7_ + 1;
               }
               _loc4_ = _loc4_ + 1;
            }
            if(_loc7_ == _loc2_.length)
            {
               this.vx = v + _loc5_;
               this.wall_jump = true;
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
   function checkConveyorWalls(v, duck)
   {
      var _loc2_;
      if(duck == true)
      {
         _loc2_ = new Array(-2,-5,-10,-15,-20);
      }
      else
      {
         _loc2_ = new Array(-16,-20,-25,-30,-35);
      }
      var _loc6_;
      var _loc5_;
      var _loc4_;
      var _loc7_;
      if(v > 0)
      {
         _loc6_ = this.wall_boundary_right._x;
         if(!(this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[0]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[1]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[2]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[3]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[4]) == true))
         {
            _loc5_ = 1;
            while(_loc5_ <= this.max_vx)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  if(this.getInWall(this._x + _loc6_ + _loc5_,this._y + _loc2_[_loc4_]) == true)
                  {
                     this.wall_jump = true;
                     if(v < _loc5_)
                     {
                        return v;
                     }
                     return _loc5_ - 1;
                  }
                  _loc4_ = _loc4_ + 1;
               }
               _loc5_ = _loc5_ + 1;
            }
            return v;
         }
         _loc5_ = 1;
         while(_loc5_ <= this.max_vx)
         {
            _loc7_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(this.getInWall(this._x + _loc6_ + v - _loc5_,this._y + _loc2_[_loc4_]) == false)
               {
                  _loc7_ = _loc7_ + 1;
               }
               _loc4_ = _loc4_ + 1;
            }
            if(_loc7_ == _loc2_.length)
            {
               this.wall_jump = true;
               return v - _loc5_;
            }
            _loc5_ = _loc5_ + 1;
         }
      }
      else if(v < 0)
      {
         _loc6_ = this.wall_boundary_left._x;
         if(!(this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[0]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[1]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[2]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[3]) == true || this.getInWall(this._x + _loc6_ + v,this._y + _loc2_[4]) == true))
         {
            _loc5_ = 1;
            while(_loc5_ <= this.max_vx)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  if(this.getInWall(this._x + _loc6_ - _loc5_,this._y + _loc2_[_loc4_]) == true)
                  {
                     this.wall_jump = true;
                     if(Math.abs(v) < _loc5_)
                     {
                        return v;
                     }
                     return - (_loc5_ - 1);
                  }
                  _loc4_ = _loc4_ + 1;
               }
               _loc5_ = _loc5_ + 1;
            }
            return v;
         }
         _loc5_ = 1;
         while(_loc5_ <= this.max_vx)
         {
            _loc7_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(this.getInWall(this._x + _loc6_ + v + _loc5_,this._y + _loc2_[_loc4_]) == false)
               {
                  _loc7_ = _loc7_ + 1;
               }
               _loc4_ = _loc4_ + 1;
            }
            if(_loc7_ == _loc2_.length)
            {
               this.wall_jump = true;
               return v + _loc5_;
            }
            _loc5_ = _loc5_ + 1;
         }
      }
      else
      {
         return 0;
      }
   }
   function adjustToFloor()
   {
      var _loc3_;
      var _loc2_;
      if(this.left_edge == true)
      {
         if(this.getInGround(this.rx,this._y) == true)
         {
            if(this.vy >= 0)
            {
               _loc3_ = false;
               _loc2_ = 1;
               while(_loc2_ <= this.max_slope)
               {
                  if(this.getOnGround(this.rx,this._y - _loc2_) == true)
                  {
                     this._y -= _loc2_;
                     _loc3_ = true;
                     break;
                  }
                  _loc2_ = _loc2_ + 1;
               }
               if(_loc3_ == false)
               {
                  _loc2_ = 1;
                  while(_loc2_ <= 100)
                  {
                     if(this.getOnGround(this.rx,this._y - _loc2_) == true)
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
      }
      else if(this.right_edge == true)
      {
         if(this.getInGround(this.lx,this._y) == true)
         {
            if(this.vy >= 0)
            {
               _loc3_ = false;
               _loc2_ = 1;
               while(_loc2_ <= this.max_slope)
               {
                  if(this.getOnGround(this.lx,this._y - _loc2_) == true)
                  {
                     this._y -= _loc2_;
                     _loc3_ = true;
                     break;
                  }
                  _loc2_ = _loc2_ + 1;
               }
               if(_loc3_ == false)
               {
                  _loc2_ = 1;
                  while(_loc2_ <= 100)
                  {
                     if(this.getOnGround(this.lx,this._y - _loc2_) == true)
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
      }
      else if(this.getInGround(this._x,this._y) == true)
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
            if(_loc3_ == false)
            {
               _loc2_ = 1;
               while(_loc2_ <= 100)
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
   }
   function getOnWall(x, y)
   {
      if(this.dir == com.nitrome.toxic.Global.LEFT)
      {
         if(this.game.getSceneryCollision(x,y) == true)
         {
            if(this.game.getSceneryCollision(x + 1,y) == false)
            {
               return true;
            }
            return false;
         }
      }
      else if(this.dir == com.nitrome.toxic.Global.RIGHT)
      {
         if(this.game.getSceneryCollision(x,y) == true)
         {
            if(this.game.getSceneryCollision(x - 1,y) == false)
            {
               return true;
            }
            return false;
         }
      }
      return false;
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
   function getInAir(x, y)
   {
      if(this.game.getSceneryCollision(x,y) == false)
      {
         if(this.game.getSceneryCollision(x,y - 1) == false)
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
            if(this.state == com.nitrome.toxic.Global.DUCK && this.game.getWalkerBombs() == true)
            {
               this.gotoAndStop(com.nitrome.toxic.Global.state_string[this.state] + "trigger_" + com.nitrome.toxic.Global.dir_string[this.dir]);
            }
            else
            {
               _root._gotoAndStop(this,com.nitrome.toxic.Global.state_string[this.state] + com.nitrome.toxic.Global.dir_string[this.dir],2121);
            }
         }
         this.prev_dir = this.dir;
         this.prev_state = this.state;
      }
      if(this.hit == true)
      {
         this.gotoAndStop(com.nitrome.toxic.Global.state_string[com.nitrome.toxic.Global.HIT] + com.nitrome.toxic.Global.dir_string[this.dir]);
      }
   }
   function getDir()
   {
      return this.dir;
   }
   function getState()
   {
      return this.state;
   }
   function getBombType()
   {
      return this.bomb_type;
   }
   function getVX()
   {
      return this.vx;
   }
   function getVY()
   {
      return this.vy;
   }
}
