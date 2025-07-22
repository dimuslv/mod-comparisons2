class com.nitrome.toxic.TitleScreenAnim extends MovieClip
{
   var acid_holder;
   var pipes;
   var big_pipes;
   var scroll_x = 0;
   function TitleScreenAnim()
   {
      super();
      this.acid_holder.acid_clip._x = 0;
      this.acid_holder.acid_clip._y = 340;
      this.acid_holder.smoke_bubble_holder._x = 0;
      this.acid_holder.smoke_bubble_holder._y = 340;
      this.acid_holder.wall_overlay._y = 209;
      this.acid_holder.wall_overlay._width = 550;
   }
   function onEnterFrame()
   {
      this.scroll_x -= 1;
      if(this.scroll_x < -1100)
      {
         this.scroll_x += 1100;
      }
      this.pipes._x -= 1;
      if(this.pipes._x < -550)
      {
         this.pipes._x += 550;
      }
      this.big_pipes._x -= 2;
      if(this.big_pipes._x < -1100)
      {
         this.big_pipes._x += 1100;
      }
      var _loc3_ = Math.abs(this.scroll_x % 32);
      this.acid_holder.acid_clip._x = - _loc3_;
      var _loc2_ = this.scroll_x;
      if(_loc2_ < -1100)
      {
         _loc2_ += 550;
      }
      if(_loc2_ > -550)
      {
         _loc2_ -= 550;
      }
      this.acid_holder.smoke_bubble_holder._x = _loc2_;
   }
}
