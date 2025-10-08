class Code
{
	static var rngSeed = 0;
	
	//static var operators = ",=?:|&^!<>+-*/%~[]{}().@";
	
	static var operators = {
		"+" : 0,
		"-",
		"*",
		"/",
		"%",
		
	};
	
	static var operatorPrecedence = [
		11, //+ 0
		11, //- 1
		
	];
	
	"+-*/%=,|^&<>~!?:";
	"== || && "
	//          cba?
	//https://help.adobe.com/en_US/as3/learn/WS5b3ccc516d4fbf351e63e3d118a9b90204-7fd1.html#WS5b3ccc516d4fbf351e63e3d118a9b90204-7f6c
	
	static function isWhiteSpaceAt(str, ind) {
		return " \t\r\n".indexOf(str.charAt(ind)) != -1;
	}
	
	static function isWhiteSpace(c) {
		return " \t\r\n".indexOf(c) != -1;
	}
	
	static function findOperator(c) {
		return ",=?:|&^!<>+-*/%~[]{}().@".indexOf(c);
	}
	
	static function find(str, value, startInd) {
		var ind = str.indexOf(value, startInd);
		if (ind === -1)
			ind = str.length;
		return ind;
	}
	
	static function getCodeBlockEnd(str, startInd) {
		var ind = startInd;
		var nextCloseInd = -1;
		var nextOpenInd = -1;
		var depth = 0;
		
		while (true) {
			if (ind > nextCloseInd) {
				nextCloseInd = Code.find(str, "}", ind);
			}
			if (ind > nextOpenInd) {
				nextOpenInd = Code.find(str, "{", ind);
			}
			var nextQuoteInd = Math.min(Code.find(str, "'", ind), Code.find(str, '"', ind));
			
			if (nextOpenInd < nextCloseInd && nextOpenInd < nextQuoteInd) {
				depth++;
				ind = nextOpenInd + 1;
				continue;
			}
			
			if (nextCloseInd === nextQuoteInd) {
				return str.length;
			}
			
			if (nextCloseInd < nextQuoteInd) {
				if (!depth) {
					return nextCloseInd;
				}
				depth--;
				ind = nextCloseInd + 1;
				continue;
			}
			
			var q = str.charAt(nextQuoteInd);
			var ind2 = nextQuoteInd + 1;
			while (true) {
				ind2 = str.indexOf(q, ind2);
				if (ind2 === -1) {
					return str.length;
				}
				var slashStart = ind2 - 1;
				while (str.charAt(slashStart) === "\\") {
					slashStart--;
				}
				if ((ind2 - slashStart) & 1) {
					ind = ind2 + 1;
					break;
				}
				ind2++;
			}
		}
	}
	
	static function getIndex(arr, val) {
		for (var i = 0; i < arr.length; i++) {
			if (arr[i] === val) {
				return i;
			}
		}
		return -1;
	}
	
	static function throwError(str) {
		trace(str);
	}
	
	static function pushOp(op, operators, instructions) {
		for (var i = operators.length - 1; i >= 0; i--) {
			if (Code.getPrec(operators[i]) >= Code.getPrec(op)) {
				instructions.push(operators.pop());
			} else {
				break;
			}
		}
		operators.push(op);
	}
	
	static function compileValue(str, start, end) {
		var operands = [];  // asdasd
		var operators = []; // +
		// something as something
		
		var nStart = -1;
		var nEnd = -1;
		
		for (var ind = start; true; ind++) {
			var c = str.charAt(ind);
			if (Code.isWhiteSpace(c)) {
				if (nStart != -1) {
					var curN = str.slice(nStart, ind);
					nStart = -1;
					
					var sOperators = ["as", "in", "instanceof", "is", "delete", "typeof", "new"];
					var isT = false;
					for (var i = 0; i < sOperators.length; i++) {
						if (curN === sOperators[i]) {
							if (operators.length >= operands.length) {
								operands.push("");
							}
							
							operators.push(/*thing here*/);
							isT = true;
							break;
						}
					}
					if (!isT && operands.length <= operators.length) {
						var sOperands = ["true", "false", "null", "undefined"];
						var sValues = [true, false, null, undefined];
						
						isT = false;
						for (var i = 0; i < sOperands.length; i++) {
							if (curN === sOperands[i]) {
								operands.push(sValues[i]);
								isT = true;
								break;
							}
						}
					}
				}
				
				continue;
			}
			
			var opNum = Code.findOperator(c);
			if (opNum != -1) {
				//0, 1= 2? 3: 4| 5& 6^ 7! 8< 9> 10+ 11- 12* 13/ 14% 15~ 16[ 17] 18{ 19} 20( 21) 22. 23@
				var curOperand = str.slice(pStart, pEnd);
				if (curOperand)
			}
			
			if (c === '"' || c === "'") {
				
			}
			
			
		}
	}
	
	/*
	+ ++ ++ +=
	- -- -- -=
	/ /= // /*
	% %=
	* *= */               /*
	= == ===
	& && &=
	| || |=
	^ ^=
	~
	> >> >>> >= >>= >>>=
	< << <= <<=
	! != !==
	*/
	// still need to implement brackets
	static function compileValue2(str, start, end) {
		var instructions = [];
		var operands = [];  // asdasd
		var operators = []; // +
		// something as something
		
		var sStart = -1;
		var sEnd = -1;
		var nextIsOperand = true;
		var spaceBetween = false;
		
		var qOperator = -1;
		
		for (var ind = start; ind <= end; ind++) {
			var c = str.charAt(ind);
			var op = Code.getOp(c);
			var isW = Code.isWhiteSpace(c);
			if (isW) {
				spaceBetween = true;
			}
			if (isW || op !== -1) {
				if (sStart !== -1) {
					var curS = str.slice(sStart, ind);
					sStart = -1;
					
					if (qOperator !== -1) { // we're assuming text operators never combine with anything and aren't postfix
						Code.pushOp(qOperator, operators, instructions);
						qOperator = -1;
					}
					
					var op2 = Code.getOp(curS); //implement
					if (op2 !== -1) {
						if (nextIsOperand && !Code.isPrefix(op2)) { //implement
							Code.throwError("Unexpected operator at index " + ind);
							return;
						}
						qOperator = op2;
						nextIsOperand = true;
					} else if (nextIsOperand) {
						nextIsOperand = false;
						instructions.push(curS); //Should change the value if needed
					} else {
						Code.throwError("Unexpected operand at index " + ind);
						return;
					}
				}
			}
			
			if (op !== -1) { //and make sure it's not floating point...
				if (nextIsOperand) {
					var op3 = Code.combineOps(qOperator, op, spaceBetween); //implement
					spaceBetween = false;
					nextIsOperand = true;
					if (op3 === -1) {
						if (!Code.canBePrefix(op)) { //implement
							Code.throwError("Unexpected operator at index " + ind);
							return;
						}
						if (qOperator !== -1) {
							Code.pushOp(qOperator, operators, instructions);
						}
						
						qOperator = op;
					} else {
						qOperator = op3;
						
					}
				} else {
					spaceBetween = false;
					nextIsOperand = true;
					if (qOperator !== -1) {
						Code.pushOp(qOperator, operators, instructions);
					}
					
					qOperator = op;
				}
				if (Code.isPostfix(qOperator)) { //implement
					nextIsOperand = false;
				}
			} else if (!isW && sStart === -1) {
				sStart = ind;
			}
		}
	}
}