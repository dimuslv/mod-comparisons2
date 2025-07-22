_root.rngSeed = 0;
_root.bigmult = function(a, b)
{
   var _loc3_ = 0;
   _loc3_ += a * (b & 0xFFFF) % 4294967296;
   _loc3_ += a * (b >> 16) << 16;
   return int(_loc3_);
};
_root.nextSeed = function(seed)
{
   if(seed & 1)
   {
      return seed >> 1 ^ 0x48000000;
   }
   return seed >> 1;
};
_root.doHash = function(seed)
{
   seed = (seed << 13 ^ seed) - (seed >> 21);
   var _loc3_ = _root.bigmult(seed,seed);
   _loc3_ = int(_loc3_ * 15731);
   _loc3_ = int(_loc3_ + 789221);
   _loc3_ = _root.bigmult(seed,_loc3_);
   _loc3_ = int(_loc3_ - 771171059);
   _loc3_ = int(_loc3_ & 0x7FFFFFFF);
   _loc3_ += seed;
   return (_loc3_ << 13 ^ _loc3_) - (_loc3_ >> 21);
};
_root._random = function(range)
{
   if(_root.rngSeed == 0)
   {
      return random(range);
   }
   _root.rngSeed = _root.nextSeed(_root.rngSeed);
   return (_root.doHash(_root.rngSeed * 71) & 0x7FFFFFFF) % range;
};
_root._random_double = function()
{
   if(_root.rngSeed == 0)
   {
      return Math.random();
   }
   return _root._random(2147483648) / 2147483648;
};
