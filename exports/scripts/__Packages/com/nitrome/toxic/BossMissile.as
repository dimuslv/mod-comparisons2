class com.nitrome.toxic.BossMissile extends MovieClip
{
   var game;
   var deg;
   var start_x;
   var start_y;
   var distance = 0;
   var speed = 8;
   function BossMissile()
   {
      super();
   }
   function init(game, deg)
   {
      this.game = game;
      this.deg = deg - 90;
      if(this.deg < 0)
      {
         this.deg += 360;
      }
      if(this.deg >= 360)
      {
         this.deg -= 360;
      }
      this.speed = 8;
      this._rotation = deg;
      this.start_x = this._x;
      this.start_y = this._y;
      this.distance = 0;
   }
   function main()
   {
      this.distance += this.speed;
      var _loc3_ = this.start_x + this.distance * com.nitrome.toxic.TrigLookup.cos_data[this.deg];
      var _loc2_ = this.start_y + this.distance * com.nitrome.toxic.TrigLookup.sin_data[this.deg];
      this._x = _loc3_;
      this._y = _loc2_;
      if(this._x < 0 || this._x > com.nitrome.toxic.Global.level_width || this._y < 0 || this._y > com.nitrome.toxic.Global.level_height)
      {
         this.game.removeMissile(this._name);
         this.removeMovieClip();
      }
   }
}
