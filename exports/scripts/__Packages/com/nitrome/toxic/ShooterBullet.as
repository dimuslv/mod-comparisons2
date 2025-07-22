class com.nitrome.toxic.ShooterBullet extends MovieClip
{
   var game;
   var dir;
   var x_speed;
   var y_speed;
   var left_boundary;
   var right_boundary;
   var bottom_boundary;
   var GRAVITY = 1;
   var INERTIA = 0.96;
   var finished = false;
   var chid = 2170;
   function ShooterBullet()
   {
      super();
   }
   function init(game, dir)
   {
      this.game = game;
      this.dir = dir;
      if(dir == com.nitrome.toxic.Global.LEFT)
      {
         this.x_speed = -8;
         this.y_speed = -10;
      }
      else if(dir == com.nitrome.toxic.Global.RIGHT)
      {
         this.x_speed = 8;
         this.y_speed = -10;
      }
   }
   function main()
   {
      this._visible = this.getOnScreen();
      if(this.finished == false)
      {
         this._x += this.x_speed;
         this._y += this.y_speed;
         this.checkCollision();
      }
      this.x_speed *= this.INERTIA;
      this.y_speed += this.GRAVITY;
   }
   function getOnScreen()
   {
      if(this.hitTest(_root.screen_test) == true)
      {
         return true;
      }
      return false;
   }
   function checkCollision()
   {
      var _loc2_;
      if(this.dir == com.nitrome.toxic.Global.LEFT)
      {
         _loc2_ = this.left_boundary._x;
      }
      else if(this.dir == com.nitrome.toxic.Global.RIGHT)
      {
         _loc2_ = this.right_boundary._x;
      }
      var _loc3_ = this.bottom_boundary._y;
      if(this.game.getSceneryCollision(this._x + _loc2_,this._y) == true)
      {
         this.gotoAndStop("finished");
         this.finished = true;
      }
      else if(this.game.getSceneryCollision(this._x,this._y + _loc3_) == true)
      {
         this.gotoAndStop("finished");
         this.finished = true;
      }
      else if(this.dir == com.nitrome.toxic.Global.LEFT && this._x < -20)
      {
         this.gotoAndStop("finished");
         this.finished = true;
      }
      else if(this.dir == com.nitrome.toxic.Global.RIGHT && this._x > com.nitrome.toxic.Global.level_width + 20)
      {
         this.gotoAndStop("finished");
         this.finished = true;
      }
   }
   function finishFire()
   {
      this.game.removeBullet(this._name);
      this.removeMovieClip();
   }
}
