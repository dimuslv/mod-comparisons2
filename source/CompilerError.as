class CompilerError extends Error {
	var pos;
	
	function CompilerError(msg, pos) {
		super(msg);
		this.pos = pos;
	}
}