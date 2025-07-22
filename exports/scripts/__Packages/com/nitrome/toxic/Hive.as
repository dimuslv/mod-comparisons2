class com.nitrome.toxic.Hive extends MovieClip
{
   var game;
   var left_spawn;
   var right_spawn;
   var spawn_count = 0;
   var max_spawn_count = 100;
   var debris = new Array({id:14,x:-7,y:-13},{id:15,x:10,y:-20},{id:16,x:-2,y:-36});
   function Hive()
   {
      super();
   }
   function init(game)
   {
      this.game = game;
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
      this.spawn_count = this.spawn_count + 1;
      if(this.spawn_count >= this.max_spawn_count)
      {
         this.trySpawn();
         this.spawn_count = 0;
      }
   }
   function trySpawn()
   {
      var _loc4_ = this.game.getSpawnCount(this._name);
      var _loc3_ = this.game.getSpawnCountLeft(this._name);
      var _loc2_ = this.game.getSpawnCountRight(this._name);
      var _loc5_;
      if(_loc4_ < 6)
      {
         if(_loc3_ < 3 && _loc2_ < 3)
         {
            _loc5_ = random(2);
            this.spawnBot(_loc5_);
         }
         else if(_loc2_ == 3 && _loc3_ < 3)
         {
            this.spawnBot(0);
         }
         else if(_loc3_ == 3 && _loc2_ < 3)
         {
            this.spawnBot(1);
         }
      }
   }
   function spawnBot(dir)
   {
      var _loc3_;
      var _loc2_;
      if(dir == 0)
      {
         _loc3_ = this._x + this.left_spawn._x;
         _loc2_ = this._y + this.left_spawn._y;
      }
      else if(dir == 1)
      {
         _loc3_ = this._x + this.right_spawn._x;
         _loc2_ = this._y + this.right_spawn._y;
      }
      this.game.spawnBot(this._name,_loc3_,_loc2_,dir);
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
}
