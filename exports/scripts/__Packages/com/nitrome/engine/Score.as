class com.nitrome.engine.Score
{
   static var _value;
   static var r;
   static var reset;
   static var STEPS = 0;
   function Score()
   {
   }
   static function init()
   {
      com.nitrome.engine.Score.rotate();
      com.nitrome.engine.Score._value = com.nitrome.engine.Score.r;
   }
   static function set value(v)
   {
      if(--com.nitrome.engine.Score.reset <= 0)
      {
         com.nitrome.engine.Score.rotate();
      }
      com.nitrome.engine.Score._value = com.nitrome.engine.Score.r + v;
   }
   static function get value()
   {
      return com.nitrome.engine.Score._value - com.nitrome.engine.Score.r;
   }
   static function rotate()
   {
      com.nitrome.engine.Score.reset = (_root._random_double() * com.nitrome.engine.Score.STEPS >> 0) + 1;
      com.nitrome.engine.Score.r = 100000 + (_root._random_double() * 200000 >> 0);
   }
}
