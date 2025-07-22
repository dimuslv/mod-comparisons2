class com.nitrome.highscore.SubmitButton extends MovieClip
{
   var pressed = false;
   var disabled = true;
   function SubmitButton()
   {
      super();
      this.pressed = false;
      this.gotoAndStop("disabled");
   }
   function onRelease()
   {
      if(this.disabled == true)
      {
         this.gotoAndStop("disabled");
      }
      else if(this.pressed == false)
      {
         this._parent.loading_clip.gotoAndPlay(2);
         this.pressed = true;
      }
   }
   function submitScore()
   {
      _root.name_entered = this._parent.getNameText();
      var _loc3_;
      if(_root.name_entered != "")
      {
         _root.lv_sender = new LoadVars();
         _root.lv_receiver = new LoadVars();
         _root.lv_receiver.onLoad = function(success)
         {
            if(success)
            {
               _root.tt.doTween("scores");
            }
            else
            {
               _root.tt.doTween("scores");
            }
         };
         _root.lv_sender.data_string = _root.ng.getScoreData(com.nitrome.engine.Score.value,_root.name_entered);
         _root.lv_sender.time_based = "0";
         _loc3_ = _root.ng.getSubmitScoreUrl();
         _root.lv_sender.sendAndLoad(_loc3_,_root.lv_receiver,"POST");
         trace("submit score: " + _root.name_entered + ":" + com.nitrome.engine.Score.value);
      }
      else
      {
         _root.gotoAndStop("view_scores");
      }
   }
   function enable()
   {
      this.disabled = false;
      this.gotoAndStop("up");
   }
   function disable()
   {
      this.disabled = true;
      this.gotoAndStop("disabled");
   }
   function onRollOver()
   {
      if(this.disabled == true)
      {
         this.gotoAndStop("disabled");
         this.useHandCursor = false;
      }
      else
      {
         this.gotoAndStop("over");
         this.useHandCursor = true;
      }
   }
   function onRollOut()
   {
      if(this.disabled == true)
      {
         this.gotoAndStop("disabled");
      }
      else
      {
         this.gotoAndStop("up");
      }
   }
}
