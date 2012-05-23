package com.example.hxmario;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.events.Event;
import nme.Assets;
import nme.Lib;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.utils.Timer;
import nme.events.TimerEvent;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFieldAutoSize;
import nme.geom.Rectangle;
import nme.geom.Point;

import org.flixel.tmx.TmxObjectGroup;
import org.flixel.tmx.TmxMap;

class Mario extends Sprite
{
	var map:TmxMap;
	var animatedTiles:Array<Array<Int>>; // Using GID
	var staticTiles:Array<Point>; // Using coordinates
	var collisions:Array<Array<Bool>>;
	var objects:Array<Animation>;
	var timer:Timer;

	public var tileWidth(getTileWidth, null):Int;
	public var tileHeight(getTileHeight, null):Int;

	private static inline var TIME:Int = 100;

	public function new()
	{
		super();
		this.x = 0;
		this.y = 0;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	public function getTileWidth():Int
	{
		return map.tileWidth;
	}

	public function getTileHeight():Int
	{
		return map.tileHeight;
	}

	private function onAddedToStage(_:Event):Void
	{
		construct();
		new Player(this);
	}

	public function constructAnimatedTiles(group:TmxObjectGroup):Void
	{
		var layer = map.layers.get(group.properties.resolve("layer"));
		for (object in group.objects)
			if (object.type == "anim")
			{
				var tiles = [];
				var y = Math.floor(object.y/map.tileHeight);
				for(x in Math.floor(object.x/map.tileWidth)...Math.floor(object.width/map.tileWidth))
					tiles.push(layer.tileGIDs[y][x]);
				animatedTiles.push(tiles);
			}
	}

	private function readObjects():Void
	{
		for(group in map.objectGroups)
			switch(group.properties.resolve("type"))
			{
				case "anim":
					constructAnimatedTiles(group);
				default:
					// Nothing to do :3
			}
	}

	private function getAnimation(gid:Int):Null<Array<Int>>
	{
		for (array in animatedTiles)
			for (tile in array)
				if (tile == gid)
					return array;
		return null;
	}

	public function getCollisions():Array<Array<Bool>>
	{
		return collisions;
	}

	private function constructCollisions():Void
	{
		var layer = map.layers.get("collisions");
		collisions = [];
		for (j in 0...layer.tileGIDs.length)
		{
			var arr = [];
			for(i in 0...layer.tileGIDs[j].length)
			{
				var gid = layer.tileGIDs[j][i];
				var tileset = map.getGidOwner(gid);
				if (tileset == null)
					arr.push(true);
				else 
					arr.push(tileset.fromGid(gid) == 0);
			}
			collisions.push(arr);
		}
	}

	private function constructTiles():Void
	{
		var layer = map.layers.get("graphics");
		var bmpdata = new BitmapData(map.width*map.tileWidth, map.height*map.tileHeight, false, map.getGidOwner(1).trans);

		for (i in 0...layer.tileGIDs.length)
			for (j in 0...layer.tileGIDs[i].length)
			{
				var gid = layer.tileGIDs[i][j];
				var tileset = map.getGidOwner(gid);
				if (tileset != null)
				{
					var animation = getAnimation(gid);
					if (animation == null)
					{
						var id = tileset.fromGid(gid);
						bmpdata.copyPixels(tileset.image, tileset.getRect(id), new Point(j*map.tileWidth,i*map.tileHeight));
					}
					else
					{
						objects.push(new Animation(map, animation, j, i));
					}
				}
			}
		var bmp = new Bitmap(bmpdata);
		bmp.cacheAsBitmap = true;
		addChild(bmp);

		for(object in objects)
			nme.Lib.current.addChild(object);
	}

	private function construct():Void
	{
		map = new TmxMap( Assets.getText("data/map/world1.tmx") );
		animatedTiles = [];
		staticTiles = [];
		objects = [];
		readObjects();
		constructTiles();
		constructCollisions();
		initTimer();
	}

	private function initTimer():Void
	{
		timer = new Timer(TIME);
		timer.addEventListener(TimerEvent.TIMER, onTime);
		timer.start();
	}

	private function onTime(_:Event):Void
	{
		for (object in objects)
			object.next();

		#if (js || html5)
			initTimer();
		#end
	}

	public static function main():Void
	{
		trace("Hello World ! ");
		Lib.current.addChildAt(new Mario(), 0);
	}
}
