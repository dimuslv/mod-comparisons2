class com.nitrome.toxic.FishRobot extends MovieClip
{
   var anim;
   var game;
   var debris = new Array({id:97,x:4,y:147},{id:96,x:23,y:109},{id:95,x:-18,y:105},{id:94,x:30,y:67},{id:93,x:-26,y:75},{id:92,x:20,y:27},{id:91,x:-18,y:31});
   function FishRobot()
   {
      super();
      this.anim.gotoAndPlay(random(120) + 1);
   }
   function init(game)
   {
      this.game = game;
   }
   function doExplode()
   {
      this.game.createExplosion(this._x,this._y + this.anim.anim._y,this._name,100);
      this.game.createDebris(this._x,this._y + this.anim.anim._y,this.debris);
      this.removeMovieClip();
   }
   function doSplash()
   {
      this.game.doSplash(this._x,this._y - 40);
   }
   function doPause()
   {
      this.anim.stop();
      this.anim.anim.stop();
   }
   function doUnpause()
   {
      this.anim.play();
      this.anim.anim.play();
   }
}
