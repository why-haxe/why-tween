package ;

import tink.testrunner.*;
import tink.unit.*;

@:asserts
class RunTests {
	static function main() {
		Runner.run(TestBatch.make(new RunTests())).handle(Runner.exit);
	}
	
	function new() {}
	
	public function tween() {
		why.Tween.tween(1000, v -> if(log(v) == 1) asserts.done());
		return asserts;
	}
	
	public function stop() {
		var progress = 0.;
		var binding = why.Tween.tween(1000, v -> progress = v);
		haxe.Timer.delay(binding.cancel, 500);
		haxe.Timer.delay(() -> {
			asserts.assert(progress > 0.49);
			asserts.assert(progress < 0.51);
			asserts.done();
		}, 1100);
		return asserts;
	}
	
	static function log<T>(v:T):T {
		trace(v);
		return v;
	}
}