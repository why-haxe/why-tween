package why.tween;

interface Scheduler {
	/**
	 * Schedule a callback to be run on every frame, the returned bool indicates if it should continue
	 * Should NOT invoke `f` immediately
	 * @param f 
	 */
	function schedule(f:Void->Bool):Void;
}