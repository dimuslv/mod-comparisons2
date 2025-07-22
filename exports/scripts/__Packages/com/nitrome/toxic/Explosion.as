class com.nitrome.toxic.Explosion extends MovieClip
{
   var game;
   var bomb_type;
   var bomb_dir;
   var chid;
   function Explosion()
   {
      super();
   }
   function init(game, bomb_type, bomb_dir)
   {
      this.game = game;
      this.bomb_type = bomb_type;
      this.bomb_dir = bomb_dir;
      if(bomb_type == 1)
      {
         this.chid = 1373;
      }
      else if(bomb_type == 2)
      {
         this.chid = 1398;
      }
      else if(bomb_type == 5)
      {
         this.chid = 1467;
      }
      else
      {
         this.chid = 1421;
      }
   }
   function cutHole()
   {
      this.game.cutHole(this._x,this._y,this._name);
      var _loc2_;
      if(this.bomb_type == 3)
      {
         _loc2_ = this._name.split("*");
         if(Number(_loc2_[_loc2_.length - 1]) >= 1)
         {
            this.game.cutDiggerHole(this._x,this._y,this._name,this.bomb_dir);
         }
      }
   }
   function cutBossHole()
   {
      this.game.cutBossHole(this._x,this._y,this._name);
   }
   function checkRobots()
   {
      var _loc4_ = new Object();
      _loc4_.xMin = this._x - 60;
      _loc4_.xMax = this._x + 60;
      _loc4_.yMin = this._y - 60;
      _loc4_.yMax = this._y + 60;
      _global.img2 = new flash.display.BitmapData(_loc4_.xMax - _loc4_.xMin,_loc4_.yMax - _loc4_.yMin,false);
      var _loc5_ = new flash.geom.Matrix();
      _loc5_.tx -= _loc4_.xMin;
      _loc5_.ty -= _loc4_.yMin;
      _global.img2.draw(_root.game.danger_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
      _global.img2.draw(_root.game.explosion_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,255,255,255),"difference");
      var _loc6_ = _global.img2.getColorBoundsRect(4294967295,4278255615);
      if(_loc6_.width != 0)
      {
         this.game.findExplodeRobot(this._name);
      }
      _global.img2.dispose();
      delete _global.img2;
      _global.img3 = new flash.display.BitmapData(_loc4_.xMax - _loc4_.xMin,_loc4_.yMax - _loc4_.yMin,false);
      _global.img3.draw(_root.game.object_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
      _global.img3.draw(_root.game.explosion_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,255,255,255),"difference");
      _loc6_ = _global.img3.getColorBoundsRect(4294967295,4278255615);
      if(_loc6_.width != 0)
      {
         this.game.findExplodeHoloButton(this._name);
      }
      _global.img3.dispose();
      delete _global.img3;
      if(this.game.getFinalBoss() == true)
      {
         _global.img4 = new flash.display.BitmapData(_loc4_.xMax - _loc4_.xMin,_loc4_.yMax - _loc4_.yMin,false);
         _global.img4.draw(_root.game.heart_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
         _global.img4.draw(_root.game.explosion_holder,_loc5_,new flash.geom.ColorTransform(1,1,1,1,255,255,255,255),"difference");
         _loc6_ = _global.img4.getColorBoundsRect(4294967295,4278255615);
         if(_loc6_.width != 0)
         {
            this.game.hitFinalBoss();
         }
         _global.img4.dispose();
         delete _global.img4;
      }
      this.game.checkFirstInfoPoint();
   }
   function finishExplode()
   {
      this.removeMovieClip();
   }
}
