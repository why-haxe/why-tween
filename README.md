# Overly Simple Tween Library

## API

```haxe
class Tween {
  static function time(milliseconds:Int, apply:(progress:Float)->Void, ?scheduler:Scheduler):CallbackLink;
}
interface Scheduler {
	function schedule(f:Void->Bool):Void;
}
```

Note that when implementing `Scheduler`, the given callback should not be invoked immediately as that is the responsibility of the scheduler user.