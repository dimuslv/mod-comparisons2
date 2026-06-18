class Parser {
	var arr;
	var ind;
	
	static var constObj = {
		true: true,
		false: false,
		undefined: undefined,
		null: null
	};
	
	static var globalShortcuts = {
		p: "_root.game.player",
		g: "_root.game",
		G: "com.nitrome.toxic.Global"
	};
	
	static function isAssignmentToken(str) {
		return str === "=" || str !== ">=" && str !== "<=" && !Code.isS(str.charAt(0), "$!=") && str.charAt(str.length - 1) === "=";
	}
	
	static function getToSetToken(tok) {
		if (tok === "$") {
			return "$=";
		}
		if (tok === ".") {
			return "=";
		}
		throw new CompilerError("Unexpected operation " + tok + " before assignment", this.pos());
	}
	
	static function isOp(op, ops) {
		if (typeof ops === "string") {
			return Code.isS(op, ops);
		}
		
		for (var i in ops) {
			if (ops[i] === op) {
				return true;
			}
		}
		
		return false;
	}
	
	function Parser(arr) {
		this.arr = arr;
		this.ind = 0;
	}
	
	function wrongTokenError() {
		throw new CompilerError("Unexpected token: " + this.peek(), this.pos());
	}
	
	function pos() {
		return this.arr[this.ind + 1];
	}
	
	function peek() {
		return this.arr[this.ind];
	}
	
	function match(token) {
		if (this.peek() !== token) {
			wrongTokenError();
		}
		this.consume();
	}
	
	function consume() {
		var v = this.peek();
		this.ind += 2;
		return v;
	}
	
	function program() {
		var a = this.statementStack();
		this.match("$end");
		return a;
	}
	
	function statementStack() {
		var a = [";"];
		while (this.peek() !== "$end") {
			a.push(this.statement());
			this.match(";");
		}
		return a;
	}
	
	function statement() {
		return this.expression();
	}
	
	function commaList() {
		if (this.peek() === ")" || this.peek() === "]") {
			return [","];
		}
		var a = [",", this.expression()];
		while (this.peek() === ",") {
			this.consume();
			a.push(this.expression());
		}
		return a;
	}
	
	function expression() {
		return this.assignment();
	}
	
	function assignment() {
		var a = this.conditional();
		if (Parser.isAssignmentToken(this.peek())) {
			a[0] = Parser.getToSetToken(a[0]);
			var op = this.consume().slice(0, -1);
			a.push(this.assignment());
			if (op) {
				a.push(op);
			}
		}
		return a;
	}
	
	function leftAssocOp(ops, next) {
		var a = this[next]();
		while (Parser.isOp(this.peek(), ops)) {
			a = [this.consume(), a, this[next]()];
		}
		return a;
	}
	
	function rightAssocOp(ops, next) {
		var a = this[next]();
		if (Parser.isOp(this.peek(), ops)) {
			a = [this.consume(), a, rightAssocOp(ops, next)];
		}
		return a;
	}
	
	function conditional() {
		var a = this.logOr();
		if (this.peek() === "?") {
			a = [this.consume(), a, this.conditional()];
			this.match(":");
			a.push(this.conditional());
		}
		return a;
	}
	
	function logOr() {
		return rightAssocOp(["||"], "logAnd");
	}
	
	function logAnd() {
		return rightAssocOp(["&&"], "bitOr");
	}
	
	function bitOr() {
		return leftAssocOp("|", "bitXor");
	}
	
	function bitXor() {
		return leftAssocOp("^", "bitAnd");
	}
	
	function bitAnd() {
		return leftAssocOp("&", "equality");
	}
	
	function equality() {
		return leftAssocOp(["==", "!=", "===", "!=="], "relational");
	}
	
	function relational() {
		return leftAssocOp(["<", ">", "<=", ">="], "bitShift");
	}
	
	function bitShift() {
		return leftAssocOp(["<<", ">>", ">>>"], "sum");
	}
	
	function sum() {
		return leftAssocOp("+-", "product");
	}
	
	function product() {
		return leftAssocOp("*/%", "unary");
	}
	
	function unary() {
		switch (this.peek()) {
			case "+":
				this.consume();
				return this.unary();
			case "-":
				return [this.consume(), 0, this.unary()];
			case "!":
			case "~":
				return [this.consume(), this.unary()];
			case "++":
			case "--":
				var op = this.consume().charAt(0);
				var a = this.unary();
				a[0] = Parser.getToSetToken(a[0]);
				a.push(1, op);
				return a;
		}
		
		var a = this.property();
		
		if (this.peek() === "++" || this.peek() === "--") {
			var op = this.consume();
			a[0] = Parser.getToSetToken(a[0]);
			a.push(1, op);
		}
		
		return a;
	}
	
	function property() {
		var a = this.singleton();
		while (true) {
			switch (this.peek()) {
				case ".":
					this.consume();
					if (this.peek().slice(0, 2) !== "$p") {
						wrongTokenError();
					}
					a = [".", a, this.consume().slice(2)];
					continue;
				case "[":
					this.consume();
					a = [".", a, this.expression()];
					this.match("]");
					continue;
				case "(":
					a = [this.consume(), a, this.commaList()];
					this.match(")");
					continue;
			}
			break;
		}
		return a;
	}
	
	function singleton() {
		var a;
		if (this.peek() === "(") {
			this.consume();
			a = this.expression();
			this.match(")");
		} else if (this.peek() === "[") {
			this.consume();
			a = this.commaList();
			this.match("]");
		} else switch (this.peek().slice(0, 2)) {
			case "$n":
				return Number(this.consume().slice(2));
			case "$s":
				return this.consume().slice(2);
			case "$v":
				var v = this.consume().slice(2);
				if (Parser.constObj.hasOwnProperty(v)) {
					return Parser.constObj[v];
				}
				if (Code.playerVars.hasOwnProperty(v)) {
					v = "_root.game.player." + Code.playerVars[v];
				} else if (Parser.globalShortcuts.hasOwnProperty(v.charAr(0)) && (v.length === 1 || v.charAt(1) === ".")) {
					v = Parser.globalShortcuts[v] + v.slice(1);
				}
				return ["$", v];
			default:
				wrongTokenError();
		}
		
		return a;
	}
}