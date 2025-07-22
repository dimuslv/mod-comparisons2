class com.nitrome.highscore.ScoreSubmitPanel extends MovieClip
{
   var score_text;
   var name_text;
   var submit_button;
   var MAX_LENGTH = 10;
   function ScoreSubmitPanel()
   {
      super();
   }
   function onLoad()
   {
      if(_root.ng.getNitrome() == true)
      {
         this.score_text.text = String("YOUR SCORE IS " + com.nitrome.engine.Score.value);
      }
      else
      {
         this.gotoAndStop("off");
      }
      Key.addListener(this);
   }
   function addLetter(l)
   {
      var _loc3_ = this.name_text.text;
      var _loc4_;
      if(_loc3_.length < this.MAX_LENGTH)
      {
         _loc4_ = _loc3_ + l;
         this.name_text.text = _loc4_;
         _root.name_entered = this.name_text.text.toUpperCase();
         this.submit_button.enable();
      }
   }
   function getNameText()
   {
      return String(this.name_text.text);
   }
   function clearName()
   {
      this.submit_button.disable();
      this.name_text.text = "";
      _root.name_entered = this.name_text.text;
   }
}
