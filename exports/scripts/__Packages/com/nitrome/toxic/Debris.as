class com.nitrome.toxic.Debris extends MovieClip
{
   var game;
   var vx;
   var vy;
   var vr;
   function Debris()
   {
      super();
   }
   function init(game)
   {
      this.game = game;
      this.vx = random(10) - 5;
      this.vy = - random(20);
      this.vr = random(10) - 5;
   }
   function main()
   {
      this._x += this.vx;
      this._y += this.vy;
      this._rotation += this.vr;
      this.vx *= 0.95;
      this.vy = this.vy + 1;
      if(this.hitTest(_root.screen_test) == false || this._y > com.nitrome.toxic.Global.level_height)
      {
         this.game.removeDebris(this._name);
         this.removeMovieClip();
      }
   }
}
