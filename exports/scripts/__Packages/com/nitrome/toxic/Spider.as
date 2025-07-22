class com.nitrome.toxic.Spider extends MovieClip
{
   var tween_up;
   var tween_down;
   var anim;
   var game;
   var state;
   var prev_state;
   var top_boundary;
   var bottom_boundary;
   var states = new Array("","","up","down");
   var debris = new Array({id:23,x:0,y:-78},{id:34,x:62,y:-37},{id:35,x:-64,y:-37},{id:24,x:44,y:-78},{id:25,x:-44,y:-81},{id:26,x:66,y:-81},{id:27,x:-64,y:-81},{id:28,x:105,y:-64},{id:29,x:-102,y:-65},{id:30,x:95,y:-77},{id:31,x:-94,y:-76},{id:32,x:129,y:-32},{id:33,x:-127,y:-32});
   var started = false;
   var chid = 2205;
   function Spider()
   {
      super();
   }
   function doClear()
   {
      this.tween_up.onMotionFinished = null;
      this.tween_down.onMotionFinished = null;
      this.tween_up.stop();
      this.tween_down.stop();
      this.tween_up = null;
      this.tween_down = null;
      delete this.tween_up;
      delete this.tween_down;
   }
   function doPause()
   {
      this.tween_up.stop();
      this.tween_down.stop();
      _root._stop(this.anim.leg1);
      _root._stop(this.anim.leg2);
      _root._stop(this.anim.leg3);
      _root._stop(this.anim.leg4);
   }
   function doUnpause()
   {
      this.tween_up.resume();
      this.tween_down.resume();
      _root._play(this.anim.leg1);
      _root._play(this.anim.leg2);
      _root._play(this.anim.leg3);
      _root._play(this.anim.leg4);
   }
   function init(game)
   {
      this.game = game;
   }
   function main()
   {
      if(this.started == false)
      {
         this.calculateUp();
         this.started = true;
      }
      if(this.getOnScreen() == true)
      {
         this._visible = true;
      }
      else
      {
         this._visible = false;
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
   function calculateUp()
   {
      this.tween_down = null;
      this.state = com.nitrome.toxic.Global.UP;
      this.updateAnim();
      var _loc2_ = this.findTop() + 32;
      var _loc3_ = Math.round(this._y - _loc2_) * 0.5;
      this.tween_up = new mx.transitions.Tween(this,"_y",mx.transitions.easing.None.easeOut,this._y,_loc2_,_loc3_,false);
      this.tween_up.onMotionFinished = mx.utils.Delegate.create(this,this.calculateDown);
      this.tween_up.start();
   }
   function calculateDown()
   {
      this.tween_up = null;
      this.state = com.nitrome.toxic.Global.DOWN;
      this.updateAnim();
      var _loc2_ = this.findBottom();
      var _loc3_ = Math.round((_loc2_ - this._y) * 0.2);
      this.tween_down = new mx.transitions.Tween(this,"_y",mx.transitions.easing.Strong.easeOut,this._y,_loc2_,_loc3_,false);
      this.tween_down.onMotionFinished = mx.utils.Delegate.create(this,this.calculateUp);
      this.tween_up.start();
   }
   function updateAnim()
   {
      if(this.state != this.prev_state)
      {
         this.gotoAndStop(this.states[this.state]);
      }
      this.prev_state = this.state;
   }
   function findTop()
   {
      var _loc2_ = 0;
      while(_loc2_ <= 600)
      {
         if(this.game.getSceneryCollision(this._x,this._y + this.top_boundary._y - _loc2_) == true)
         {
            return this._y - _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function findBottom()
   {
      var _loc2_ = 0;
      while(_loc2_ <= 600)
      {
         if(this.game.getSceneryCollision(this._x,this._y + this.bottom_boundary._y + _loc2_) == true)
         {
            return this._y + _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function doExplode()
   {
      this.game.createExplosion(this._x,this._y,this._name,100);
      this.game.createDebris(this._x,this._y,this.debris);
      this.removeMovieClip();
   }
}
