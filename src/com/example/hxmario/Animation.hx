package com.example.hxmario;

import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.BitmapData;

import nme.events.Event;

import nme.geom.Point;

import org.flixel.tmx.TmxMap;

class Animation extends Sprite
{
	var bitmaps:Array<Bitmap>;
	var pos:Int;
	var prev:Int;

	public function new(map:TmxMap, gids:Array<Int>, x:Int, y:Int)
	{
		super();
		this.x = x*map.tileWidth;
		this.y = y*map.tileHeight;
		this.width = map.tileWidth;
		this.height = map.tileHeight;

		pos = -1;
		prev = -1;
		bitmaps = [];

		for (gid in gids)
			addTile(map, gid);

		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private function onAddedToStage(_:Event):Void
	{
		next();
	}

	public function next():Void
	{
		if (prev != -1)
		#if flash
			nme.Lib.current.removeChild(bitmaps[prev]);
		#else
			removeChild(bitmaps[prev]);
		#end

		prev = pos;
		pos++;
		if (pos >= bitmaps.length)
			pos = 0;
		
		#if flash
			bitmaps[pos].x = this.x;
			bitmaps[pos].y = this.y;

			nme.Lib.current.addChildAt(bitmaps[pos], 1);
		#else
			addChild(bitmaps[pos]);
		#end
	}

	private function addTile(map:TmxMap, gid:Int)
	{
		var bmpdata = new BitmapData(map.tileWidth, map.tileHeight, false, 0xFF0000);
		var tileset = map.getGidOwner(gid);
		if (tileset != null)
		{
			var id = tileset.fromGid(gid);
			bmpdata.copyPixels(tileset.image, tileset.getRect(id), new Point(0, 0));
			bitmaps.push(new Bitmap(bmpdata));
		}
	}
}
