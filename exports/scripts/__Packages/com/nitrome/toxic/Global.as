class com.nitrome.toxic.Global
{
   static var level_id;
   static var secret_id;
   static var level_height;
   static var level_width;
   static var scroll_x_min;
   static var scroll_x_max;
   static var scroll_y_min;
   static var scroll_y_max;
   static var level_rows;
   static var level_cols;
   static var game_paused = true;
   static var TOTAL_POWER_CELLS = 500;
   static var TILE_WIDTH = 32;
   static var TILE_HEIGHT = 32;
   static var LEFT = 0;
   static var RIGHT = 1;
   static var UP = 2;
   static var DOWN = 3;
   static var START = 0;
   static var STAND = 1;
   static var DUCK = 2;
   static var WALK = 3;
   static var JUMP = 4;
   static var FALL = 5;
   static var WALL = 6;
   static var HIT = 7;
   static var DIE = 8;
   static var END = 9;
   static var ALERT = 10;
   static var TURN = 11;
   static var AIM = 12;
   static var FIRE = 13;
   static var RESET = 14;
   static var LEAP = 15;
   static var LAND = 16;
   static var LEAPLAND = 17;
   static var dir_string = new Array("left","right");
   static var state_string = new Array("start_","stand_","duck_","walk_","jump_","fall_","wall_","hit_","die_","end_","alert_","turn_","aim_","fire_","reset_","leap_","land_","leapland_");
   static var UP_PRESSED = false;
   static var DOWN_PRESSED = false;
   static var DIR_PRESSED = 0;
   static var LAST_DIR_PRESSED = 0;
   static var can_jump = true;
   static var BOMB_BASIC = 1;
   static var BOMB_PLATFORM = 2;
   static var BOMB_DIGGER = 3;
   static var BOMB_WALKER = 4;
   static var BOMB_BOSS = 5;
   static var level_names = new Array("","HACKING THE SYSTEM","AEROSOL","LASER PHASER","DIGG IT","STEADY PLATFORM","ARACHNOPHOBIA","THE HIGHS AND LOWS","TAKE COVER","READY AIM FIRE","BIGFOOT","WHEEL DEAL","ANKLE BITERS","LOOSE GROUND","CLOSE PROXIMITY","REGENERATION","BLAST FROM THE PAST","CHAIN REACTION","VERTIGO","REMOTE CONTROL","MOTHER");
   static var secret_names = new Array("","","FISH AND DRIPS","","","","MAXIMUM SECURITY","SLEEPY HOLO","","GROW UP","","","A BUG\'S LIFE","DEAD SPACE","","","MARATHON MAN","SWARM","LASER QUEST","","QUICKSTEP");
   static var powercell_count = new Array(0,14,7,10,16,12,25,17,14,14,28,18,12,3,25,14,28,39,8,26,15);
   static var secret_powercell_count = new Array(0,0,8,0,0,0,8,33,0,12,0,0,15,8,0,0,23,19,2,0,27);
   function Global()
   {
   }
}
