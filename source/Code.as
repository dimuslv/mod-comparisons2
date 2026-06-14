class Code
{
	var str;
	var ind;
	//https://help.adobe.com/en_US/as3/learn/WS5b3ccc516d4fbf351e63e3d118a9b90204-7fd1.html#WS5b3ccc516d4fbf351e63e3d118a9b90204-7f6c
	
	static var playerVars = {
		x: "_x",
		y: "_y",
		vx: "vx",
		vy: "vy",
		wc: "wall_count",
		fc: "fall_count",
		st: "state"
	};
	
	static function isS(sym, str) {
		return str.indexOf(sym) !== -1;
	}
	
	static function isWhitespaceAt(str, ind) {
		return Code.isWhitespace(str.charAt(ind));
	}
	
	static function isWhitespace(c) {
		return Code.isS(c, " \t\r\n");
	}
	
	static function isDigit(c) {
		var num = c.charCodeAt(0);
		return num >= 48 && num <= 57;
	}
	
	static function isVarStart(c) {
		var num = c.charCodeAt(0);
		return num >= 65 && num <= 90 || num >= 97 && num <= 122 || num === 95;
	}
	
	static function isVarMiddle(c) {
		return Code.isVarStart(c) || Code.isDigit(c);
	}
	
	static function indOf(str1, str2, ind) {
		if (!ind) {
			ind = 0;
		}
		ind = str1.indexOf(str2, ind);
		if (ind === -1) {
			return str1.length;
		}
		return ind;
	}
	
	static function parseAngled(str, ind) {
		
		var obj = {_x: [0, 0], _y: [0, 0], vx: [0, 0], vy: [0, 0], state: [0, 0]};
		
		var firstLetter = -1;
		var lastLetter = -1;
		
		for (; ind < str.length; ind++) {
			var c = str.charAt(ind);
			
			if (Code.isWhitespace(c)) {
				continue;
			}
			
			if (c === ">") {
				break;
			}
			
			if (firstLetter === -1 || !Code.isS(c, ":;")) {
				if (firstLetter === -1) {
					firstLetter = ind;
				}
				lastLetter = ind + 1;
				continue;
			}
			
			var varName = str.slice(firstLetter, lastLetter);
			
			if (Code.playerVars.hasOwnProperty(varName)) {
				varName = Code.playerVars[varName];
			}
			
			if (_root.game.player[varName] === undefined) {
				break;
			}
			
			if (c === ";") {
				delete obj[varName];
				firstLetter = -1;
				continue;
			}
			
			obj[varName] = [0, 0];
			
			var failed = false;
			for (var i = 0; i < 2; i++) {
				firstLetter = -1;
				lastLetter = -1;
				for (ind++; ind < str.length; ind++) {
					c = str.charAt(ind)
					if (Code.isS(c, ",;")) {
						break;
					}
					
					if (!Code.isWhitespace(c)) {
						if (firstLetter === -1) {
							firstLetter = ind;
						}
						lastLetter = ind + 1;
					}
				}
				
				if (ind >= str.length || firstLetter === -1) {
					failed = true;
					break;
				}
				
				var num = Number(str.slice(firstLetter, lastLetter));
				if (isNaN(num)) {
					failed = true;
					break;
				}
				
				if (c === ";" && i === 0) {
					if (num >= 0) {
						obj[varName][1] = num;
					} else {
						obj[varName][0] = num;
					}
					break;
				} else if (c === "," && i === 1) {
					failed = true;
					break;
				} else {
					obj[varName][i] = num;
				}
			}
			if (failed) {
				break;
			}
			
			firstLetter = -1;
		}
		
		return [obj, Code.indOf(str, ">", ind) + 1];
	}
	
	static function compile(str, ind) {
		try {
			return new Parser(new Code().lex(str, ind)).program();
		} catch (err) {
			trace(err.toString());
		}
		return null;
	}
	
	function peek() {
		if (this.ind >= this.str.length) {
			return "$end";
		}
		return this.str.charAt(this.ind);
	}
	
	function consume() {
		if (this.ind >= this.str.length) {
			throw new Error("Code string ended unexpectedly");
		}
		return this.str.charAt(this.ind++);
	}
	
	function lex(str, startInd) {
		this.str = str;
		this.ind = startInd || 0;
		var arr = [];
		
		while (true) {
			while (Code.isWhitespace(this.peek())) {
				this.consume();
			}
			
			var tok = "";
			var c = this.peek();
			
			if (c === "$end") {
				
				break;
				
			} else if (Code.isVarStart(c)) {
				
				tok = "$v";
				do {
					tok += this.consume();
				} while (Code.isVarMiddle(this.peek()) || c === ".");
				
			} else if (c === ".") {
				
				arr.push(this.consume());
				tok = "$p";
				while (Code.isVarMiddle(this.peek())) {
					tok += this.consume();
				}
				
			} else if (Code.isDigit(c)) {
			
				tok = "$n";
				do {
					tok += this.consume();
				} while (Code.isDigit(this.peek()));
				
				if (this.peek() === ".") {
					do {
						tok += this.consume();
					} while (Code.isDigit(this.peek()));
				}
				
			} else if (c === '"') {
				
				tok = "$s";
				for (this.consume(); this.peek() !== '"'; this.consume()) {
					if (this.peek() == "\\") {
						this.consume();
						switch (this.peek()) {
							case "n":
								tok += "\n";
								break;
							case "t":
								tok += "\t";
								break;
							default:
								tok += this.peek();
								break;
						}
					} else {
						tok += this.peek();
					}
				}
				this.consume();
				
			} else if (Code.isS(c, "!+-*/%=&|<>^")) {
				
				tok += this.consume();
				
				if (Code.isS(c, "&|<>") && this.peek() === c) {
					tok += this.consume();
					if (c === ">" && this.peek() === ">") {
						tok += this.consume();
					}
				}
				
				if (this.peek() === "=") {
					tok += this.consume();
					if ((c === "!" || c === "=") && this.peek() === "=") {
						tok += this.consume();
					}
				} else if (this.peek() === c) {
					if (c === "+" || c === "-") {
						tok += this.consume();
					} else if (c === "/") {
						tok = "";
						while (this.peek() !== "$end" && this.consume() !== "\n") {}
					}
				} else if (c === "/" && this.peek() === "*") {
					tok = "";
					this.consume();
					while (true) {
                        if (this.consume() === "*") {
                            if (this.peek() === "/") {
                                this.consume();
                                break;
                            }
                        }
                    }
				}
				
			} else if (Code.isS(c, "()[];?:,~")) {
				tok += this.consume();
			} else {
				throw new Error("Unexpected symbol " + c + " at position " + this.ind);
			}
			
			if (tok) {
				arr.push(tok);
			}
		}
		
		arr.push("$end");
		return arr;
	}
	
	static function interpret(tree) {
		if (!(tree instanceof Array)) {
			return tree;
		}
		
		var op = tree[0];
		
		switch (op) {
			case "&&":
				return Code.interpret(tree[1]) && Code.interpret(tree[2]);
			case "||":
				return Code.interpret(tree[1]) || Code.interpret(tree[2]);
			case "?":
				return Code.interpret(tree[1]) ? Code.interpret(tree[2]) : Code.interpret(tree[3]);
			case ",":
				var arr = [];
				for (var i = 1; i < tree.length; i++) {
					arr.push(Code.interpret(tree[i]));
				}
				return arr;
			case ";":
				for (var i = 1; i < tree.length; i++) {
					Code.interpret(tree[i]);
				}
				return;
		}
		
		var val1 = Code.interpret(tree[1]);
		
		switch (op) {
			case "!":
				return !val1;
			case "~":
				return ~val1;
			case "$":
				return eval(val1);
		}
		
		var val2 = Code.interpret(tree[2]);
		
		switch (op) {
			case "|":
				return val1 | val2;
			case "^":
				return val1 ^ val2;
			case "&":
				return val1 & val2;
			case "==":
				return val1 == val2;
			case "!=":
				return val1 != val2;
			case "===":
				return val1 === val2;
			case "!==":
				return val1 !== val2;
			case "<":
				return val1 < val2;
			case ">":
				return val1 > val2;
			case "<=":
				return val1 <= val2;
			case ">=":
				return val1 >= val2;
			case "<<":
				return val1 << val2;
			case ">>":
				return val1 >> val2;
			case ">>>":
				return val1 >>> val2;
			case "+":
				return val1 + val2;
			case "-":
				return val1 - val2;
			case "*":
				return val1 * val2;
			case "/":
				return val1 / val2;
			case "%":
				return val1 % val2;
			case ".":
				return val1[val2];
			case "(":
				return val1.apply(null, val2);
			case "$=":
				if (tree.length === 4) {
					if (tree[3] === "++" || tree[3] === "--") {
						val2 = eval(val1);
						set(val1, val2 + (tree[3] === "++"? 1 : -1));
						return val2;
					} else {
						val2 = Code.interpret([tree[3], eval(val1), val2]);
					}
				}
				set(val1, val2);
				return val1;
		}
		
		var val3 = Code.interpret(tree[3]);
		
		switch (op) {
			case "=":
				if (tree.length === 5) {
					if (tree[4] === "++" || tree[4] === "--") {
						val3 = val1[val2];
						val1[val2] = val3 + (tree[4] === "++"? 1 : -1);
						return val3;
					} else {
						val3 = Code.interpret([tree[4], val1[val2], val3]);
					}
				}
				return val1[val2] = val3;
		}
		
		throw new Error("Unknown operation: " + op);
	}
	
	//static function findOperator(c) {
	//	return ",=?:|&^!<>+-*/%~[]{}().@".indexOf(c);
	//}
	
	/*static function find(str, value, startInd) {
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
			if (Code.isWhitespace(c)) {
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
							
							operators.push(/*thing here*//*);
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
	/*
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
			var isW = Code.isWhitespace(c);
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
	}*/
}