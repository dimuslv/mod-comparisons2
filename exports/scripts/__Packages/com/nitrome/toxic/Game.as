class com.nitrome.toxic.Game extends MovieClip
{
   var player;
   var level_number;
   var power_cell_memory;
   var scroll_x;
   var scroll_y;
   var object_holder;
   var first_info_point_name;
   var xml;
   var key_listener;
   var bg_holder;
   var ground_holder;
   var solid_holder;
   var player_holder;
   var bomb_holder;
   var explosion_holder;
   var acid_holder;
   var danger_holder;
   var laser_holder;
   var splash_holder;
   var debris_holder;
   var safe_holder;
   var bossbmp_holder;
   var heart_holder;
   var grow_holder;
   var missile_holder;
   var info_text;
   var holo_data;
   var laser_data;
   var bomb_list;
   var robot_list;
   var collect_list;
   var debris_list;
   var laser_list;
   var safe_list;
   var holo_list;
   var active_holo_list;
   var conveyor_list;
   var mine_list;
   var genesis_list;
   var spawn_list;
   var left_spawn_list;
   var right_spawn_list;
   var bullet_list;
   var left_door_list;
   var right_door_list;
   var missile_list;
   var first_door_list;
   var fan_list;
   var acid_fall_list;
   var last_collect_object;
   var start_pad_row;
   var start_pad_col;
   var end_pad_row;
   var end_pad_col;
   var bonus_pad_row;
   var bonus_pad_col;
   var bomb_count;
   var onEnterFrame;
   var scroll_x_min_diff = 0;
   var scroll_x_max_diff = 0;
   var screen_shake = 0;
   var deg_count = 0;
   var genesis = false;
   var boss1 = false;
   var boss2 = false;
   var first_info_point = false;
   var left_door_count = -1;
   var right_door_count = -1;
   var first_door_count = -1;
   var bonus_pad = false;
   var missile_count = 0;
   var smooth_scroll = false;
   var smooth_scroll_boss = false;
   function Game()
   {
      super();
   }
   function getAlive()
   {
      return true;
   }
   function main()
   {
      this.checkKeys();
      this.player.main();
      this.updateBombs();
      this.updateRobots();
      this.updateSafeRobots();
      this.updateHoloButtons();
      this.updateLasers();
      this.updateMines();
      this.updateDebris();
      this.updateBullets();
      this.updateMissiles();
      this.updateConveyorBelts();
      this.checkLastCollectObject();
      this.createGround();
      this.doScroll();
      this.doScreenShake();
      this.deg_count = this.deg_count + 1;
      if(this.deg_count >= 360)
      {
         this.deg_count = 0;
      }
   }
   function levelComplete()
   {
      trace("level complete");
      this.pauseGame();
      if(this.level_number != 0)
      {
         this.power_cell_memory.finaliseLevel();
      }
      com.nitrome.engine.Score.value = this.power_cell_memory.getTotalCollected() * 1000;
      if(this.level_number == 20 && com.nitrome.toxic.Global.secret_id == 0)
      {
         _root.popup_holder.displayPopUp("game_complete");
      }
      else if(com.nitrome.toxic.Global.secret_id == 1)
      {
         _root.ng.setSecretComplete(com.nitrome.toxic.Global.level_id);
         if(_root.ng.countSecretComplete() >= 10)
         {
            _root.popup_holder.displayPopUp("all_secret_complete");
         }
         else
         {
            _root.popup_holder.displayPopUp("secret_level_complete");
         }
      }
      else
      {
         _root.ng.setLevelUnlocked(com.nitrome.toxic.Global.level_id + 1);
         _root.popup_holder.displayPopUp("level_complete");
      }
   }
   function levelCompleteBonus()
   {
      trace("level complete - going to the secret level");
      this.pauseGame();
      if(this.level_number != 0)
      {
         this.power_cell_memory.finaliseLevel();
      }
      com.nitrome.engine.Score.value = this.power_cell_memory.getTotalCollected() * 1000;
      _root.ng.setSecretUnlocked(com.nitrome.toxic.Global.level_id);
      _root.popup_holder.displayPopUp("level_complete_found_secret");
   }
   function gameOver()
   {
      trace("game over");
      this.pauseGame();
      com.nitrome.engine.Score.value = this.power_cell_memory.getTotalCollected() * 1000;
      _root.sfx.playSound("missionfailed");
      _root.popup_holder.displayPopUp("game_over");
   }
   function smoothScroll()
   {
      this.smooth_scroll = true;
   }
   function smoothScrollBoss()
   {
      this.smooth_scroll_boss = true;
   }
   function adjustScroll(boss)
   {
      if(boss == 0)
      {
         this.scroll_x_min_diff = 0;
      }
      else if(boss == 1)
      {
         this.scroll_x_min_diff = 512;
         this.scroll_x_max_diff = 512;
      }
      else if(boss == 2)
      {
         this.scroll_x_min_diff = 0;
         this.scroll_x_max_diff = 0;
      }
      else if(boss == 3)
      {
         this.scroll_x_min_diff = com.nitrome.toxic.Global.level_width;
      }
      else if(boss == 6)
      {
         this.scroll_x_min_diff = 192;
      }
   }
   function doScroll()
   {
      if(this.smooth_scroll == true)
      {
         if(this.scroll_x_min_diff > 0)
         {
            this.scroll_x_min_diff -= 4;
            if(this.scroll_x_min_diff <= 0)
            {
               this.scroll_x_min_diff = 0;
            }
         }
         else if(this.scroll_x_min_diff == 0)
         {
            this.smooth_scroll = false;
         }
      }
      if(this.smooth_scroll_boss == true)
      {
         if(this.scroll_x_max_diff > 0)
         {
            this.scroll_x_max_diff -= 4;
            if(this.scroll_x_max_diff <= 0)
            {
               this.scroll_x_max_diff = 0;
            }
         }
         else if(this.scroll_x_max_diff == 0)
         {
            this.smooth_scroll_boss = false;
         }
      }
      this.scroll_x = - (this.player._x - 275);
      this.scroll_y = - (this.player._y - 200);
      if(this.scroll_x < com.nitrome.toxic.Global.scroll_x_min + this.scroll_x_min_diff)
      {
         this.scroll_x = com.nitrome.toxic.Global.scroll_x_min + this.scroll_x_min_diff;
      }
      if(this.scroll_x > com.nitrome.toxic.Global.scroll_x_max - this.scroll_x_max_diff)
      {
         this.scroll_x = com.nitrome.toxic.Global.scroll_x_max - this.scroll_x_max_diff;
      }
      if(this.scroll_y < com.nitrome.toxic.Global.scroll_y_min)
      {
         this.scroll_y = com.nitrome.toxic.Global.scroll_y_min;
      }
      if(this.scroll_y > com.nitrome.toxic.Global.scroll_y_max)
      {
         this.scroll_y = com.nitrome.toxic.Global.scroll_y_max;
      }
      this._x = this.scroll_x;
      this._y = this.scroll_y;
      _root.pipes._x = this.scroll_x * 0.2;
      _root.pipes._y = this.scroll_y * 0.1;
      _root.big_pipes._x = this.scroll_x * 0.5;
      _root.big_pipes._y = this.scroll_y * 0.5;
      var _loc4_ = Math.abs(this.scroll_x % 32);
      _root.acid_holder.acid_clip._x = - _loc4_;
      _root.acid_holder._y = this.scroll_y;
      var _loc3_ = this.scroll_x;
      if(_loc3_ < -1100)
      {
         _loc3_ += 550;
      }
      if(_loc3_ > -550)
      {
         _loc3_ -= 550;
      }
      _root.acid_holder.smoke_bubble_holder._x = _loc3_;
   }
   function doScreenShake()
   {
      var _loc2_;
      if(this.screen_shake > 0)
      {
         this.screen_shake = this.screen_shake - 1;
         _loc2_ = random(4) + 1;
         if(_loc2_ == 1)
         {
            this._x -= 3;
         }
         else if(_loc2_ == 2)
         {
            this._x += 3;
         }
         else if(_loc2_ == 3)
         {
            this._y -= 3;
         }
         else if(_loc2_ == 4)
         {
            this._y += 3;
         }
      }
   }
   function getFinalBoss()
   {
      return this.boss2;
   }
   function checkFirstInfoPoint()
   {
      if(this.first_info_point == true)
      {
         this.object_holder[this.first_info_point_name].checkExplosions();
      }
   }
   function init()
   {
      this.clearAll();
      if(com.nitrome.toxic.Global.secret_id == 0)
      {
         this.level_number = com.nitrome.toxic.Global.level_id;
      }
      else
      {
         this.level_number = com.nitrome.toxic.Global.level_id + 20;
      }
      this.power_cell_memory = new com.nitrome.toxic.PowerCellMemory();
      var _loc3_ = _root.ng.getLevelName(com.nitrome.toxic.Global.level_id,com.nitrome.toxic.Global.secret_id,".xml");
      var _loc4_ = _root.level_data[_loc3_];
      this.xml = new XML();
      this.xml.ignoreWhite = true;
      this.xml.parseXML(_loc4_);
      _root.game.loadLevel();
      ClockDisp.initDriver(_root.powercell_panel.createEmptyMovieClip("CDDriverMovie",_root.powercell_panel.getNextHighestDepth()));
      var _loc5_ = new ClockDisp(0,-450,-375);
      _loc5_.setPause(true);
   }
   function clearAll()
   {
      Key.removeListener(this.key_listener);
      this.key_listener = null;
      this.xml = null;
      for(var _loc3_ in this.bg_holder)
      {
         this.bg_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.ground_holder)
      {
         this.ground_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.solid_holder)
      {
         this.solid_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.object_holder)
      {
         this.object_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.player_holder)
      {
         this.player_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.bomb_holder)
      {
         this.bomb_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.explosion_holder)
      {
         this.explosion_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.acid_holder)
      {
         this.acid_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.danger_holder)
      {
         this.danger_holder[_loc3_].doClear();
         this.danger_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.laser_holder)
      {
         this.laser_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.splash_holder)
      {
         this.splash_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.debris_holder)
      {
         this.debris_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.safe_holder)
      {
         this.safe_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.bossbmp_holder)
      {
         this.bossbmp_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.heart_holder)
      {
         this.heart_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.grow_holder)
      {
         this.grow_holder[_loc3_].removeMovieClip();
      }
      for(_loc3_ in this.missile_holder)
      {
         this.missile_holder[_loc3_].removeMovieClip();
      }
      this.info_text.length = 0;
      this.info_text = null;
      this.holo_data.length = 0;
      this.holo_data = null;
      this.laser_data.length = 0;
      this.laser_data = null;
      this.bomb_list.length = 0;
      this.bomb_list = null;
      this.robot_list.length = 0;
      this.robot_list = null;
      this.collect_list.length = 0;
      this.collect_list = null;
      this.debris_list.length = 0;
      this.debris_list = null;
      this.laser_list.length = 0;
      this.laser_list = null;
      this.safe_list.length = 0;
      this.safe_list = null;
      this.holo_list.length = 0;
      this.holo_list = null;
      this.active_holo_list.length = 0;
      this.active_holo_list = null;
      this.conveyor_list.length = 0;
      this.conveyor_list = null;
      this.mine_list.length = 0;
      this.mine_list = null;
      this.genesis_list.length = 0;
      this.genesis_list = null;
      this.spawn_list.length = 0;
      this.spawn_list = null;
      this.left_spawn_list.length = 0;
      this.left_spawn_list = null;
      this.right_spawn_list.length = 0;
      this.right_spawn_list = null;
      this.bullet_list.length = 0;
      this.bullet_list = null;
      this.left_door_list.length = 0;
      this.left_door_list = null;
      this.right_door_list.length = 0;
      this.right_door_list = null;
      this.missile_list.length = 0;
      this.missile_list = null;
      this.first_door_list.length = 0;
      this.first_door_list = null;
      this.fan_list.length = 0;
      this.fan_list = null;
      this.acid_fall_list.length = 0;
      this.acid_fall_list = null;
      _global.ground_bmp.dispose();
      _global.solid_bmp.dispose();
      _global.bg_bmp.dispose();
      _global.robot_bmp.dispose();
      _global.genesis_bmp.dispose();
      _global.temp_bmp.dispose();
      _global.b_temp.dispose();
      _global.boss_bmp.dispose();
      _global.img.dispose();
      _global.img2.dispose();
      _global.img3.dispose();
      _global.img4.dispose();
      _global.img5.dispose();
      delete _global.ground_bmp;
      delete _global.solid_bmp;
      delete _global.bg_bmp;
      delete _global.robot_bmp;
      delete _global.genesis_bmp;
      delete _global.temp_bmp;
      delete _global.b_temp;
      delete _global.boss_bmp;
      delete _global.img;
      delete _global.img2;
      delete _global.img3;
      delete _global.img4;
      delete _global.img5;
      this.screen_shake = 0;
      this.deg_count = 0;
      this.last_collect_object = "";
      this.genesis = false;
      this.start_pad_row = null;
      this.start_pad_col = null;
      this.end_pad_row = null;
      this.end_pad_col = null;
      this.bonus_pad_row = null;
      this.bonus_pad_col = null;
      this.boss1 = false;
      this.boss2 = false;
      this.first_info_point = false;
      this.first_info_point_name = null;
      this.left_door_count = -1;
      this.right_door_count = -1;
      this.first_door_count = -1;
      this.bonus_pad = false;
      this.level_number = null;
      this.power_cell_memory = null;
      this.missile_count = 0;
      this.smooth_scroll = false;
   }
   function collectPowerCell(row, col)
   {
      if(this.level_number != 0)
      {
         this.power_cell_memory.setCollected(this.level_number,row,col);
      }
   }
   function loadLevel()
   {
      this.bomb_list = new Array();
      this.bomb_count = 0;
      this.robot_list = new Array();
      this.collect_list = new Array();
      this.debris_list = new Array();
      this.laser_list = new Array();
      this.safe_list = new Array();
      this.holo_list = new Array();
      this.active_holo_list = new Array();
      this.conveyor_list = new Array();
      this.mine_list = new Array();
      this.genesis_list = new Array();
      this.spawn_list = new Array();
      this.left_spawn_list = new Array();
      this.right_spawn_list = new Array();
      this.bullet_list = new Array();
      this.left_door_list = new Array();
      this.right_door_list = new Array();
      this.missile_list = new Array();
      this.first_door_list = new Array();
      this.fan_list = new Array();
      this.acid_fall_list = new Array();
      this.boss1 = false;
      this.boss2 = false;
      this.left_door_count = -1;
      this.right_door_count = -1;
      var _loc12_ = this.xml.firstChild;
      com.nitrome.toxic.Global.level_rows = Number(String(_loc12_.attributes.rows));
      com.nitrome.toxic.Global.level_cols = Number(String(_loc12_.attributes.cols));
      com.nitrome.toxic.Global.level_width = com.nitrome.toxic.Global.level_cols * com.nitrome.toxic.Global.TILE_WIDTH;
      com.nitrome.toxic.Global.level_height = com.nitrome.toxic.Global.level_rows * com.nitrome.toxic.Global.TILE_HEIGHT;
      com.nitrome.toxic.Global.scroll_x_min = 550 - com.nitrome.toxic.Global.level_width;
      com.nitrome.toxic.Global.scroll_x_max = 0;
      com.nitrome.toxic.Global.scroll_y_min = 400 - com.nitrome.toxic.Global.level_height;
      com.nitrome.toxic.Global.scroll_y_max = 0;
      if(com.nitrome.toxic.Global.level_id == 6 && com.nitrome.toxic.Global.secret_id == 0)
      {
         this.adjustScroll(6);
      }
      _global.ground_bmp = new flash.display.BitmapData(com.nitrome.toxic.Global.level_width,com.nitrome.toxic.Global.level_height,true,16777215);
      _global.solid_bmp = new flash.display.BitmapData(com.nitrome.toxic.Global.level_width,com.nitrome.toxic.Global.level_height,true,16777215);
      _global.bg_bmp = new flash.display.BitmapData(com.nitrome.toxic.Global.level_width,com.nitrome.toxic.Global.level_height,true,16777215);
      _global.robot_bmp = new flash.display.BitmapData(550,400,true,16777215);
      _global.genesis_bmp = new flash.display.BitmapData(com.nitrome.toxic.Global.level_width,com.nitrome.toxic.Global.level_height,true,16777215);
      var _loc14_ = String(_loc12_.firstChild.firstChild);
      var _loc19_ = String(_loc12_.firstChild.nextSibling.firstChild);
      var _loc17_ = String(_loc12_.firstChild.nextSibling.nextSibling.firstChild);
      var _loc13_ = String(_loc12_.firstChild.nextSibling.nextSibling.nextSibling.firstChild);
      var _loc15_ = _loc12_.firstChild.nextSibling.nextSibling.nextSibling.nextSibling;
      this.loadLaserPaths(_loc15_);
      var _loc18_ = _loc12_.firstChild.nextSibling.nextSibling.nextSibling.nextSibling.nextSibling;
      this.loadInfoText(_loc18_);
      var _loc16_ = _loc12_.firstChild.nextSibling.nextSibling.nextSibling.nextSibling.nextSibling.nextSibling;
      this.loadHoloPaths(_loc16_);
      var _loc8_ = new Array();
      _loc8_ = _loc14_.split(",");
      var _loc7_ = new Array();
      _loc7_ = _loc19_.split(",");
      var _loc9_ = new Array();
      _loc9_ = _loc17_.split(",");
      var _loc6_ = new Array();
      _loc6_ = _loc13_.split(",");
      var _loc4_ = 0;
      var _loc10_ = 0;
      var _loc5_;
      while(_loc10_ < com.nitrome.toxic.Global.level_rows)
      {
         _loc5_ = 0;
         while(_loc5_ < com.nitrome.toxic.Global.level_cols)
         {
            _loc8_[_loc4_] = Number(_loc8_[_loc4_]);
            _loc9_[_loc4_] = Number(_loc9_[_loc4_]);
            _loc6_[_loc4_] = Number(_loc6_[_loc4_]);
            if(_loc8_[_loc4_] != 0)
            {
               this.paintGroundTile(_loc10_,_loc5_,_loc8_[_loc4_]);
            }
            if(_loc9_[_loc4_] != 0)
            {
               this.paintObjectTile(_loc10_,_loc5_,_loc9_[_loc4_]);
            }
            if(_loc6_[_loc4_] != 0)
            {
               this.paintBgTile(_loc10_,_loc5_,_loc6_[_loc4_]);
            }
            _loc4_ = _loc4_ + 1;
            _loc5_ = _loc5_ + 1;
         }
         _loc10_ = _loc10_ + 1;
      }
      _loc4_ = 0;
      _loc10_ = 0;
      while(_loc10_ < com.nitrome.toxic.Global.level_rows)
      {
         _loc5_ = 0;
         while(_loc5_ < com.nitrome.toxic.Global.level_cols)
         {
            _loc7_[_loc4_] = Number(_loc7_[_loc4_]);
            if(_loc7_[_loc4_] != 0)
            {
               this.paintSolidTile(_loc10_,_loc5_,_loc7_[_loc4_]);
            }
            _loc4_ = _loc4_ + 1;
            _loc5_ = _loc5_ + 1;
         }
         _loc10_ = _loc10_ + 1;
      }
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("start_pad_glow");
      _global.bg_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,52,81),new flash.geom.Point(this.start_pad_col * com.nitrome.toxic.Global.TILE_WIDTH - 10,this.start_pad_row * com.nitrome.toxic.Global.TILE_HEIGHT - 48),null,null,true);
      _global.temp_bmp.dispose();
      delete _global.temp_bmp;
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("end_pad_glow");
      _global.bg_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,52,81),new flash.geom.Point(this.end_pad_col * com.nitrome.toxic.Global.TILE_WIDTH - 10,this.end_pad_row * com.nitrome.toxic.Global.TILE_HEIGHT - 48),null,null,true);
      _global.temp_bmp.dispose();
      delete _global.temp_bmp;
      if(this.bonus_pad == true)
      {
         _global.temp_bmp = flash.display.BitmapData.loadBitmap("bonus_pad_glow");
         _global.bg_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,52,81),new flash.geom.Point(this.bonus_pad_col * com.nitrome.toxic.Global.TILE_WIDTH - 10,this.bonus_pad_row * com.nitrome.toxic.Global.TILE_HEIGHT - 48),null,null,true);
         _global.temp_bmp.dispose();
         delete _global.temp_bmp;
      }
      this.ground_holder.attachBitmap(_global.ground_bmp,1);
      this.ground_holder.cacheAsBitmap = true;
      this.solid_holder.attachBitmap(_global.solid_bmp,1);
      this.solid_holder.cacheAsBitmap = true;
      this.bg_holder.attachBitmap(_global.bg_bmp,1);
      this.bg_holder.cacheAsBitmap = true;
      _root.acid_holder.init();
      var _loc11_ = 0;
      while(_loc11_ < this.holo_list.length)
      {
         this.object_holder[this.holo_list[_loc11_]].savePath(this.findHoloPath(this.object_holder[this.holo_list[_loc11_]].getRow(),this.object_holder[this.holo_list[_loc11_]].getCol()));
         _loc11_ = _loc11_ + 1;
      }
      _loc11_ = 0;
      while(_loc11_ < this.robot_list.length)
      {
         this.danger_holder[this.robot_list[_loc11_]].setPlayer(this.player);
         _loc11_ = _loc11_ + 1;
      }
      _loc11_ = 0;
      while(_loc11_ < this.collect_list.length)
      {
         this.object_holder[this.collect_list[_loc11_]].setPlayer(this.player);
         _loc11_ = _loc11_ + 1;
      }
      _root.boss_health_panel.setActive(false);
      if(this.boss1 == true)
      {
         this.danger_holder.boss1.setPlayer(this.player);
      }
      if(this.boss2 == true)
      {
         this.safe_holder.boss2.setPlayer(this.player);
         _global.boss_bmp = new flash.display.BitmapData(com.nitrome.toxic.Global.level_width,com.nitrome.toxic.Global.level_height,true,16777215);
         this.bossbmp_holder.attachBitmap(_global.boss_bmp,1);
         this.bossbmp_holder.cacheAsBitmap = true;
      }
      if(this.level_number != 0)
      {
         _root.powercell_panel.setCount(this.power_cell_memory.getTotalCollected());
      }
      this.key_listener = new Object();
      this.key_listener.onKeyDown = function()
      {
         if(Key.getCode() == 38 || Key.getCode() == 87)
         {
            com.nitrome.toxic.Global.UP_PRESSED = true;
         }
         if(Key.getCode() == 40 || Key.getCode() == 83)
         {
            com.nitrome.toxic.Global.DOWN_PRESSED = true;
         }
         if(Key.getCode() == 32)
         {
            _root.game.layBomb();
         }
         if(Key.getCode() == 37 || Key.getCode() == 65)
         {
            com.nitrome.toxic.Global.LAST_DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
         }
         if(Key.getCode() == 39 || Key.getCode() == 68)
         {
            com.nitrome.toxic.Global.LAST_DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
         }
      };
      this.key_listener.onKeyUp = function()
      {
         if(Key.getCode() == 38 || Key.getCode() == 87)
         {
            com.nitrome.toxic.Global.can_jump = true;
            com.nitrome.toxic.Global.UP_PRESSED = false;
         }
         if(Key.getCode() == 40 || Key.getCode() == 83)
         {
            com.nitrome.toxic.Global.DOWN_PRESSED = false;
         }
      };
      Key.addListener(this.key_listener);
      com.nitrome.toxic.Global.game_paused = false;
      this.onEnterFrame = function()
      {
         ClockDisp.enterFrame();
         if(com.nitrome.toxic.Global.game_paused == false)
         {
            this.main();
         }
      };
      _root.mc.startGameMusic(false);
      _root.loading_clip.gotoAndPlay("out");
   }
   function clearBossBmp()
   {
      _global.boss_bmp = new flash.display.BitmapData(com.nitrome.toxic.Global.level_width,com.nitrome.toxic.Global.level_height,true,16777215);
   }
   function paintGroundTile(row, col, id)
   {
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("tile_" + id);
      _global.ground_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,_global.temp_bmp.width,_global.temp_bmp.height),new flash.geom.Point(col * com.nitrome.toxic.Global.TILE_WIDTH,row * com.nitrome.toxic.Global.TILE_HEIGHT));
      _global.temp_bmp.dispose();
      delete _global.temp_bmp;
      var _loc3_;
      if(id >= 263 && id <= 265)
      {
         _loc3_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("drip","drip_" + _loc3_,_loc3_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.robot_list.push("drip_" + _loc3_);
         if(id == 263)
         {
            this.danger_holder["drip_" + _loc3_].init(this,1);
         }
         else if(id == 264)
         {
            this.danger_holder["drip_" + _loc3_].init(this,2);
         }
         else if(id == 265)
         {
            this.danger_holder["drip_" + _loc3_].init(this,3);
         }
      }
   }
   function paintSolidTile(row, col, id)
   {
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("tile_" + id);
      _global.solid_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,32,32),new flash.geom.Point(col * com.nitrome.toxic.Global.TILE_WIDTH,row * com.nitrome.toxic.Global.TILE_HEIGHT));
      _global.temp_bmp.dispose();
      delete _global.temp_bmp;
   }
   function paintBgTile(row, col, id)
   {
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("tile_" + id);
      if(id == 204)
      {
         _global.bg_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,_global.temp_bmp.width,_global.temp_bmp.height),new flash.geom.Point(col * com.nitrome.toxic.Global.TILE_WIDTH - 9,row * com.nitrome.toxic.Global.TILE_HEIGHT - 31));
      }
      else if(id == 205)
      {
         _global.bg_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,_global.temp_bmp.width,_global.temp_bmp.height),new flash.geom.Point(col * com.nitrome.toxic.Global.TILE_WIDTH,row * com.nitrome.toxic.Global.TILE_HEIGHT - 32));
      }
      else if(id == 206)
      {
         _global.bg_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,_global.temp_bmp.width,_global.temp_bmp.height),new flash.geom.Point(col * com.nitrome.toxic.Global.TILE_WIDTH,row * com.nitrome.toxic.Global.TILE_HEIGHT - 31));
      }
      else if(id == 240)
      {
         this.genesis = true;
         _global.bg_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,32,32),new flash.geom.Point(col * com.nitrome.toxic.Global.TILE_WIDTH,row * com.nitrome.toxic.Global.TILE_HEIGHT));
         _global.genesis_bmp.fillRect(new flash.geom.Rectangle(col * com.nitrome.toxic.Global.TILE_WIDTH,row * com.nitrome.toxic.Global.TILE_HEIGHT,32,32),4278190080);
      }
      else
      {
         _global.bg_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,32,32),new flash.geom.Point(col * com.nitrome.toxic.Global.TILE_WIDTH,row * com.nitrome.toxic.Global.TILE_HEIGHT));
      }
      _global.temp_bmp.dispose();
      delete _global.temp_bmp;
   }
   function paintObjectTile(row, col, id)
   {
      var _loc9_;
      var _loc10_;
      var _loc8_;
      var _loc7_;
      var _loc6_;
      if(id == 1 || id == 2)
      {
         this.start_pad_row = row;
         this.start_pad_col = col;
         _global.temp_bmp = flash.display.BitmapData.loadBitmap("pad_base");
         _global.solid_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,62,7),new flash.geom.Point(col * com.nitrome.toxic.Global.TILE_WIDTH - 15,row * com.nitrome.toxic.Global.TILE_HEIGHT + 26));
         _global.temp_bmp.dispose();
         delete _global.temp_bmp;
         this.player_holder.attachMovie("player","player",1);
         this.player = this.player_holder.player;
         this.player.init(id - 1,col * com.nitrome.toxic.Global.TILE_WIDTH,row * com.nitrome.toxic.Global.TILE_HEIGHT + 28,this);
      }
      else if(id == 186 || id == 187)
      {
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("tile_" + id,"tile_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.fan_list.push("tile_" + _loc9_);
      }
      else if(id >= 190 && id <= 193)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("tile_" + id,"tile_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
      }
      else if(id == 201 || id == 202 || id == 203 || id == 268 || id == 269 || id == 270 || id == 271)
      {
         _loc9_ = this.acid_holder.getNextHighestDepth();
         this.acid_holder.attachMovie("tile_" + id,"tile_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
      }
      else if(id == 207 || id == 208)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("basic_robot","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.danger_holder["robot_" + _loc9_].init(id - 207,this);
         this.robot_list.push("robot_" + _loc9_);
      }
      else if(id == 209)
      {
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("medipak","medipak_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.collect_list.push("medipak_" + _loc9_);
         this.object_holder["medipak_" + _loc9_].init(this);
      }
      else if(id == 210)
      {
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("powercell","powercell_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.collect_list.push("powercell_" + _loc9_);
         if(this.level_number == 0)
         {
            this.object_holder["powercell_" + _loc9_].init(this,false,row,col);
         }
         else
         {
            _loc10_ = this.power_cell_memory.getCollected(this.level_number,row,col);
            this.object_holder["powercell_" + _loc9_].init(this,_loc10_,row,col);
         }
      }
      else if(id >= 211 && id <= 222)
      {
         _loc9_ = this.laser_holder.getNextHighestDepth();
         this.laser_holder.attachMovie("laser","laser_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 16});
         this.laser_list.push("laser_" + _loc9_);
         this.laser_holder["laser_" + _loc9_].init(this,id,this.findPath(row,col));
      }
      else if(id == 223)
      {
         this.end_pad_row = row;
         this.end_pad_col = col;
         _global.temp_bmp = flash.display.BitmapData.loadBitmap("pad_base");
         _global.solid_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,62,7),new flash.geom.Point(col * com.nitrome.toxic.Global.TILE_WIDTH - 15,row * com.nitrome.toxic.Global.TILE_HEIGHT + 26));
         _global.temp_bmp.dispose();
         delete _global.temp_bmp;
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("levelend","levelend_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.collect_list.push("levelend_" + _loc9_);
         this.object_holder["levelend_" + _loc9_].init(this);
      }
      else if(id == 272)
      {
         this.bonus_pad_row = row;
         this.bonus_pad_col = col;
         _global.temp_bmp = flash.display.BitmapData.loadBitmap("pad_base");
         _global.solid_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,62,7),new flash.geom.Point(col * com.nitrome.toxic.Global.TILE_WIDTH - 15,row * com.nitrome.toxic.Global.TILE_HEIGHT + 26));
         _global.temp_bmp.dispose();
         delete _global.temp_bmp;
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("levelbonus","levelbonus_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.collect_list.push("levelbonus_" + _loc9_);
         this.object_holder["levelbonus_" + _loc9_].init(this);
         this.bonus_pad = true;
      }
      else if(id == 224 || id == 225)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("wheelie_robot","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.danger_holder["robot_" + _loc9_].init(id - 224,this);
         this.robot_list.push("robot_" + _loc9_);
      }
      else if(id == 226 || id == 227)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("bomber_robot","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.danger_holder["robot_" + _loc9_].init(id - 226,this);
         this.robot_list.push("robot_" + _loc9_);
      }
      else if(id == 228)
      {
         _loc9_ = this.safe_holder.getNextHighestDepth();
         this.safe_holder.attachMovie("zapper_robot","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.safe_holder["robot_" + _loc9_].init(this);
         this.safe_list.push("robot_" + _loc9_);
      }
      else if(id == 229)
      {
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("info_point","info_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.collect_list.push("info_" + _loc9_);
         this.object_holder["info_" + _loc9_].init(this.getInfoText(row,col),this);
      }
      else if(id == 274)
      {
         this.first_info_point = true;
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("first_info_point","info_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.collect_list.push("info_" + _loc9_);
         this.object_holder["info_" + _loc9_].init(this.getInfoText(row,col),this);
         this.first_info_point_name = String("info_" + _loc9_);
      }
      else if(id == 230)
      {
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("holo_button","holo_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.holo_list.push("holo_" + _loc9_);
         this.object_holder["holo_" + _loc9_].init(this,row,col);
         _global.solid_bmp.fillRect(new flash.geom.Rectangle(col * com.nitrome.toxic.Global.TILE_WIDTH,row * com.nitrome.toxic.Global.TILE_HEIGHT,32,32),4278190080);
      }
      else if(id == 998)
      {
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("holo_tile","holo_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.object_holder["holo_" + _loc9_].init(this,row,col);
         this.addHoloTile("holo_" + _loc9_,row,col);
      }
      else if(id >= 231 && id <= 233)
      {
         this.paintSolidTile(row,col,id);
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("conveyor_" + id,"con_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.object_holder["con_" + _loc9_].init(this,0);
         this.conveyor_list.push("con_" + _loc9_);
      }
      else if(id >= 234 && id <= 236)
      {
         this.paintSolidTile(row,col,id);
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("conveyor_" + id,"con_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.object_holder["con_" + _loc9_].init(this,1);
         this.conveyor_list.push("con_" + _loc9_);
      }
      else if(id == 237)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("stinger_robot","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.danger_holder["robot_" + _loc9_].init(this,this.player);
         this.robot_list.push("robot_" + _loc9_);
      }
      else if(id == 238)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("mine","mine_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 16});
         this.mine_list.push("mine_" + _loc9_);
         this.danger_holder["mine_" + _loc9_].init(this,id,this.findPath(row,col));
      }
      else if(id == 239)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("flyer_robot","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 16});
         this.robot_list.push("robot_" + _loc9_);
         this.danger_holder["robot_" + _loc9_].init(this,id,this.findPath(row,col));
      }
      else if(id == 241)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("spider","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 16});
         this.robot_list.push("robot_" + _loc9_);
         this.danger_holder["robot_" + _loc9_].init(this);
      }
      else if(id == 242)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("hive","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.robot_list.push("robot_" + _loc9_);
         this.danger_holder["robot_" + _loc9_].init(this);
         this.spawn_list["robot_" + _loc9_] = 0;
         this.left_spawn_list["robot_" + _loc9_] = 0;
         this.right_spawn_list["robot_" + _loc9_] = 0;
      }
      else if(id == 243)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("fish","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 16});
         this.robot_list.push("robot_" + _loc9_);
         this.danger_holder["robot_" + _loc9_].init(this);
      }
      else if(id >= 244 && id <= 246 || id == 273)
      {
         _global.solid_bmp.fillRect(new flash.geom.Rectangle(col * com.nitrome.toxic.Global.TILE_WIDTH,row * com.nitrome.toxic.Global.TILE_HEIGHT,32,32),33554431);
         _loc8_ = this.safe_holder.getNextHighestDepth();
         this.safe_holder.attachMovie("bomb_spawner","spawner_" + _loc8_,_loc8_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         if(id == 244)
         {
            _loc9_ = this.object_holder.getNextHighestDepth();
            this.object_holder.attachMovie("collect_platform","collect_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:(row - 1) * com.nitrome.toxic.Global.TILE_HEIGHT});
            this.collect_list.push("collect_" + _loc9_);
            this.object_holder["collect_" + _loc9_].init(this,2,this.safe_holder["spawner_" + _loc8_]);
         }
         else if(id == 245)
         {
            _loc9_ = this.object_holder.getNextHighestDepth();
            this.object_holder.attachMovie("collect_digger","collect_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:(row - 1) * com.nitrome.toxic.Global.TILE_HEIGHT});
            this.collect_list.push("collect_" + _loc9_);
            this.object_holder["collect_" + _loc9_].init(this,3,this.safe_holder["spawner_" + _loc8_]);
         }
         else if(id == 246)
         {
            _loc9_ = this.object_holder.getNextHighestDepth();
            this.object_holder.attachMovie("collect_walker","collect_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:(row - 1) * com.nitrome.toxic.Global.TILE_HEIGHT});
            this.collect_list.push("collect_" + _loc9_);
            this.object_holder["collect_" + _loc9_].init(this,4,this.safe_holder["spawner_" + _loc8_]);
         }
         else if(id == 273)
         {
            _loc9_ = this.object_holder.getNextHighestDepth();
            this.object_holder.attachMovie("collect_basic","collect_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:(row - 1) * com.nitrome.toxic.Global.TILE_HEIGHT});
            this.collect_list.push("collect_" + _loc9_);
            this.object_holder["collect_" + _loc9_].init(this,1,this.safe_holder["spawner_" + _loc8_]);
         }
      }
      else if(id >= 247 && id <= 248)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("cannon","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.robot_list.push("robot_" + _loc9_);
         this.danger_holder["robot_" + _loc9_].init(this,id - 247);
      }
      else if(id >= 249 && id <= 250)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("moving_cannon","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.robot_list.push("robot_" + _loc9_);
         this.danger_holder["robot_" + _loc9_].init(this,id - 249);
      }
      else if(id >= 251 && id <= 252)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("tall_cannon","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.robot_list.push("robot_" + _loc9_);
         this.danger_holder["robot_" + _loc9_].init(this,id - 251);
      }
      else if(id == 253 || id == 254)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("wheel_robot","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.robot_list.push("robot_" + _loc9_);
         this.danger_holder["robot_" + _loc9_].init(id - 253,this);
      }
      else if(id >= 255 && id <= 258)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("tile_" + id,"acid_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.acid_fall_list.push("acid_" + _loc9_);
      }
      else if(id == 259)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("shooter_robot","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.robot_list.push("robot_" + _loc9_);
         this.danger_holder["robot_" + _loc9_].init(this);
      }
      else if(id == 260)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("boss1","boss1",_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.robot_list.push("boss1");
         this.danger_holder.boss1.init(this);
         this.boss1 = true;
      }
      else if(id == 261)
      {
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("door","door_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         if(col == 16)
         {
            this.left_door_list.push("door_" + _loc9_);
            this.object_holder["door_" + _loc9_].init(this,0);
         }
         else
         {
            this.right_door_list.push("door_" + _loc9_);
            this.object_holder["door_" + _loc9_].init(this,1);
         }
      }
      else if(id == 275)
      {
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("first_door","door_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.object_holder["door_" + _loc9_].init(this);
         this.first_door_list.push("door_" + _loc9_);
         this.first_door_count = this.first_door_count + 1;
      }
      else if(id == 262)
      {
         _loc9_ = this.object_holder.getNextHighestDepth();
         this.object_holder.attachMovie("collapsing_platform","collapse_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT});
         this.collect_list.push("collapse_" + _loc9_);
         this.object_holder["collapse_" + _loc9_].init(this);
         this.drawCollapsePlatform(0,col * com.nitrome.toxic.Global.TILE_WIDTH,row * com.nitrome.toxic.Global.TILE_HEIGHT);
      }
      else if(id == 266)
      {
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("digger_robot","robot_" + _loc9_,_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.robot_list.push("robot_" + _loc9_);
         this.danger_holder["robot_" + _loc9_].init(this);
      }
      else if(id == 267)
      {
         _loc9_ = this.safe_holder.getNextHighestDepth();
         this.safe_holder.attachMovie("boss2","boss2",_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.safe_list.push("boss2");
         _loc9_ = this.grow_holder.getNextHighestDepth();
         this.grow_holder.attachMovie("boss2_grow_layer","boss2",_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32});
         this.boss2 = true;
         _global.temp_bmp = flash.display.BitmapData.loadBitmap("boss_solid_mask");
         _global.solid_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,174,239),new flash.geom.Point(col * com.nitrome.toxic.Global.TILE_WIDTH + 16 - 87,row * com.nitrome.toxic.Global.TILE_HEIGHT + 32 - 239));
         _global.temp_bmp.dispose();
         delete _global.temp_bmp;
         _loc9_ = this.heart_holder.getNextHighestDepth();
         this.heart_holder.attachMovie("boss_heart_hit","heart",_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16 - 19,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32 - 63});
         _loc9_ = this.laser_holder.getNextHighestDepth();
         this.laser_holder.attachMovie("boss_laser","boss_laser",_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32 - 149});
         this.laser_list.push("boss_laser");
         this.laser_holder.boss_laser.init(this);
         _loc7_ = new Array(0,-9,-5,5,9);
         _loc6_ = 1;
         while(_loc6_ <= 4)
         {
            _loc9_ = this.danger_holder.getNextHighestDepth();
            this.danger_holder.attachMovie("boss_debris","debris_" + _loc6_,_loc9_,{_x:(col + _loc7_[_loc6_]) * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:0});
            this.robot_list.push("debris_" + _loc6_);
            _loc6_ = _loc6_ + 1;
         }
         _loc9_ = this.danger_holder.getNextHighestDepth();
         this.danger_holder.attachMovie("boss_head","boss_head",_loc9_,{_x:col * com.nitrome.toxic.Global.TILE_WIDTH + 16,_y:row * com.nitrome.toxic.Global.TILE_HEIGHT + 32 - 149});
         this.robot_list.push("boss_head");
         this.safe_holder.boss2.init(this,this.laser_holder.boss_laser,this.danger_holder.debris_1,this.danger_holder.debris_2,this.danger_holder.debris_3,this.danger_holder.debris_4);
      }
   }
   function hitFinalBoss()
   {
      this.safe_holder.boss2.doHit();
   }
   function nextDoor(side)
   {
      if(side == 0)
      {
         this.left_door_count = this.left_door_count + 1;
         this.object_holder[this.left_door_list[this.left_door_count]].doClose();
      }
      else if(side == 1)
      {
         this.right_door_count = this.right_door_count + 1;
         this.object_holder[this.right_door_list[this.right_door_count]].doClose();
      }
   }
   function openDoor(side)
   {
      if(side == 0)
      {
         this.left_door_count = this.left_door_count - 1;
         this.object_holder[this.left_door_list[this.left_door_count]].doOpen();
      }
      else if(side == 1)
      {
         this.right_door_count = this.right_door_count - 1;
         this.object_holder[this.right_door_list[this.right_door_count]].doOpen();
      }
      else if(side == 3)
      {
         this.object_holder[this.first_door_list[this.first_door_count]].doOpen();
         this.first_door_count = this.first_door_count - 1;
      }
   }
   function drawCollapsePlatform(n, x, y)
   {
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("coll_" + n);
      _global.solid_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,32,32),new flash.geom.Point(x,y));
      _global.temp_bmp.dispose();
      delete _global.temp_bmp;
      _global.solid_bmp.threshold(_global.solid_bmp,new flash.geom.Rectangle(x,y,32,32),new flash.geom.Point(x,y),"==",4278255360,0,16777215,false);
   }
   function drawBossBody(x, y)
   {
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("final_boss_cover");
      _global.boss_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,182,162),new flash.geom.Point(x,y));
      _global.temp_bmp.dispose();
      delete _global.temp_bmp;
   }
   function drawDoor(x, y)
   {
      _global.solid_bmp.fillRect(new flash.geom.Rectangle(x,y,32,32),301989887);
   }
   function clearDoor(x, y)
   {
      _global.solid_bmp.fillRect(new flash.geom.Rectangle(x,y,32,32),4278255360);
      _global.solid_bmp.threshold(_global.solid_bmp,new flash.geom.Rectangle(x,y,32,32),new flash.geom.Point(x,y),"==",4278255360,0,16777215,false);
   }
   function displayHoloPlatform(n)
   {
      this.object_holder[n].doDisplay();
      _global.solid_bmp.fillRect(new flash.geom.Rectangle(this.object_holder[n].getCol() * com.nitrome.toxic.Global.TILE_WIDTH,this.object_holder[n].getRow() * com.nitrome.toxic.Global.TILE_HEIGHT,32,32),301989887);
   }
   function hideHoloPlatform(n)
   {
      var _loc4_ = this.object_holder[n].getCol() * com.nitrome.toxic.Global.TILE_WIDTH;
      var _loc3_ = this.object_holder[n].getRow() * com.nitrome.toxic.Global.TILE_HEIGHT;
      _global.solid_bmp.fillRect(new flash.geom.Rectangle(_loc4_,_loc3_,32,32),4278255360);
      _global.solid_bmp.threshold(_global.solid_bmp,new flash.geom.Rectangle(_loc4_,_loc3_,32,32),new flash.geom.Point(_loc4_,_loc3_),"==",4278255360,0,16777215,false);
      this.object_holder[n].doHide();
   }
   function loadInfoText(ts)
   {
      var _loc4_ = ts.childNodes;
      this.info_text = new Array();
      var _loc3_ = 0;
      var _loc2_;
      var _loc5_;
      var _loc7_;
      var _loc6_;
      while(_loc3_ < _loc4_.length)
      {
         _loc2_ = _loc4_[_loc3_];
         _loc5_ = Number(String(_loc2_.attributes.row));
         _loc7_ = Number(String(_loc2_.attributes.col));
         _loc6_ = String(_loc2_.attributes.str);
         _loc6_ = this.checkText(_loc6_);
         this.info_text.push({row:_loc5_,col:_loc7_,str:_loc6_});
         _loc3_ = _loc3_ + 1;
      }
   }
   function checkText(s)
   {
      var _loc2_;
      var _loc3_;
      var _loc1_;
      if(s.indexOf("&apos;") != -1)
      {
         _loc2_ = s.split("&apos;");
         _loc3_ = "";
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            _loc3_ += _loc2_[_loc1_];
            if(_loc1_ < _loc2_.length - 1)
            {
               _loc3_ += "\'";
            }
            _loc1_ = _loc1_ + 1;
         }
         s = _loc3_;
      }
      if(s.indexOf("|") != -1)
      {
         _loc2_ = s.split("|");
         _loc3_ = "";
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            _loc3_ += _loc2_[_loc1_];
            if(_loc1_ < _loc2_.length - 1)
            {
               _loc3_ += "\r";
            }
            _loc1_ = _loc1_ + 1;
         }
         s = _loc3_;
      }
      return s;
   }
   function getInfoText(row, col)
   {
      var _loc2_ = 0;
      while(_loc2_ < this.info_text.length)
      {
         if(this.info_text[_loc2_].row == row && this.info_text[_loc2_].col == col)
         {
            return this.info_text[_loc2_].str;
         }
         _loc2_ = _loc2_ + 1;
      }
      return "";
   }
   function getPlayerOnGround()
   {
      return this.player.getOnGround(this.player._x,this.player._y);
   }
   function transportPlayer(secret)
   {
      this.player.startTransport(secret);
   }
   function getRobotCollision(x, y)
   {
      if(this.danger_holder.hitTest(this._x + x,this._y + y,true) == true)
      {
         return true;
      }
      return false;
   }
   function getBombCollision(x, y)
   {
      if(this.bomb_holder.hitTest(this._x + x,this._y + y,true) == true)
      {
         return true;
      }
      return false;
   }
   function zapBomb(x, y)
   {
      var _loc2_;
      if(this.bomb_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.bomb_list.length)
         {
            if(this.bomb_holder[this.bomb_list[_loc2_]].hitTest(this._x + x,this._y + y,true) == true)
            {
               this.bomb_holder[this.bomb_list[_loc2_]].doExplode();
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function getLaserSceneryCollision(x, y)
   {
      var _loc2_ = _global.ground_bmp.getPixel32(x,y) >> 24 & 0xFF;
      var _loc3_ = _global.solid_bmp.getPixel32(x,y) >> 24 & 0xFF;
      if(_loc2_ > 0 || _loc3_ > 0)
      {
         return true;
      }
      return false;
   }
   function getSceneryCollision(x, y)
   {
      var _loc3_ = _global.ground_bmp.getPixel32(x,y) >> 24 & 0xFF;
      var _loc4_ = _global.solid_bmp.getPixel32(x,y) >> 24 & 0xFF;
      var _loc5_;
      if(this.boss2 == true)
      {
         _loc5_ = _global.boss_bmp.getPixel32(x,y) >> 24 & 0xFF;
         if(_loc3_ > 0 || _loc4_ > 0 || _loc5_ > 0)
         {
            return true;
         }
         return false;
      }
      if(_loc3_ > 0 || _loc4_ > 0)
      {
         return true;
      }
      return false;
   }
   function getGroundCollision(x, y)
   {
      var _loc3_ = _global.ground_bmp.getPixel32(x,y) >> 24 & 0xFF;
      var _loc4_;
      if(this.boss2 == true)
      {
         _loc4_ = _global.boss_bmp.getPixel32(x,y) >> 24 & 0xFF;
         if(_loc3_ > 0 || _loc4_ > 0)
         {
            return true;
         }
         return false;
      }
      if(_loc3_ > 0)
      {
         return true;
      }
      return false;
   }
   function getSolidCollision(x, y)
   {
      var _loc2_ = _global.solid_bmp.getPixel32(x,y) >> 24 & 0xFF;
      if(_loc2_ > 0)
      {
         return true;
      }
      return false;
   }
   function getGenesisCollision(x, y)
   {
      var _loc2_ = _global.genesis_bmp.getPixel32(x,y) >> 24 & 0xFF;
      if(_loc2_ > 0)
      {
         return true;
      }
      return false;
   }
   function fireBomb(x, y, vx, vy)
   {
      this.bomb_count = this.bomb_count + 1;
      var _loc2_ = String("bomb_" + this.bomb_count);
      this.bomb_holder.attachMovie("basic_bomb",_loc2_,this.bomb_count);
      this.bomb_holder[_loc2_].init(this,x,y,vx,vy);
      this.bomb_list.push(_loc2_);
   }
   function layBomb()
   {
      var _loc13_;
      var _loc5_;
      var _loc7_;
      var _loc8_;
      var _loc6_;
      var _loc9_;
      var _loc4_;
      var _loc11_;
      var _loc10_;
      var _loc12_;
      if(com.nitrome.toxic.Global.game_paused == false && this.player.getQuickPause() == false)
      {
         _loc13_ = this.player.getDir();
         _loc5_ = this.player.getState();
         _loc7_ = this.player.getBombType();
         if(_loc5_ != com.nitrome.toxic.Global.START && _loc5_ != com.nitrome.toxic.Global.END && _loc5_ != com.nitrome.toxic.Global.HIT && _loc5_ != com.nitrome.toxic.Global.WALL && _loc5_ != com.nitrome.toxic.Global.DIE)
         {
            this.bomb_count = this.bomb_count + 1;
            _loc8_ = String("bomb_" + this.bomb_count);
            _root.bomb_shape.gotoAndStop(_loc7_);
            if(_loc5_ == com.nitrome.toxic.Global.DUCK && this.getWalkerBombs() == true)
            {
               trace("bomb_list: " + this.bomb_list.toString());
               if(this.bomb_list.length > 0)
               {
                  this.player.anim.play();
                  _loc4_ = 0;
                  while(_loc4_ < this.bomb_list.length)
                  {
                     if(this.bomb_holder[this.bomb_list[_loc4_]].getBombType() == com.nitrome.toxic.Global.BOMB_WALKER)
                     {
                        this.bomb_holder[this.bomb_list[_loc4_]].doExplode();
                        _loc4_ = _loc4_ - 1;
                     }
                     _loc4_ = _loc4_ + 1;
                  }
               }
               return undefined;
            }
            if(_loc7_ == 1)
            {
               this.bomb_holder.attachMovie("basic_bomb",_loc8_,this.bomb_count);
               _loc6_ = this.player._x + this.player.bomb_start_pos._x;
               _loc9_ = this.player._y + this.player.bomb_start_pos._y;
            }
            else if(_loc7_ == 2)
            {
               this.bomb_holder.attachMovie("platform_bomb",_loc8_,this.bomb_count);
               _loc6_ = this.player._x + this.player.platform_start_pos._x;
               _loc9_ = this.player._y + this.player.platform_start_pos._y;
            }
            else if(_loc7_ == 3)
            {
               this.bomb_holder.attachMovie("digger_bomb",_loc8_,this.bomb_count);
               _loc6_ = this.player._x + this.player.bomb_start_pos._x;
               _loc9_ = this.player._y + this.player.bomb_start_pos._y;
            }
            else if(_loc7_ == 4)
            {
               if(_loc5_ == com.nitrome.toxic.Global.DUCK && this.getWalkerBombs() == true)
               {
                  trace("bomb_list: " + this.bomb_list.toString());
                  if(this.bomb_list.length > 0)
                  {
                     this.player.anim.play();
                     _loc4_ = 0;
                     while(_loc4_ < this.bomb_list.length)
                     {
                        if(this.bomb_holder[this.bomb_list[_loc4_]].getBombType() == com.nitrome.toxic.Global.BOMB_WALKER)
                        {
                           this.bomb_holder[this.bomb_list[_loc4_]].doExplode();
                           _loc4_ = _loc4_ - 1;
                        }
                        _loc4_ = _loc4_ + 1;
                     }
                  }
                  return undefined;
               }
               this.bomb_holder.attachMovie("walker_bomb",_loc8_,this.bomb_count);
               _loc6_ = this.player._x + this.player.bomb_start_pos._x;
               _loc9_ = this.player._y + this.player.bomb_start_pos._y;
            }
            _loc11_ = false;
            if(_loc7_ != 3)
            {
               _loc10_ = new flash.geom.Matrix();
               _loc10_.tx -= _loc6_ - _root.bomb_shape._width * 0.5;
               _loc10_.ty -= _loc9_ - _root.bomb_shape._height * 0.5;
               _global.b_temp = new flash.display.BitmapData(_root.bomb_shape._width,_root.bomb_shape._height,true,16777215);
               _global.b_temp.draw(_root.game.solid_holder,_loc10_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
               _global.b_temp.draw(_root.game.ground_holder,_loc10_,new flash.geom.ColorTransform(1,1,1,1,255,-255,-255,255));
               _global.b_temp.draw(_root.bomb_shape,new flash.geom.Matrix(),new flash.geom.ColorTransform(1,1,1,1,255,255,255,255),"difference");
               _loc12_ = _global.b_temp.getColorBoundsRect(4294967295,4278255615);
               if(_loc12_.width != 0)
               {
                  if(_loc12_.x == 0)
                  {
                     _loc11_ = true;
                     _loc6_ += _root.bomb_shape._width;
                  }
                  else
                  {
                     _loc11_ = true;
                     _loc6_ -= _root.bomb_shape._width;
                  }
               }
               _global.b_temp.dispose();
               delete _global.b_temp;
            }
            this.bomb_holder[_loc8_].initPlayer(this,_loc6_,_loc9_,_loc13_,_loc5_,this.player.getVX(),this.player.getVY(),_loc11_);
            _root.bomb_panel.useBomb();
            this.bomb_list.push(_loc8_);
         }
      }
   }
   function getWalkerBombs()
   {
      var _loc2_;
      if(this.bomb_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.bomb_list.length)
         {
            if(this.bomb_holder[this.bomb_list[_loc2_]].getBombType() == com.nitrome.toxic.Global.BOMB_WALKER)
            {
               return true;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
      return false;
   }
   function broadcastJump()
   {
      var _loc2_;
      if(this.bomb_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.bomb_list.length)
         {
            this.bomb_holder[this.bomb_list[_loc2_]].startJump();
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function setBombType(bomb_type)
   {
      this.player.setBombType(bomb_type);
   }
   function updateBombs()
   {
      var _loc2_;
      if(this.bomb_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.bomb_list.length)
         {
            this.bomb_holder[this.bomb_list[_loc2_]].main();
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateBombName(old_name, new_name)
   {
      var _loc2_;
      if(this.bomb_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.bomb_list.length)
         {
            if(this.bomb_list[_loc2_] == old_name)
            {
               this.bomb_list[_loc2_] = new_name;
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function removeBomb(id)
   {
      var _loc2_;
      if(this.bomb_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.bomb_list.length)
         {
            if(this.bomb_list[_loc2_] == id)
            {
               this.bomb_list.splice(_loc2_,1);
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function removeMissile(id)
   {
      trace("removing missile: " + id);
      var _loc2_;
      if(this.missile_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.missile_list.length)
         {
            if(this.missile_list[_loc2_] == id)
            {
               this.missile_list.splice(_loc2_,1);
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateRobots()
   {
      var _loc2_;
      if(this.robot_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.robot_list.length)
         {
            this.danger_holder[this.robot_list[_loc2_]].main();
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateSafeRobots()
   {
      var _loc2_;
      if(this.safe_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.safe_list.length)
         {
            this.safe_holder[this.safe_list[_loc2_]].main();
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateMines()
   {
      var _loc2_;
      if(this.mine_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.mine_list.length)
         {
            this.danger_holder[this.mine_list[_loc2_]].main();
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateConveyorBelts()
   {
      var _loc2_;
      if(this.conveyor_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.conveyor_list.length)
         {
            this.object_holder[this.conveyor_list[_loc2_]].main();
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function checkMineProximity(x, y)
   {
      var _loc2_;
      if(this.mine_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.mine_list.length)
         {
            this.danger_holder[this.mine_list[_loc2_]].checkProximity(x,y);
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateHoloButtons()
   {
      var _loc2_;
      if(this.active_holo_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.active_holo_list.length)
         {
            this.object_holder[this.active_holo_list[_loc2_]].main();
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function findExplodeRobot(explosion)
   {
      var _loc2_;
      if(this.robot_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.robot_list.length)
         {
            if(this.danger_holder[this.robot_list[_loc2_]].hitTest(this.explosion_holder[explosion]) == true)
            {
               this.danger_holder[this.robot_list[_loc2_]].doExplode();
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function findExplodeHoloButton(explosion)
   {
      var _loc2_;
      if(this.holo_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.holo_list.length)
         {
            if(this.object_holder[this.holo_list[_loc2_]].hitTest(this.explosion_holder[explosion]) == true)
            {
               this.active_holo_list.push(this.holo_list[_loc2_]);
               this.object_holder[this.holo_list[_loc2_]].doActivate();
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function removeHoloButton(id)
   {
      var _loc2_;
      if(this.active_holo_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.active_holo_list.length)
         {
            if(this.active_holo_list[_loc2_] == id)
            {
               this.active_holo_list.splice(_loc2_,1);
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function checkRobotList(id)
   {
      var _loc3_ = false;
      var _loc2_;
      if(this.robot_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.robot_list.length)
         {
            if(this.robot_list[_loc2_] == id)
            {
               _loc3_ = true;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
      if(_loc3_ == false)
      {
         this.robot_list.push(id);
      }
   }
   function removeRobot(id)
   {
      var _loc4_ = false;
      var _loc2_;
      if(this.robot_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.robot_list.length)
         {
            if(this.robot_list[_loc2_] == id)
            {
               this.robot_list.splice(_loc2_,1);
               _loc4_ = true;
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
      if(_loc4_ == false)
      {
         if(this.mine_list.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mine_list.length)
            {
               if(this.mine_list[_loc2_] == id)
               {
                  this.mine_list.splice(_loc2_,1);
                  break;
               }
               _loc2_ = _loc2_ + 1;
            }
         }
      }
   }
   function findCollectObject()
   {
      var _loc2_;
      if(this.collect_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.collect_list.length)
         {
            if(this.object_holder[this.collect_list[_loc2_]].hitTest(this.player_holder.player) == true)
            {
               if(this.object_holder[this.collect_list[_loc2_]].getInfoPoint() == true)
               {
                  this.last_collect_object = this.collect_list[_loc2_];
               }
               this.object_holder[this.collect_list[_loc2_]].doCollect();
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function findConveyor(mc)
   {
      var _loc2_;
      if(this.conveyor_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.conveyor_list.length)
         {
            if(this.object_holder[this.conveyor_list[_loc2_]].hitTest(mc) == true)
            {
               this.conveyorObject(mc,this.object_holder[this.conveyor_list[_loc2_]].getSpeed());
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function checkLastCollectObject()
   {
      if(this.object_holder[this.last_collect_object].hitTest(this.player_holder.player) == false)
      {
         this.object_holder[this.last_collect_object].endCollect();
      }
   }
   function removeObject(id)
   {
      var _loc2_;
      if(this.collect_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.collect_list.length)
         {
            if(this.collect_list[_loc2_] == id)
            {
               this.collect_list.splice(_loc2_,1);
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateBullets()
   {
      var _loc2_;
      if(this.bullet_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.bullet_list.length)
         {
            this.danger_holder[this.bullet_list[_loc2_]].main();
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateMissiles()
   {
      var _loc2_;
      if(this.missile_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.missile_list.length)
         {
            this.missile_holder[this.missile_list[_loc2_]].main();
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function removeBullet(id)
   {
      var _loc2_;
      if(this.bullet_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.bullet_list.length)
         {
            if(this.bullet_list[_loc2_] == id)
            {
               this.bullet_list.splice(_loc2_,1);
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function fireBullet(x, y, dir)
   {
      var _loc2_ = this.danger_holder.getNextHighestDepth();
      this.danger_holder.attachMovie("bullet","bullet_" + _loc2_,_loc2_,{_x:x,_y:y});
      this.bullet_list.push("bullet_" + _loc2_);
      this.danger_holder["bullet_" + _loc2_].init(this,dir);
   }
   function fireShooterBullet(x, y, dir)
   {
      var _loc2_ = this.danger_holder.getNextHighestDepth();
      this.danger_holder.attachMovie("shooter_bullet","bullet_" + _loc2_,_loc2_,{_x:x,_y:y});
      this.bullet_list.push("bullet_" + _loc2_);
      this.danger_holder["bullet_" + _loc2_].init(this,dir);
   }
   function fireBossBullet(x, y, dir)
   {
      var _loc2_ = this.danger_holder.getNextHighestDepth();
      this.danger_holder.attachMovie("boss_bullet","bullet_" + _loc2_,_loc2_,{_x:x,_y:y});
      this.bullet_list.push("bullet_" + _loc2_);
      this.danger_holder["bullet_" + _loc2_].init(this,dir);
   }
   function fireMissile(x, y, deg)
   {
      this.missile_count = this.missile_count + 1;
      var _loc2_ = 500 + this.missile_count;
      this.missile_holder.attachMovie("boss_missile","missile_" + _loc2_,_loc2_,{_x:x,_y:y});
      this.missile_list.push("missile_" + _loc2_);
      this.missile_holder["missile_" + _loc2_].init(this,deg);
   }
   function createDebris(x, y, debris_array)
   {
      var _loc2_ = 0;
      var _loc3_;
      var _loc7_;
      var _loc5_;
      var _loc6_;
      while(_loc2_ < debris_array.length)
      {
         _loc3_ = this.debris_holder.getNextHighestDepth();
         _loc7_ = debris_array[_loc2_].id;
         _loc5_ = debris_array[_loc2_].x;
         _loc6_ = debris_array[_loc2_].y;
         this.debris_holder.attachMovie("debris_" + _loc7_,"debris_" + _loc3_,_loc3_,{_x:x + _loc5_,_y:y + _loc6_});
         this.debris_holder["debris_" + _loc3_].init(this);
         this.debris_list.push("debris_" + _loc3_);
         _loc2_ = _loc2_ + 1;
      }
   }
   function removeDebris(id)
   {
      var _loc2_;
      if(this.debris_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.debris_list.length)
         {
            if(this.debris_list[_loc2_] == id)
            {
               this.debris_list.splice(_loc2_,1);
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateDebris()
   {
      var _loc2_;
      if(this.debris_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.debris_list.length)
         {
            this.debris_holder[this.debris_list[_loc2_]].main();
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateLasers()
   {
      var _loc2_;
      if(this.laser_list.length > 0)
      {
         _loc2_ = 0;
         while(_loc2_ < this.laser_list.length)
         {
            this.laser_holder[this.laser_list[_loc2_]].main();
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function conveyorObject(mc, vx)
   {
      mc.conveyor(vx);
   }
   function createExplosion(x, y, id, ex_id, dir)
   {
      var _loc4_ = this.explosion_holder.getNextHighestDepth();
      this.explosion_holder.attachMovie(String("explosion" + ex_id),id,_loc4_,{_x:x,_y:y - 10});
      this.explosion_holder[id].init(this,ex_id,dir);
      if(ex_id == com.nitrome.toxic.Global.BOMB_BASIC)
      {
         this.removeBomb(id);
      }
      else if(ex_id == com.nitrome.toxic.Global.BOMB_PLATFORM)
      {
         this.removeBomb(id);
      }
      else if(ex_id == com.nitrome.toxic.Global.BOMB_DIGGER)
      {
         if(this.bomb_holder[id].getFinishedExplode() == true)
         {
            this.removeBomb(id);
         }
      }
      else if(ex_id == com.nitrome.toxic.Global.BOMB_WALKER)
      {
         this.removeBomb(id);
      }
      else if(ex_id != com.nitrome.toxic.Global.BOMB_BOSS)
      {
         if(ex_id == 100)
         {
            if(id != "boss1")
            {
               this.removeRobot(id);
            }
         }
      }
      this.startScreenShake();
   }
   function startScreenShake()
   {
      this.screen_shake = 15;
   }
   function drawPlatformBomb(x, y)
   {
      x -= 16;
      y -= 7;
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("platform_bomb_shape");
      _global.ground_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,31,15),new flash.geom.Point(x,y));
      _global.temp_bmp.dispose();
      delete _global.temp_bmp;
   }
   function cutBossHole(x, y, id)
   {
      if(this.bomb_holder[id].getFinishedExplode() == true)
      {
         this.bomb_holder[id].removeMovieClip();
      }
      _global.temp_bmp = new flash.display.BitmapData(80,80,true,16777215);
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("bomb_border");
      _global.boss_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,80,80),new flash.geom.Point(x - 40,y - 40),_global.boss_bmp,new flash.geom.Point(x - 40,y - 40),true);
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("bomb_hole");
      _global.boss_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,80,80),new flash.geom.Point(x - 40,y - 40),_global.boss_bmp,new flash.geom.Point(x - 40,y - 40),true);
      _global.boss_bmp.threshold(_global.boss_bmp,new flash.geom.Rectangle(x - 40,y - 40,80,80),new flash.geom.Point(x - 40,y - 40),"==",4278255360,0,16777215,false);
      var _loc3_ = x - 40;
      var _loc5_;
      var _loc4_;
      var _loc10_;
      var _loc11_;
      var _loc13_;
      var _loc9_;
      var _loc12_;
      var _loc8_;
      while(_loc3_ <= x - 40 + 80)
      {
         _loc5_ = y - 40;
         while(_loc5_ <= y - 40 + 80)
         {
            _loc4_ = _global.boss_bmp.getPixel32(_loc3_,_loc5_);
            _loc10_ = _loc4_ >> 24 & 0xFF;
            _loc11_ = _loc4_ >> 16 & 0xFF;
            _loc13_ = _loc4_ >> 8 & 0xFF;
            _loc9_ = _loc4_ & 0xFF;
            if(_loc10_ == 255 && _loc11_ == 68 && _loc13_ == 82 && _loc9_ == 76)
            {
               _loc12_ = _global.boss_bmp.getPixel32(_loc3_,_loc5_ - 1);
               _loc8_ = _loc12_ >> 24 & 0xFF;
               if(_loc8_ == 0)
               {
                  _global.boss_bmp.setPixel32(_loc3_,_loc5_,4278190080);
                  break;
               }
            }
            _loc5_ = _loc5_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
      _loc5_ = y - 40;
      while(_loc5_ <= y - 40 + 80)
      {
         _loc3_ = x - 40;
         while(_loc3_ <= x - 40 + 80)
         {
            _loc4_ = _global.boss_bmp.getPixel32(_loc3_,_loc5_);
            _loc10_ = _loc4_ >> 24 & 0xFF;
            _loc11_ = _loc4_ >> 16 & 0xFF;
            _loc13_ = _loc4_ >> 8 & 0xFF;
            _loc9_ = _loc4_ & 0xFF;
            if(_loc10_ == 255 && _loc11_ == 68 && _loc13_ == 82 && _loc9_ == 76)
            {
               _loc12_ = _global.boss_bmp.getPixel32(_loc3_ - 1,_loc5_);
               _loc8_ = _loc12_ >> 24 & 0xFF;
               if(_loc8_ == 0)
               {
                  _global.boss_bmp.setPixel32(_loc3_,_loc5_,4278190080);
                  break;
               }
            }
            _loc3_ = _loc3_ + 1;
         }
         _loc5_ = _loc5_ + 1;
      }
      _global.temp_bmp.dispose();
      delete _global.temp_bmp;
   }
   function cutHole(x, y, id)
   {
      var _loc3_;
      var _loc5_;
      var _loc4_;
      var _loc10_;
      var _loc11_;
      var _loc13_;
      var _loc9_;
      var _loc12_;
      var _loc8_;
      if(this.boss2 == true)
      {
         this.cutBossHole(x,y,id);
      }
      else
      {
         if(this.bomb_holder[id].getFinishedExplode() == true)
         {
            this.bomb_holder[id].removeMovieClip();
         }
         _global.temp_bmp = new flash.display.BitmapData(80,80,true,16777215);
         _global.temp_bmp = flash.display.BitmapData.loadBitmap("bomb_border");
         _global.ground_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,80,80),new flash.geom.Point(x - 40,y - 40),_global.ground_bmp,new flash.geom.Point(x - 40,y - 40),true);
         _global.temp_bmp = flash.display.BitmapData.loadBitmap("bomb_hole");
         _global.ground_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,80,80),new flash.geom.Point(x - 40,y - 40),_global.ground_bmp,new flash.geom.Point(x - 40,y - 40),true);
         _global.ground_bmp.threshold(_global.ground_bmp,new flash.geom.Rectangle(x - 40,y - 40,80,80),new flash.geom.Point(x - 40,y - 40),"==",4278255360,0,16777215,false);
         _loc3_ = x - 40;
         while(_loc3_ <= x - 40 + 80)
         {
            _loc5_ = y - 40;
            while(_loc5_ <= y - 40 + 80)
            {
               _loc4_ = _global.ground_bmp.getPixel32(_loc3_,_loc5_);
               _loc10_ = _loc4_ >> 24 & 0xFF;
               _loc11_ = _loc4_ >> 16 & 0xFF;
               _loc13_ = _loc4_ >> 8 & 0xFF;
               _loc9_ = _loc4_ & 0xFF;
               if(_loc10_ == 255 && _loc11_ == 68 && _loc13_ == 82 && _loc9_ == 76)
               {
                  _loc12_ = _global.ground_bmp.getPixel32(_loc3_,_loc5_ - 1);
                  _loc8_ = _loc12_ >> 24 & 0xFF;
                  if(_loc8_ == 0)
                  {
                     _global.ground_bmp.setPixel32(_loc3_,_loc5_,4278190080);
                     break;
                  }
               }
               _loc5_ = _loc5_ + 1;
            }
            _loc3_ = _loc3_ + 1;
         }
         _loc5_ = y - 40;
         while(_loc5_ <= y - 40 + 80)
         {
            _loc3_ = x - 40;
            while(_loc3_ <= x - 40 + 80)
            {
               _loc4_ = _global.ground_bmp.getPixel32(_loc3_,_loc5_);
               _loc10_ = _loc4_ >> 24 & 0xFF;
               _loc11_ = _loc4_ >> 16 & 0xFF;
               _loc13_ = _loc4_ >> 8 & 0xFF;
               _loc9_ = _loc4_ & 0xFF;
               if(_loc10_ == 255 && _loc11_ == 68 && _loc13_ == 82 && _loc9_ == 76)
               {
                  _loc12_ = _global.ground_bmp.getPixel32(_loc3_ - 1,_loc5_);
                  _loc8_ = _loc12_ >> 24 & 0xFF;
                  if(_loc8_ == 0)
                  {
                     _global.ground_bmp.setPixel32(_loc3_,_loc5_,4278190080);
                     break;
                  }
               }
               _loc3_ = _loc3_ + 1;
            }
            _loc5_ = _loc5_ + 1;
         }
         _global.temp_bmp.dispose();
         delete _global.temp_bmp;
         if(this.genesis == true)
         {
            _global.temp_bmp = new flash.display.BitmapData(80,80,true,16777215);
            _global.temp_bmp = flash.display.BitmapData.loadBitmap("transparent_hole");
            _global.solid_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,80,80),new flash.geom.Point(x - 41,y - 41),_global.genesis_bmp,new flash.geom.Point(x - 41,y - 41),true);
         }
      }
   }
   function startCreateGround(x, y)
   {
      if(this.genesis == true)
      {
         this.genesis_list.push({x:x,y:y,frame:0});
      }
   }
   function createGround()
   {
      var _loc3_;
      var _loc5_;
      var _loc4_;
      var _loc6_;
      if(this.genesis == true)
      {
         if(this.genesis_list.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.genesis_list.length)
            {
               this.genesis_list[_loc3_].frame = this.genesis_list[_loc3_].frame + 1;
               _loc5_ = this.genesis_list[_loc3_].x;
               _loc4_ = this.genesis_list[_loc3_].y;
               _loc6_ = this.genesis_list[_loc3_].frame;
               _global.temp_bmp = new flash.display.BitmapData(80,80,true,16777215);
               _global.temp_bmp = flash.display.BitmapData.loadBitmap("ground_grow_" + _loc6_);
               _global.solid_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,80,80),new flash.geom.Point(_loc5_ - 41,_loc4_ - 41),_global.genesis_bmp,new flash.geom.Point(_loc5_ - 41,_loc4_ - 41),true);
               if(_loc6_ == 14)
               {
                  this.genesis_list.splice(_loc3_,1);
                  _loc3_ = _loc3_ - 1;
               }
               _loc3_ = _loc3_ + 1;
            }
         }
      }
   }
   function cutDiggerRobotHole(x, y)
   {
      x -= 22;
      y -= 26;
      _global.temp_bmp = new flash.display.BitmapData(44,28,true,16777215);
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("bomb_border_digger");
      _global.ground_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,44,28),new flash.geom.Point(x,y),_global.ground_bmp,new flash.geom.Point(x,y),true);
      _global.temp_bmp = flash.display.BitmapData.loadBitmap("bomb_hole_digger");
      _global.ground_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,44,28),new flash.geom.Point(x,y),_global.ground_bmp,new flash.geom.Point(x,y),true);
      _global.ground_bmp.threshold(_global.ground_bmp,new flash.geom.Rectangle(x,y,44,28),new flash.geom.Point(x,y),"==",4278255360,0,16777215,false);
   }
   function cutDiggerHole(x, y, id, dir)
   {
      var _loc5_;
      var _loc2_;
      var _loc3_;
      var _loc9_;
      var _loc10_;
      var _loc12_;
      var _loc8_;
      var _loc11_;
      var _loc7_;
      if(dir == com.nitrome.toxic.Global.UP || dir == com.nitrome.toxic.Global.DOWN)
      {
         if(dir == com.nitrome.toxic.Global.DOWN)
         {
            x -= 40;
            y -= 48;
         }
         else if(dir == com.nitrome.toxic.Global.UP)
         {
            x -= 40;
            y += 2;
         }
         _global.temp_bmp = new flash.display.BitmapData(80,46,true,16777215);
         _global.temp_bmp = flash.display.BitmapData.loadBitmap("bomb_border_vert");
         _global.ground_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,80,46),new flash.geom.Point(x,y),_global.ground_bmp,new flash.geom.Point(x,y),true);
         _global.temp_bmp = flash.display.BitmapData.loadBitmap("bomb_hole_vert");
         _global.ground_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,80,46),new flash.geom.Point(x,y),_global.ground_bmp,new flash.geom.Point(x,y),true);
         _global.ground_bmp.threshold(_global.ground_bmp,new flash.geom.Rectangle(x,y,80,46),new flash.geom.Point(x,y),"==",4278255360,0,16777215,false);
         _loc5_ = x;
         while(_loc5_ <= x + 80)
         {
            _loc2_ = y;
            while(_loc2_ <= y + 46)
            {
               _loc3_ = _global.ground_bmp.getPixel32(_loc5_,_loc2_);
               _loc9_ = _loc3_ >> 24 & 0xFF;
               _loc10_ = _loc3_ >> 16 & 0xFF;
               _loc12_ = _loc3_ >> 8 & 0xFF;
               _loc8_ = _loc3_ & 0xFF;
               if(_loc9_ == 255 && _loc10_ == 68 && _loc12_ == 82 && _loc8_ == 76)
               {
                  _loc11_ = _global.ground_bmp.getPixel32(_loc5_,_loc2_ - 1);
                  _loc7_ = _loc11_ >> 24 & 0xFF;
                  if(_loc7_ == 0)
                  {
                     _global.ground_bmp.setPixel32(_loc5_,_loc2_,4278190080);
                     break;
                  }
               }
               _loc2_ = _loc2_ + 1;
            }
            _loc5_ = _loc5_ + 1;
         }
         _global.temp_bmp.dispose();
         delete _global.temp_bmp;
      }
      else if(dir == com.nitrome.toxic.Global.LEFT || dir == com.nitrome.toxic.Global.RIGHT)
      {
         if(dir == com.nitrome.toxic.Global.RIGHT)
         {
            x -= 48;
            y -= 40;
         }
         else if(dir == com.nitrome.toxic.Global.LEFT)
         {
            x += 2;
            y -= 40;
         }
         _global.temp_bmp = new flash.display.BitmapData(46,80,true,16777215);
         _global.temp_bmp = flash.display.BitmapData.loadBitmap("bomb_border_horiz");
         _global.ground_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,46,80),new flash.geom.Point(x,y),_global.ground_bmp,new flash.geom.Point(x,y),true);
         _global.temp_bmp = flash.display.BitmapData.loadBitmap("bomb_hole_horiz");
         _global.ground_bmp.copyPixels(_global.temp_bmp,new flash.geom.Rectangle(0,0,46,80),new flash.geom.Point(x,y),_global.ground_bmp,new flash.geom.Point(x,y),true);
         _global.ground_bmp.threshold(_global.ground_bmp,new flash.geom.Rectangle(x,y,46,80),new flash.geom.Point(x,y),"==",4278255360,0,16777215,false);
         _loc5_ = x;
         while(_loc5_ <= x + 46)
         {
            _loc2_ = y;
            while(_loc2_ <= y + 80)
            {
               _loc3_ = _global.ground_bmp.getPixel32(_loc5_,_loc2_);
               _loc9_ = _loc3_ >> 24 & 0xFF;
               _loc10_ = _loc3_ >> 16 & 0xFF;
               _loc12_ = _loc3_ >> 8 & 0xFF;
               _loc8_ = _loc3_ & 0xFF;
               if(_loc9_ == 255 && _loc10_ == 68 && _loc12_ == 82 && _loc8_ == 76)
               {
                  _loc11_ = _global.ground_bmp.getPixel32(_loc5_,_loc2_ - 1);
                  _loc7_ = _loc11_ >> 24 & 0xFF;
                  if(_loc7_ == 0)
                  {
                     _global.ground_bmp.setPixel32(_loc5_,_loc2_,4278190080);
                     break;
                  }
               }
               _loc2_ = _loc2_ + 1;
            }
            _loc5_ = _loc5_ + 1;
         }
         _global.temp_bmp.dispose();
         delete _global.temp_bmp;
      }
   }
   function checkKeys()
   {
      if(Key.isDown(37) || Key.isDown(39) || Key.isDown(65) || Key.isDown(68))
      {
         if((Key.isDown(37) || Key.isDown(65)) && (Key.isDown(39) || Key.isDown(68)))
         {
            if(com.nitrome.toxic.Global.LAST_DIR_PRESSED == com.nitrome.toxic.Global.LEFT)
            {
               com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
            }
            else if(com.nitrome.toxic.Global.LAST_DIR_PRESSED == com.nitrome.toxic.Global.RIGHT)
            {
               com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
            }
         }
         else if(Key.isDown(37) || Key.isDown(65))
         {
            com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.LEFT;
         }
         else if(Key.isDown(39) || Key.isDown(68))
         {
            com.nitrome.toxic.Global.DIR_PRESSED = com.nitrome.toxic.Global.RIGHT;
         }
      }
      else
      {
         com.nitrome.toxic.Global.DIR_PRESSED = -1;
      }
      if(!Key.isDown(38) && !Key.isDown(87))
      {
         com.nitrome.toxic.Global.UP_PRESSED = false;
      }
      if(!Key.isDown(40) && !Key.isDown(83))
      {
         com.nitrome.toxic.Global.DOWN_PRESSED = false;
      }
   }
   function doSplash(x, y)
   {
      var _loc3_ = this.splash_holder.getNextHighestDepth();
      this.splash_holder.attachMovie("splash","splash_" + _loc3_,_loc3_,{_x:x,_y:y});
      _root.sfx.playSound("splash");
   }
   function finishSplash(n)
   {
      this.splash_holder[n].removeMovieClip();
   }
   function loadLaserPaths(laser_path)
   {
      this.laser_data = new Array();
      var _loc8_ = laser_path.childNodes;
      var _loc4_ = 0;
      var _loc7_;
      var _loc6_;
      var _loc5_;
      var _loc3_;
      var _loc2_;
      while(_loc4_ < _loc8_.length)
      {
         _loc7_ = _loc8_[_loc4_];
         _loc6_ = String(_loc7_.firstChild);
         _loc5_ = _loc6_.split(":");
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            _loc2_ = _loc5_[_loc3_].split(",");
            if(_loc3_ == 0)
            {
               this.laser_data[_loc4_] = new com.nitrome.toxic.Path(_loc2_[0],_loc2_[1]);
            }
            else
            {
               this.laser_data[_loc4_].addPoint(_loc2_[0],_loc2_[1]);
            }
            _loc3_ = _loc3_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function findPath(start_row, start_col)
   {
      var _loc2_ = 0;
      while(_loc2_ < this.laser_data.length)
      {
         if(this.laser_data[_loc2_].getStartRow() == start_row && this.laser_data[_loc2_].getStartCol() == start_col)
         {
            return this.laser_data[_loc2_];
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function loadHoloPaths(holo_path)
   {
      this.holo_data = new Array();
      var _loc8_ = holo_path.childNodes;
      var _loc4_ = 0;
      var _loc7_;
      var _loc6_;
      var _loc5_;
      var _loc3_;
      var _loc2_;
      while(_loc4_ < _loc8_.length)
      {
         _loc7_ = _loc8_[_loc4_];
         _loc6_ = String(_loc7_.firstChild);
         _loc5_ = _loc6_.split(":");
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            _loc2_ = _loc5_[_loc3_].split(",");
            if(_loc3_ == 0)
            {
               this.holo_data[_loc4_] = new com.nitrome.toxic.Path(_loc2_[0],_loc2_[1]);
            }
            else
            {
               this.holo_data[_loc4_].addPoint(_loc2_[0],_loc2_[1]);
            }
            _loc3_ = _loc3_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function findHoloPath(start_row, start_col)
   {
      var _loc2_ = 0;
      while(_loc2_ < this.holo_data.length)
      {
         if(this.holo_data[_loc2_].getStartRow() == start_row && this.holo_data[_loc2_].getStartCol() == start_col)
         {
            return this.holo_data[_loc2_];
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function addHoloTile(n, row, col)
   {
      var _loc3_ = 0;
      var _loc4_;
      var _loc6_;
      var _loc5_;
      var _loc7_;
      var _loc2_;
      while(_loc3_ < this.holo_data.length)
      {
         _loc4_ = this.holo_data[_loc3_].getRows();
         _loc6_ = this.holo_data[_loc3_].getCols();
         _loc5_ = false;
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            if(_loc4_[_loc2_] == row && _loc6_[_loc2_] == col)
            {
               _loc7_ = _loc3_;
               _loc5_ = true;
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
         if(_loc5_ == true)
         {
            break;
         }
         _loc3_ = _loc3_ + 1;
      }
      this.holo_data[_loc3_].addHoloTile(n,row,col);
   }
   function getSpawnCount(n)
   {
      return this.spawn_list[n];
   }
   function incrementSpawn(n)
   {
      this.spawn_list[n] = this.spawn_list[n] + 1;
   }
   function decrementSpawn(n)
   {
      this.spawn_list[n]--;
   }
   function spawnBot(n, x, y, dir)
   {
      var _loc2_ = this.danger_holder.getNextHighestDepth();
      this.danger_holder.attachMovie("bot","robot_" + _loc2_,_loc2_,{_x:x,_y:y});
      this.robot_list.push("robot_" + _loc2_);
      this.danger_holder["robot_" + _loc2_].init(this,n,dir);
      this.incrementSpawn(n);
      if(dir == com.nitrome.toxic.Global.LEFT)
      {
         this.incrementSpawnLeft(n);
      }
      else if(dir == com.nitrome.toxic.Global.RIGHT)
      {
         this.incrementSpawnRight(n);
      }
   }
   function getSpawnCountLeft(n)
   {
      return this.left_spawn_list[n];
   }
   function incrementSpawnLeft(n)
   {
      this.left_spawn_list[n] = this.left_spawn_list[n] + 1;
   }
   function decrementSpawnLeft(n)
   {
      this.left_spawn_list[n]--;
   }
   function getSpawnCountRight(n)
   {
      return this.right_spawn_list[n];
   }
   function incrementSpawnRight(n)
   {
      this.right_spawn_list[n] = this.right_spawn_list[n] + 1;
   }
   function decrementSpawnRight(n)
   {
      this.right_spawn_list[n]--;
   }
   function pauseGame()
   {
      com.nitrome.toxic.Global.game_paused = true;
      this.player.doPause();
      var _loc3_;
      if(this.bomb_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.bomb_list.length)
         {
            this.bomb_holder[this.bomb_list[_loc3_]].doPause();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.robot_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.robot_list.length)
         {
            this.danger_holder[this.robot_list[_loc3_]].doPause();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.conveyor_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.conveyor_list.length)
         {
            this.object_holder[this.conveyor_list[_loc3_]].doPause();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.collect_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.collect_list.length)
         {
            this.object_holder[this.collect_list[_loc3_]].doPause();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.mine_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.mine_list.length)
         {
            this.danger_holder[this.mine_list[_loc3_]].doPause();
            _loc3_ = _loc3_ + 1;
         }
      }
      for(var _loc4_ in this.acid_holder)
      {
         this.acid_holder[_loc4_].stop();
         this.acid_holder[_loc4_].anim.stop();
         this.acid_holder[_loc4_].splash.stop();
         this.acid_holder[_loc4_].bubbles.stop();
      }
      if(this.fan_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.fan_list.length)
         {
            this.object_holder[this.fan_list[_loc3_]].anim.stop();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.laser_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.laser_list.length)
         {
            this.laser_holder[this.laser_list[_loc3_]].doPause();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.acid_fall_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.acid_fall_list.length)
         {
            this.danger_holder[this.acid_fall_list[_loc3_]].anim.stop();
            this.danger_holder[this.acid_fall_list[_loc3_]].splash.stop();
            _loc3_ = _loc3_ + 1;
         }
      }
      _root.acid_holder.doPause();
   }
   function unpauseGame()
   {
      com.nitrome.toxic.Global.game_paused = false;
      this.player.doUnpause();
      var _loc3_;
      if(this.bomb_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.bomb_list.length)
         {
            this.bomb_holder[this.bomb_list[_loc3_]].doUnpause();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.robot_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.robot_list.length)
         {
            this.danger_holder[this.robot_list[_loc3_]].doUnpause();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.conveyor_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.conveyor_list.length)
         {
            this.object_holder[this.conveyor_list[_loc3_]].doUnpause();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.collect_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.collect_list.length)
         {
            this.object_holder[this.collect_list[_loc3_]].doUnpause();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.mine_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.mine_list.length)
         {
            this.danger_holder[this.mine_list[_loc3_]].doUnpause();
            _loc3_ = _loc3_ + 1;
         }
      }
      for(var _loc4_ in this.acid_holder)
      {
         this.acid_holder[_loc4_].play();
         this.acid_holder[_loc4_].anim.play();
         this.acid_holder[_loc4_].splash.play();
         this.acid_holder[_loc4_].bubbles.play();
      }
      if(this.fan_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.fan_list.length)
         {
            this.object_holder[this.fan_list[_loc3_]].anim.play();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.laser_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.laser_list.length)
         {
            this.laser_holder[this.laser_list[_loc3_]].doUnpause();
            _loc3_ = _loc3_ + 1;
         }
      }
      if(this.acid_fall_list.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < this.acid_fall_list.length)
         {
            this.danger_holder[this.acid_fall_list[_loc3_]].anim.play();
            this.danger_holder[this.acid_fall_list[_loc3_]].splash.play();
            _loc3_ = _loc3_ + 1;
         }
      }
      _root.acid_holder.doUnpause();
   }
}
