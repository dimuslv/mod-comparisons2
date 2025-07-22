class com.nitrome.toxic.DiggerRobot extends MovieClip
{
   var game;
   var anim;
   var player;
   var falling = false;
   var y_speed = 5;
   var done_splash = false;
   var debris = new Array({id:52,x:0,y:-5},{id:53,x:0,y:-27});
   function DiggerRobot()
   {
      super();
   }
   function init(game)
   {
      this.game = game;
   }
   function doPause()
   {
      this.anim.stop();
   }
   function doUnpause()
   {
      this.anim.play();
   }
   function setPlayer(player)
   {
      this.player = player;
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
         this.doFall();
      }
      else if(this.getOnSolidGround(this._x,this._y) == false)
      {
         this.checkForPlayer();
      }
   }
   function checkForPlayer()
   {
      var _loc2_;
      if(this.player._y > this._y)
      {
         if(this.player._x > this._x - 20 && this.player._x < this._x + 20)
         {
            _loc2_ = 10;
            while(_loc2_ <= 500)
            {
               if(this.getInWall(this._x,this._y + _loc2_) == true)
               {
                  break;
               }
               _loc2_ += 10;
            }
            if(this.player._y < this._y + _loc2_)
            {
               this.startFall();
            }
         }
      }
   }
   function startFall()
   {
      this.falling = true;
   }
   function doFall()
   {
      this._y += this.checkFloor(this.y_speed);
      this.game.cutDiggerRobotHole(this._x,this._y);
      if(this.getOnSolidGround(this._x,this._y) == true)
      {
         this.falling = false;
         this.doExplode();
      }
      else
      {
         this.checkFallOff();
      }
   }
   function doExplode()
   {
      this.game.createExplosion(this._x,this._y,this._name,100);
      this.game.createDebris(this._x,this._y,this.debris);
      this.removeMovieClip();
   }
   function checkFloor(v)
   {
      v = Math.round(v);
      var _loc2_ = 1;
      while(_loc2_ <= v)
      {
         if(this.getInSolidWall(this._x,this._y + _loc2_) == true)
         {
            return _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
      return v;
   }
   function getInSolidWall(x, y)
   {
      if(this.game.getSolidCollision(x,y) == true)
      {
         return true;
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
   function getOnSolidGround(x, y)
   {
      if(this.game.getSolidCollision(x,y) == true)
      {
         if(this.game.getSolidCollision(x,y - 1) == false)
         {
            return true;
         }
         return false;
      }
      return false;
   }
   function getOnScreen()
   {
      if(this.hitTest(_root.screen_test) == true)
      {
         return true;
      }
      return false;
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
