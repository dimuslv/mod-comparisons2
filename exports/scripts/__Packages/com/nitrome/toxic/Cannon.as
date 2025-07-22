class com.nitrome.toxic.Cannon extends MovieClip
{
   var anim;
   var game;
   var dir;
   var bullet_point;
   var tall = false;
   var debris_right = new Array({id:21,x:6,y:-33},{id:22,x:-12,y:-42},{id:17,x:0,y:-14});
   var debris_left = new Array({id:19,x:-6,y:-33},{id:20,x:13,y:-42},{id:17,x:0,y:-14});
   var debris_tall_right = new Array({id:21,x:5,y:-49},{id:22,x:-12,y:-58},{id:18,x:0,y:-20});
   var debris_tall_left = new Array({id:19,x:-5,y:-49},{id:20,x:13,y:-58},{id:18,x:0,y:-20});
   var chid = 880;
   function Cannon()
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
   function init(game, dir, tall)
   {
      this.game = game;
      this.dir = dir;
      this.tall = tall;
      if(tall)
      {
         this.chid = 2287;
      }
      this.updateAnim();
   }
   function doFire()
   {
      this.game.fireBullet(this._x + this.bullet_point._x,this._y + this.bullet_point._y,this.dir);
   }
   function main()
   {
      this._visible = this.getOnScreen();
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
      if(this.dir == 0)
      {
         this.gotoAndStop("left");
      }
      else if(this.dir == 1)
      {
         this.gotoAndStop("right");
      }
   }
   function doExplode()
   {
      this.game.createExplosion(this._x,this._y,this._name,100);
      if(this.tall == true)
      {
         if(this.dir == 0)
         {
            this.game.createDebris(this._x,this._y,this.debris_tall_left);
         }
         else if(this.dir == 1)
         {
            this.game.createDebris(this._x,this._y,this.debris_tall_right);
         }
      }
      else if(this.dir == 0)
      {
         this.game.createDebris(this._x,this._y,this.debris_left);
      }
      else if(this.dir == 1)
      {
         this.game.createDebris(this._x,this._y,this.debris_right);
      }
      this.removeMovieClip();
   }
}
