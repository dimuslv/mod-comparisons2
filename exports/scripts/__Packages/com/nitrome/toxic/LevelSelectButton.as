class com.nitrome.toxic.LevelSelectButton extends MovieClip
{
   var level_id;
   var secret_id;
   var hit;
   var level_name;
   var level_powercell_count;
   var real_level_id;
   var locked = true;
   function LevelSelectButton()
   {
      super();
   }
   function onLoad()
   {
      this.init();
   }
   function init()
   {
      var _loc3_ = this._name.split("_");
      this.level_id = Number(_loc3_[1]);
      this.secret_id = Number(_loc3_[2]);
      this.hitArea = this.hit;
      if(this.secret_id == 0)
      {
         if(_root.ng.getLevelUnlocked(this.level_id) == true)
         {
            this.locked = false;
            this.gotoAndStop("up");
         }
         else
         {
            this.locked = true;
            this.gotoAndStop("off");
         }
         this.level_name = com.nitrome.toxic.Global.level_names[this.level_id];
         this.level_powercell_count = com.nitrome.toxic.Global.powercell_count[this.level_id];
         this.real_level_id = this.level_id;
      }
      else if(this.secret_id == 1)
      {
         if(_root.ng.getSecretUnlocked(this.level_id) == true)
         {
            this.locked = false;
            this.gotoAndStop("up");
         }
         else
         {
            this.locked = true;
            this.gotoAndStop("off");
         }
         this.level_name = com.nitrome.toxic.Global.secret_names[this.level_id];
         this.level_powercell_count = com.nitrome.toxic.Global.secret_powercell_count[this.level_id];
         this.real_level_id = this.level_id + 20;
      }
   }
   function onRollOver()
   {
      if(this.locked == true)
      {
         this.gotoAndStop("off");
         this.useHandCursor = false;
      }
      else
      {
         this.gotoAndStop("over");
         this.useHandCursor = true;
         this._parent.map_text.text = String(this.level_id + "." + this.secret_id + " - " + this.level_name);
         this._parent.powercell_text.text = String(_root.level_powercells[this.real_level_id] + "/" + this.level_powercell_count);
      }
   }
   function onRollOut()
   {
      if(this.locked == true)
      {
         this.gotoAndStop("off");
      }
      else
      {
         this.gotoAndStop("up");
      }
      this._parent.map_text.text = "CLICK A ZONE TO PLAY";
      this._parent.powercell_text.text = String(_root.total_power_cells + "/" + com.nitrome.toxic.Global.TOTAL_POWER_CELLS);
   }
   function onPress()
   {
      if(this.locked == false)
      {
         com.nitrome.toxic.Global.level_id = this.level_id;
         com.nitrome.toxic.Global.secret_id = this.secret_id;
         if(this.level_id == 1 && this.secret_id == 0)
         {
            _root.tt.doTween("intro");
         }
         else
         {
            _root.tt.doTween("game");
         }
      }
   }
}
