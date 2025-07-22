class com.nitrome.buttons.SecretLevelButton extends com.nitrome.buttons.SimpleButton
{
   var onKeyDown;
   var done = false;
   function SecretLevelButton()
   {
      super();
      this.clearKeyListener();
      this.onKeyDown = function()
      {
         if(Key.getCode() == 32)
         {
            this.doPress();
         }
      };
      Key.addListener(this);
   }
   function doPress()
   {
      if(this.done == false)
      {
         com.nitrome.toxic.Global.secret_id = 1;
         _root.tt.doTween("reload");
         this.clearKeyListener();
         this.done = true;
      }
   }
   function clearKeyListener()
   {
      Key.removeListener(this);
   }
}
