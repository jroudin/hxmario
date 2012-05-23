package com.example.hxmario;

import nme.display.Sprite;
import nme.utils.Timer;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.Rectangle;
import nme.geom.Point;
import nme.Assets;
import nme.events.Event;
import nme.events.TimerEvent;

import com.example.hxmario.keyboard.Keyboard;

class Player extends Sprite
{
	var Vspeed:Int;
	var Hspeed:Int;
	var timer:Timer;
	var faces:Array<Bitmap>;
	var collisions:Array<Array<Bool>>;
	var moves:IntHash<Bool>;

	var tileWidth:Int;
	var tileHeight:Int;

	public static inline var FACE:Int = 0;

	private static inline var LEFT:Int = 37;
	private static inline var UP:Int = 38;
	private static inline var RIGHT:Int = 39;
	private static inline var DOWN:Int = 40;

	private static inline var TIME:Int = 50;


	public function new(game:Mario)
	{
		super();
		Vspeed = 16;
		Hspeed = 16;
		faces = [];
		moves = new IntHash();
		tileWidth = game.tileWidth;
		tileHeight = game.tileHeight;

		initCollision(game);
		initFaces();
		initEvent();
		initTimer();

		faces[0].x = 13*tileWidth;
		nme.Lib.current.addChildAt(faces[0], 2);
	}

	private function walk(_:Event):Void
	{
		var H = faces[0].x + if (moves.get(LEFT)) -Hspeed else if (moves.get(RIGHT)) Hspeed else 0;
		var V = faces[0].y + if (moves.get(UP)) -Vspeed else Vspeed;

		var Hok = true;
		var Vok = true;

		for (x in Math.floor(faces[0].x/tileWidth)...Math.ceil((faces[0].x+faces[0].width)/tileWidth))
			for (y in Math.floor(V/tileHeight)...Math.ceil((V+faces[0].height)/tileHeight))
				if (x < 0 || y < 0 || y > collisions.length || x > collisions[y].length || !collisions[y][x])
				{
					if (x*tileWidth > (faces[0].x-tileWidth))
						faces[0].x = (x*tileWidth) + tileWidth - faces[0].width;
					else
						faces[0].x = (x*tileWidth) - tileWidth + faces[0].width;
					Vok = false;
					break;
				}

		for(x in Math.floor(H/tileWidth)...Math.ceil((H+faces[0].width)/tileWidth))
			for (y in Math.floor(faces[0].y/tileHeight)...Math.ceil((faces[0].y+faces[0].height)/tileHeight))
				if (x < 0 || y < 0 || y > collisions.length || x > collisions[y].length || !collisions[y][x])
				{
					if (y*tileHeight > (faces[0].y-tileHeight))
						faces[0].y = (y*tileHeight) + tileHeight - faces[0].height;
					else
						faces[0].y = (y*tileHeight) - tileHeight + faces[0].height;
					Hok = false;
					break;
				}

		if (Hok)
			faces[0].x = H;
		if (Vok)
			faces[0].y = V;

		#if (js || html5)
			initTimer();
		#end
	}

	private function initCollision(game:Mario):Void
	{
		collisions = [];
		for (row in game.getCollisions())
		{
			var arr = [];
			for (col in row)
				arr.push(col);
			collisions.push(arr);
		}
	}

	private function initTimer():Void
	{
		timer = new Timer(TIME);
		timer.addEventListener(TimerEvent.TIMER, walk);
		timer.start();
	}

	private function initEvent():Void
	{
		Keyboard.getInst().addCallback(UP, Vwalk);
		Keyboard.getInst().addCallback(DOWN, Vwalk);
		Keyboard.getInst().addCallback(LEFT, Hwalk);
		Keyboard.getInst().addCallback(RIGHT, Hwalk);
	}

	private function initFaces():Void
	{
		var charset = Assets.getBitmapData("data/img/mario.png");
		var bmpdata = new BitmapData(Math.floor(charset.width/6), charset.height, false);

		bmpdata.copyPixels(charset, new Rectangle(0, 0, charset.width/6, charset.height), new Point(0, 0));

		faces.push(new Bitmap(bmpdata));
	}

	private function Vwalk(code:Int, state:Bool):Void
	{
		moves.set(code, state);
		if (state)
			moves.set((code == UP) ? DOWN : UP, !state);
	}

	private function Hwalk(code:Int, state:Bool):Void
	{
		moves.set(code, state);
		if (state)
			moves.set((code == LEFT) ? RIGHT : LEFT, !state);
	}
}
