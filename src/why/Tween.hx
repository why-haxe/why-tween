package why;

import haxe.Timer;
import why.tween.Scheduler;

using tink.CoreApi;

class Tween {
	static final DEFAULT_SCHEDULER = new DefaultScheduler();

	/**
	 * Time-based tweening
	 * @param duration in milliseconds 
	 * @param apply called on every tick
	 * @param scheduler 
	 * @return CallbackLink to cancel the tween
	 */
	public static function time(milliseconds:Int, apply:(progress:Float)->Void, ?scheduler:Scheduler):CallbackLink {
		if(scheduler == null) scheduler = DEFAULT_SCHEDULER;
		final time = milliseconds / 1000;
		var beginning = Timer.stamp();
		
		apply(0);
		scheduler.schedule(function() {
			return if(beginning < 0) {
				false;
			} else {
				final elapsed = Timer.stamp() - beginning;
				final progress = switch elapsed / time {
					case v if(v >= 1):
						beginning = -1;
						1;
					case v:
						v;
				}
				apply(progress);
				true;
			}
		});
		
		return function() beginning = -1;
	}
}

private class DefaultScheduler implements Scheduler {
	public function new() {}
	public function schedule(f:Void->Bool) {
		#if nodejs
		(function loop() if(f()) js.Node.setImmediate(loop))();
		#elseif js
		(function loop() if(f()) js.Browser.window.requestAnimationFrame(cast loop))();
		#else
		final timer = new Timer(0);
		timer.run = function() if(!f()) timer.stop();
		#end
	}
}