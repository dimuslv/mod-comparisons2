class com.nitrome.toxic.ZapperRobot extends MovieClip
{
   var game;
   var drawing_clip;
   var zapper_clip;
   var rot = 0;
   var rot_dir = 2;
   var max_rot = 80;
   var state = 0;
   var zap_count = 0;
   var max_zap_count = 10;
   var wait_count = 0;
   var max_wait_count = 30;
   function ZapperRobot()
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
         if(this.state == 0)
         {
            this.doRotate();
            this.checkBombs();
         }
         else if(this.state == 1)
         {
            this.zap_count = this.zap_count + 1;
            if(this.zap_count >= this.max_zap_count)
            {
               this.clearZap();
               this.wait_count = 0;
               this.state = 2;
            }
         }
         else if(this.state == 2)
         {
            this.wait_count = this.wait_count + 1;
            if(this.wait_count >= this.max_wait_count)
            {
               this.state = 0;
            }
         }
      }
      else
      {
         this._visible = false;
      }
   }
   function checkBombs()
   {
      var _loc8_ = false;
      var _loc7_ = this.rot + 90;
      if(_loc7_ < 0)
      {
         _loc7_ += 360;
      }
      if(_loc7_ >= 360)
      {
         _loc7_ -= 360;
      }
      var _loc2_ = 0;
      var _loc6_;
      var _loc5_;
      var _loc4_;
      var _loc3_;
      while(_loc2_ <= 600)
      {
         _loc6_ = _loc2_ * com.nitrome.toxic.TrigLookup.cos_data[_loc7_];
         _loc5_ = _loc2_ * com.nitrome.toxic.TrigLookup.sin_data[_loc7_];
         _loc4_ = Math.round(this._x + _loc6_);
         _loc3_ = Math.round(this._y + _loc5_);
         if(_loc4_ < 0 || _loc4_ > com.nitrome.toxic.Global.level_width || _loc3_ < 0 || _loc3_ > com.nitrome.toxic.Global.level_height)
         {
            _loc8_ = false;
            break;
         }
         if(this.game.getBombCollision(_loc4_,_loc3_) == true)
         {
            _loc8_ = true;
            break;
         }
         _loc2_ += 5;
      }
      if(_loc8_ == true)
      {
         this.game.zapBomb(_loc4_,_loc3_);
         this.doZap(_loc6_,_loc5_);
      }
   }
   function doZap(xpos, ypos)
   {
      this.drawing_clip.clear();
      this.drawing_clip.lineStyle(1,16724103,100,true);
      this.drawing_clip.moveTo(0,0);
      this.drawing_clip.lineTo(xpos,ypos);
      this.zap_count = 0;
      this.state = 1;
   }
   function clearZap()
   {
      this.drawing_clip.clear();
   }
   function doRotate()
   {
      this.rot += this.rot_dir;
      if(this.rot_dir == 2)
      {
         if(this.rot == this.max_rot)
         {
            this.rot_dir = -2;
         }
      }
      else if(this.rot_dir == -2)
      {
         if(this.rot == - this.max_rot)
         {
            this.rot_dir = 2;
         }
      }
      this.zapper_clip._rotation = this.rot;
   }
   function getOnScreen()
   {
      if(this.hitTest(_root.screen_test) == true)
      {
         return true;
      }
      return false;
   }
}
