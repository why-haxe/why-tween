package why;

import haxe.Timer;
import why.tween.Scheduler;

using tink.CoreApi;

class Tween {
	static final DEFAULT_SCHEDULER = new DefaultScheduler();
	
	public static function tween(timeMs:Int, apply:(progress:Float)->Void, ?scheduler:Scheduler):CallbackLink {
		if(scheduler == null) scheduler = DEFAULT_SCHEDULER;
		final time = timeMs / 1000;
		var beginning = Timer.stamp();
		
		apply(0);
		scheduler.schedule(function() {
			return if(beginning < 0) {
				false;
			} else {
				final elapsed = Timer.stamp() - beginning;
				final progress = switch elapsed / time {
					case v if(v > 1):
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
		#if (js && !nodejs)
		(function loop() if(f()) js.Browser.window.requestAnimationFrame(cast loop))();
		#else
		final timer = new Timer(0);
		timer.run = function() if(!f()) timer.stop();
		#end
	}
}