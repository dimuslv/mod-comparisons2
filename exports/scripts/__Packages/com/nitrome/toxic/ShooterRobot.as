class com.nitrome.toxic.ShooterRobot extends MovieClip
{
   var game;
   var anim;
   var bullet_left;
   var bullet_right;
   var debris = new Array({id:98,x:-14,y:-10},{id:99,x:14,y:-11});
   var chid = 2183;
   function ShooterRobot()
   {
      super();
   }
   function init(game)
   {
      this.game = game;
   }
   function doPause()
   {
      _root._stop(this.anim);
   }
   function doUnpause()
   {
      _root._play(this.anim);
   }
   function doFire()
   {
      this.game.fireShooterBullet(this._x + this.bullet_left._x,this._y + this.bullet_left._y,0);
      this.game.fireShooterBullet(this._x + this.bullet_right._x,this._y + this.bullet_right._y,1);
   }
   function doExplode()
   {
      this.game.createExplosion(this._x,this._y,this._name,100);
      this.game.createDebris(this._x,this._y,this.debris);
      this.removeMovieClip();
   }
}
