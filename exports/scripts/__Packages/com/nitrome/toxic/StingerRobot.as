class com.nitrome.toxic.StingerRobot extends MovieClip
{
   var anim;
   var game;
   var player;
   var animstate;
   var xspeed;
   var yspeed;
   var right_boundary;
   var left_boundary;
   var bottom_boundary;
   var top_boundary;
   var prev_animstate = 100;
   var WAIT = 0;
   var FLY = 1;
   var PAUSE = 2;
   var STING = 3;
   var FLYAWAY = 4;
   var GROUND = 5;
   var anims = new Array("wait","fly","pause","sting","flyaway","ground");
   var max_speed = 2;
   var max_sting_speed = 10;
   var vx = 0;
   var vy = 0;
   var pause_count = 0;
   var max_pause_count = 20;
   var wait_count = 0;
   var max_wait_count = 30;
   var ground_count = 0;
   var max_ground_count = 40;
   var hit = false;
   var debris = new Array({id:90,x:2,y:-13},{id:88,x:-1,y:-29},{id:87,x:0,y:-50},{id:89,x:0,y:-62});
   function StingerRobot()
   {
      super();
   }
   function doPause()
   {
      this.anim.stop();
      this.anim.clip.stop();
      this.anim.fan.stop();
      this.anim.fan2.stop();
   }
   function doUnpause()
   {
      this.anim.play();
      this.anim.clip.play();
      this.anim.fan.play();
      this.anim.fan2.play();
   }
   function init(game, player)
   {
      this.game = game;
      this.player = player;
      this.animstate = this.WAIT;
      this.updateAnim();
   }
   function setPlayer(player)
   {
      this.player = player;
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
      this.game.createExplosion(this._x,this._y,this._name,100);
      this.game.createDebris(this._x,this._y,this.debris);
      this.removeMovieClip();
   }
   function main()
   {
      if(this.getOnScreen() == true)
      {
         this._visible = true;
         this.updateAnim();
         if(this.animstate == this.WAIT)
         {
            this.wait_count = this.wait_count + 1;
            if(this.wait_count >= this.max_wait_count)
            {
               this.checkForPlayer();
               this.animstate = this.FLY;
            }
         }
         else if(this.animstate == this.FLY)
         {
            this.doFly();
         }
         else if(this.animstate == this.PAUSE)
         {
            this.pause_count = this.pause_count + 1;
            if(this.pause_count >= this.max_pause_count)
            {
               this.animstate = this.STING;
            }
         }
         else if(this.animstate == this.STING)
         {
            this.doSting();
         }
         else if(this.animstate == this.FLYAWAY)
         {
            this.doFlyAway();
         }
         else if(this.animstate == this.GROUND)
         {
            this.ground_count = this.ground_count + 1;
            if(this.ground_count >= this.max_ground_count)
            {
               this.pause_count = 0;
               this.animstate = this.FLYAWAY;
            }
         }
      }
      else
      {
         this._visible = false;
      }
   }
   function checkForPlayer()
   {
      this.xspeed = (this.player._x - this._x) / 30;
      this.yspeed = (this.player._y - 100 - this._y) / 30;
   }
   function doFly()
   {
      this.hit = false;
      this._x += this.checkVertWalls(this.xspeed);
      this._y += this.checkHorizWalls(this.yspeed);
      if(this.hit == true)
      {
         this.wait_count = 0;
         this.animstate = this.WAIT;
      }
      if(this._x > this.player._x - 25 && this._x < this.player._x + 25 && this._y < this.player._y && this._y > this.player._y - 120)
      {
         this.yspeed = 0;
         this.animstate = this.PAUSE;
      }
   }
   function doSting()
   {
      this.yspeed = this.yspeed + 1;
      if(this.yspeed > this.max_sting_speed)
      {
         this.yspeed = this.max_sting_speed;
      }
      this.hit = false;
      this._y += this.checkHorizWalls(this.yspeed);
      if(this.hit == true)
      {
         this.ground_count = 0;
         this.animstate = this.GROUND;
      }
   }
   function doFlyAway()
   {
      this.yspeed = -2;
      this.hit = false;
      this._y += this.checkHorizWalls(this.yspeed);
      if(this.hit == true)
      {
         this.pause_count = 0;
         this.animstate = this.WAIT;
         return undefined;
      }
      this.pause_count = this.pause_count + 1;
      if(this.pause_count >= this.max_pause_count)
      {
         this.pause_count = 0;
         this.animstate = this.WAIT;
      }
   }
   function updateAnim()
   {
      if(this.animstate != this.prev_animstate)
      {
         this.gotoAndStop(this.anims[this.animstate]);
      }
      this.prev_animstate = this.animstate;
   }
   function checkVertWalls(v)
   {
      var _loc4_;
      var _loc6_;
      var _loc3_;
      var _loc2_;
      if(v != 0)
      {
         if(v > 0)
         {
            _loc4_ = new Array(-64,-60,-56,-52,-48,-44,-40,-36,-32,-28,-24,-20,-16,-12,-8,-4,-2);
            _loc6_ = this._x + this.right_boundary._x;
            _loc3_ = 0;
            while(_loc3_ < Math.abs(v))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  if(this.game.getSceneryCollision(_loc6_ + _loc3_,this._y + _loc4_[_loc2_]) == true)
                  {
                     this.hit = true;
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
            _loc4_ = new Array(-64,-60,-56,-52,-48,-44,-40,-36,-32,-28,-24,-20,-16,-12,-8,-4,-2);
            _loc6_ = this._x + this.left_boundary._x;
            _loc3_ = 0;
            while(_loc3_ < Math.abs(v))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  if(this.game.getSceneryCollision(_loc6_ - _loc3_,this._y + _loc4_[_loc2_]) == true)
                  {
                     this.hit = true;
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
      var _loc4_;
      var _loc6_;
      var _loc3_;
      var _loc2_;
      if(v != 0)
      {
         if(v > 0)
         {
            _loc4_ = new Array(-16,-14,-12,-10,-8,-6,-4,-2,0,2,4,6,8,10,12,14,16);
            _loc6_ = this._y + this.bottom_boundary._y;
            _loc3_ = 0;
            while(_loc3_ < Math.abs(v))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  if(this.game.getSceneryCollision(this._x + _loc4_[_loc2_],_loc6_ + _loc3_) == true)
                  {
                     this.hit = true;
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
            _loc4_ = new Array(-16,-14,-12,-10,-8,-6,-4,-2,0,2,4,6,8,10,12,14,16);
            _loc6_ = this._y + this.top_boundary._y;
            _loc3_ = 0;
            while(_loc3_ < Math.abs(v))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  if(this.game.getSceneryCollision(this._x + _loc4_[_loc2_],_loc6_ - _loc3_) == true)
                  {
                     this.hit = true;
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
