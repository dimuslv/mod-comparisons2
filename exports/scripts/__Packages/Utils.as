class Utils
{
   static var layerVisibilities;
   static var extraLayerVisibilities;
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
   static var laserState = 1;
   static var skipBeginning = true;
   static var visWindowArray = ["Damage",60,52,"Acid",60,52,"Object",60,52,"Bomb",31,18];
   static var bmps = {};
   static var empty_bmp = new flash.display.BitmapData(100,100,false);
   function Utils()
   {
   }
   static function cutsceneIn()
   {
      if(!TAS.fastPlayback)
      {
         _root.cutscene.gotoAndPlay("in");
      }
      else
      {
         _root.cutscene.gotoAndStop(18);
      }
   }
   static function cutsceneOut()
   {
      if(!TAS.fastPlayback)
      {
         _root.cutscene.gotoAndPlay("out");
      }
      else
      {
         _root.cutscene.gotoAndStop(1);
      }
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
         Utils.layerVisibilities.test_holder = false;
         _root.game.test_holder._visible = false;
         Utils.extraLayerVisibilities = {pipes:true,big_pipes:true,acid_holder:true,bomb_panel:true,health_panel:true,powercell_panel:true,text_display:true,cutscene:true,popup_holder:true};
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
         for(var _loc3_ in Utils.extraLayerVisibilities)
         {
            _root[_loc3_]._visible = Utils.extraLayerVisibilities[_loc3_];
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
      Utils.addToggleVarOptions(_loc2_.options,["Invulnerability",Utils,"invulnerable","No death",Utils,"noDeath","Buggy IL mod physics",Utils,"inaccuratePhysics","Deactivate teleport",Utils,"deactivateTeleport","Skip beginning",Utils,"skipBeginning"]);
      Utils.addCycleOption(_loc2_.options,"Lasers",Utils,"laserState",["off","on","simple"]);
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
   static function addCycleOption(options, name, stump, varName, values)
   {
      options.push(name + ": " + values[stump[varName]]);
      options.push([Utils.cycleVar,stump,varName,values]);
   }
   static function cycleVar(w, stump, varName, values)
   {
      stump[varName]++;
      stump[varName] %= values.length;
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
      var _loc2_ = [];
      var _loc3_ = 0;
      while(_loc3_ < Utils.visWindowArray.length)
      {
         _loc2_.push(Utils.visWindowArray[_loc3_] + " visualization 🗗",[Utils.activateStaticWindow,Windows.clip[Utils.visWindowArray[_loc3_] + "VisWindow"]]);
         _loc3_ += 3;
      }
      _loc2_.push("Back",Utils.mainMenu);
      w.updateMainField({title:"Info windows",curWindow:Utils.infoWindowsWindow,options:_loc2_});
   }
   static function activateStaticWindow(w, w2)
   {
      w2._visible = true;
   }
   static function updateVisBitmap(n, source_bmp)
   {
      var _loc3_ = Utils.bmps[n];
      if(!TAS.fastPlayback && Windows.clip[n + "VisWindow"]._visible)
      {
         _loc3_.copyPixels(Utils.empty_bmp,new flash.geom.Rectangle(0,0,_loc3_.width,_loc3_.height),zeroPoint);
         _loc3_.copyPixels(source_bmp,new flash.geom.Rectangle(0,0,source_bmp.width,source_bmp.height),zeroPoint);
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
      _loc4_.options.push("Extra",Utils.extraLayerVisibilityWindow);
      _loc4_.options.push("Back",Utils.mainMenu);
      Utils.addToggleVarOptions(_loc4_.options,_loc5_);
      w.updateMainField(_loc4_);
   }
   static function extraLayerVisibilityWindow(w)
   {
      for(var _loc3_ in Utils.extraLayerVisibilities)
      {
         _root[_loc3_]._visible = Utils.extraLayerVisibilities[_loc3_];
      }
      var _loc4_ = {title:"Extra layer visibility",curWindow:Utils.extraLayerVisibilityWindow,options:[]};
      var _loc5_ = [];
      for(_loc3_ in Utils.extraLayerVisibilities)
      {
         _loc5_.push(_loc3_,Utils.extraLayerVisibilities,_loc3_);
      }
      _loc4_.options.push("Back",Utils.layerVisibilityWindow);
      Utils.addToggleVarOptions(_loc4_.options,_loc5_);
      w.updateMainField(_loc4_);
   }
}
