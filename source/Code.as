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
			trace("Compilation error: " + err.toString());
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
	
	static function getCodeBlockEnd(str, startInd) {
		var ind = startInd;
		var nextCloseInd = -1;
		var nextOpenInd = -1;
		var depth = 0;
		
		while (true) {
			if (ind > nextCloseInd) {
				nextCloseInd = Code.indOf(str, "}", ind);
			}
			if (ind > nextOpenInd) {
				nextOpenInd = Code.indOf(str, "{", ind);
			}
			var nextQuoteInd = Math.min(Code.indOf(str, "'", ind), Code.indOf(str, '"', ind));
			
			if (nextOpenInd < nextCloseInd && nextOpenInd < nextQuoteInd) {
				depth++;
				ind = nextOpenInd + 1;
				continue;
			}
			
			if (nextCloseInd === nextQuoteInd) {
				return str.length;
			}
			
			if (nextCloseInd < nextQuoteInd) {
				if (depth === 0) {
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
}