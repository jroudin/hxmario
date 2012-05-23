package com.example.hxmario.keyboard;

import nme.events.KeyboardEvent;

class Keyboard
{
	private static var inst:Keyboard = null;// new Keyboard();

	var keys:IntHash<Bool>;
	var callbacks:IntHash<Array<Int -> Bool -> Void>>;

	private function new()
	{
		keys = new IntHash();
		callbacks = new IntHash();
		nme.Lib.current.stage.addEventListener(nme.events.KeyboardEvent.KEY_DOWN, onKeyDown);
		nme.Lib.current.stage.addEventListener(nme.events.KeyboardEvent.KEY_UP, onKeyUp);
	}

	private function onKeyDown(e:KeyboardEvent):Void
	{
		keys.set(e.keyCode, true);
		run(e.keyCode, true);
	}

	private function run(code:Int, state:Bool):Void
	{
		if (callbacks.exists(code))
		{
			var arr:Array<Int -> Bool -> Void> = callbacks.get(code);
			if (arr != null)
			for(fct in arr)
				fct(code, state);
		}
	}

	private function onKeyUp(e:KeyboardEvent):Void
	{
		keys.set(e.keyCode, false);
		run(e.keyCode, false);
	}

	public function isDown(key:Int):Bool
	{
		return keys.exists(key) ? keys.get(key) : false;
	}

	public function addCallback(code:Int, c:Int -> Bool -> Void):Void
	{
		if (!callbacks.exists(code))
			callbacks.set(code, []);

		callbacks.get(code).push(c);
	}

	public static function getInst():Keyboard
	{
		if (inst == null)
			inst = new Keyboard();
		return inst;
	}
}
