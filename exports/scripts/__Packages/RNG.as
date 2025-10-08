class RNG
{
	static var rngSeed = 0;
	function RNG()
	{
	}
	static function bigmult(a, b)
	{
		var _loc3_ = 0;
		_loc3_ += a * (b & 0xFFFF) % 4294967296;
		_loc3_ += a * (b >> 16) << 16;
		return int(_loc3_);
	}
	static function nextSeed(seed)
	{
		if(seed & 1)
		{
			return seed >> 1 ^ 0x48000000;
		}
		return seed >> 1;
	}
	static function doHash(seed)
	{
		seed = (seed << 13 ^ seed) - (seed >> 21);
		var _loc2_ = RNG.bigmult(seed,seed);
		_loc2_ = int(_loc2_ * 15731);
		_loc2_ = int(_loc2_ + 789221);
		_loc2_ = RNG.bigmult(seed,_loc2_);
		_loc2_ = int(_loc2_ - 771171059);
		_loc2_ = int(_loc2_ & 0x7FFFFFFF);
		_loc2_ += seed;
		return (_loc2_ << 13 ^ _loc2_) - (_loc2_ >> 21);
	}
	static function _random(range)
	{
		if(RNG.rngSeed == 0)
		{
			return random(range);
		}
		RNG.rngSeed = RNG.nextSeed(RNG.rngSeed);
		return (RNG.doHash(RNG.rngSeed * 71) & 0x7FFFFFFF) % range;
	}
	static function _random_double()
	{
		if(RNG.rngSeed == 0)
		{
			return Math.random();
		}
		return RNG._random(2147483648) / 2147483648;
	}
}
