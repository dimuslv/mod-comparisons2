class RNG
{
	static var rngSeed = 0;
	
	static function bigmult(a, b) {
		var result = 0;
		result += a * (b & 0xFFFF) % 4294967296;
		result += a * (b >> 16) << 16;
		return int(result);
	}
	
	static function nextSeed(seed) {
		if (seed & 1) {
			return (seed >> 1) ^ 0x48000000;
		}
		return seed >> 1;
	}
	
	static function doHash(seed) {
		seed = ((seed << 13) ^ seed) - (seed >> 21);
		var result = RNG.bigmult(seed, seed);
		result = int(result * 15731);
		result = int(result + 789221);
		result = RNG.bigmult(seed, result);
		result = int(result - 771171059);
		result = int(result & 0x7FFFFFFF);
		
		result += seed;
		return ((result << 13) ^ result) - (result >> 21);
	}
	
	static function _random(range) {
		if (RNG.rngSeed == 0) {
			return random(range);
		}
		
		RNG.rngSeed = RNG.nextSeed(RNG.rngSeed);
		return (RNG.doHash(RNG.rngSeed * 71) & 0x7fffffff) % range;
	}
	
	static function _random_double() {
		if (RNG.rngSeed == 0) {
			return Math.random();
		}
		
		return RNG._random(0x80000000) / 0x80000000;
	}
}

/*var i = 0;
while (i < 10) {
	trace(random(100));
	i++;
}
trace("");
while (i < 20) {
	trace(((i & 1)? Math.random() : random(100)));
	i++;
}

var i = 0;
_root.rngSeed = random(0x80000000);
while (i < 10) {
	trace(_root._random(100));
	i++;
}
trace("");
while (i < 20) {
	trace(((i & 1)? _root._random_double() : _root._random(100)));
	i++;
}*/

/*var i = 0;
while (i < 20) {
	trace(random(100));
	i++;
}

i = 0;
_root.rngSeed = random(1000);
while (i < 20) {
	trace(_root._random(100));
	i++;
}

trace("");
var rngSeed = 17;
i = 0;
while (i < 1000000) {
	_root.rngSeed = _root._random(0x80000000);
	i++;
}
trace(_root.rngSeed);*/