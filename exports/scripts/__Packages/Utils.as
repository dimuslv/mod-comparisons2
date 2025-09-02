class Utils
{
   static var layerVisibilities;
   static var invulnerable = false;
   static var noDeath = false;
   static var fullLoads = false;
   static var controlAtBeginning = false;
   static var emptyStringOnExit = true;
   static var closeWindowsOnExit = false;
   static var perf = true;
   static var inaccuratePhysics = false;
   static var masked = true;
   static var zeroPoint = new flash.geom.Point(0,0);
   static var deactivateTeleport = false;
   static var bmps = {};
   function Utils()
   {
   }
   static function levelInit()
   {
      if(!Utils.layerVisibilities)
      {
         Utils.layerVisibilities = {};
         for(var _loc2_ in _root.game)
         {
            if(_loc2_.slice(-7) == "_holder")
            {
               Utils.layerVisibilities[_loc2_] = true;
            }
         }
      }
      else
      {
         for(_loc2_ in _root.game)
         {
            if(_loc2_.slice(-7) == "_holder")
            {
               _root.game[_loc2_]._visible = Utils.layerVisibilities[_loc2_];
            }
         }
      }
   }
   static function doKeyDown(code)
   {
      var _loc2_;
      if(code == 77)
      {
         _loc2_ = Windows.createEmptyWindow(100,100);
         Utils.mainMenu(_loc2_);
         return true;
      }
   }
   static function mainMenu(w)
   {
      w.updateMainField({title:"Main menu",curWindow:Utils.mainMenu,options:["Testing vars",Utils.testingVarsWindow,"Bruteforcing",Utils.bruteforcingWindow,"Info windows",Utils.infoWindowsWindow,"Preferences",Utils.preferenceWindow,"Layer visibility",Utils.layerVisibilityWindow]});
   }
   static function testingVarsWindow(w)
   {
      var _loc2_ = {title:"Testing vars",curWindow:Utils.testingVarsWindow,options:[]};
      Utils.addToggleVarOptions(_loc2_.options,["Invulnerability",Utils,"invulnerable","No death",Utils,"noDeath","Buggy IL mod physics",Utils,"inaccuratePhysics","Deactivate teleport",Utils,"deactivateTeleport"]);
      _loc2_.options.push("Mask: " + (Utils.masked ? "on" : "off"),Utils.toggleMask);
      _loc2_.options.push("Back",Utils.mainMenu);
      w.updateMainField(_loc2_);
   }
   static function addToggleVarOptions(options, stuffArray)
   {
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      while(_loc3_ < stuffArray.length)
      {
         _loc4_ = stuffArray[_loc3_];
         _loc5_ = stuffArray[_loc3_ + 1];
         _loc6_ = stuffArray[_loc3_ + 2];
         options.push(_loc4_ + ": " + (_loc5_[_loc6_] ? "on" : "off"));
         options.push([Utils.toggleVar,_loc5_,_loc6_]);
         _loc3_ += 3;
      }
   }
   static function toggleVar(w, stump, varName)
   {
      stump[varName] = !stump[varName];
      w.obj.curWindow(w);
   }
   static function bruteforcingWindow(w)
   {
      w.updateMainField({title:"Bruteforcing",curWindow:Utils.bruteforcingWindow,options:["Copy collision data 📋",Utils.copyCollisionData,"Back",Utils.mainMenu]});
   }
   static function copyCollisionData(w)
   {
      var _loc3_ = [];
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc4_ < com.nitrome.toxic.Global.level_height)
      {
         _loc5_ = 0;
         while(_loc5_ < com.nitrome.toxic.Global.level_cols)
         {
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc7_ < 32)
            {
               if(_root.game.getSceneryCollision(_loc5_ * 32 + _loc7_,_loc4_))
               {
                  _loc6_ |= 1 << _loc7_;
               }
               _loc7_ = _loc7_ + 1;
            }
            _loc3_.push(_loc6_);
            _loc5_ = _loc5_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
      System.setClipboard(_loc3_.toString());
   }
   static function toggleMask(w)
   {
      Utils.masked = !Utils.masked;
      if(Utils.masked)
      {
         _root.setMask(mask);
      }
      else
      {
         _root.setMask(null);
      }
      w.obj.curWindow(w);
   }
   static function preferenceWindow(w)
   {
      var _loc2_ = {title:"Preferences",curWindow:Utils.preferenceWindow,options:[]};
      Utils.addToggleVarOptions(_loc2_.options,["Perf optimizations",Utils,"perf"]);
      _loc2_.options.push("Back",Utils.mainMenu);
      w.updateMainField(_loc2_);
   }
   static function infoWindowsWindow(w)
   {
      w.updateMainField({title:"Info windows",curWindow:Utils.infoWindowsWindow,options:["Damage visualization 🗗",[Utils.activateStaticWindow,Windows.clip.DamageVisWindow],"Acid visualization 🗗",[Utils.activateStaticWindow,Windows.clip.AcidVisWindow],"Object visualization 🗗",[Utils.activateStaticWindow,Windows.clip.ObjectVisWindow],"Back",Utils.mainMenu]});
   }
   static function activateStaticWindow(w, w2)
   {
      w2._visible = true;
   }
   static function updateVisBitmap(n, source_bmp)
   {
      if(!TAS.fastPlayback && Windows.clip[n + "VisWindow"]._visible)
      {
         Utils.bmps[n].copyPixels(source_bmp,new flash.geom.Rectangle(0,0,source_bmp.width,source_bmp.height),zeroPoint);
      }
   }
   static function layerVisibilityWindow(w)
   {
      for(var _loc3_ in _root.game)
      {
         if(_loc3_.slice(-7) == "_holder")
         {
            _root.game[_loc3_]._visible = Utils.layerVisibilities[_loc3_];
         }
      }
      var _loc4_ = {title:"Layer visibility",curWindow:Utils.layerVisibilityWindow,options:[]};
      var _loc5_ = [];
      for(_loc3_ in _root.game)
      {
         if(_loc3_.slice(-7) == "_holder")
         {
            _loc5_.push(_loc3_.slice(0,-7),Utils.layerVisibilities,_loc3_);
         }
      }
      Utils.addToggleVarOptions(_loc4_.options,_loc5_);
      _loc4_.options.push("Back",Utils.mainMenu);
      w.updateMainField(_loc4_);
   }
}
