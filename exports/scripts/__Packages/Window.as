class Window extends MovieClip
{
   var obj;
   var mainIndices;
   var mainBehaviors;
   var mainTextField;
   var minimized = false;
   var _static = false;
   function Window()
   {
      super();
   }
   function init(x, y, obj)
   {
      this._x = x;
      this._y = y;
      var _loc5_ = this.createTextField("mainTextField",this.getNextHighestDepth(),0,0,0,20);
      _loc5_.background = true;
      _loc5_.autoSize = true;
      this.updateMainField(obj);
   }
   function updateMainField(obj)
   {
      if(obj)
      {
         this.obj = obj;
      }
      else
      {
         obj = this.obj;
      }
      this.mainIndices = [0];
      this.mainBehaviors = [Windows.startDragging];
      this.mainTextField.text = obj.title + " ";
      this.mainIndices.push(this.mainTextField.text.length);
      this.mainBehaviors.push(obj.customMinimize ? obj.customMinimize : Windows.minimizeWindow);
      this.mainTextField.text += this.minimized ? "🗖 " : "🗕 ";
      this.mainIndices.push(this.mainTextField.text.length);
      this.mainBehaviors.push(Windows.closeWindow);
      this.mainTextField.text += "🗙";
      var _loc3_;
      if(!this.minimized && obj.options)
      {
         _loc3_ = 0;
         while(_loc3_ < obj.options.length)
         {
            this.mainTextField.text += "\n";
            this.mainIndices.push(this.mainTextField.text.length);
            this.mainBehaviors.push(obj.options[_loc3_ + 1]);
            this.mainTextField.text += obj.options[_loc3_];
            _loc3_ += 2;
         }
      }
   }
}
