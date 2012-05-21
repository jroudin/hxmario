package com.example.hxmario;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.events.Event;
import nme.Assets;
import nme.Lib;
import nme.display.StageAlign;
import nme.display.StageScaleMode;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFieldAutoSize;
import nme.geom.Rectangle;
import nme.geom.Point;

import org.flixel.tmx.TmxMap;

class Mario extends Sprite
{
	var tileset:Bitmap;
	var tiles:Array<Array<Bitmap>>;
	var map:TmxMap;

	public function new()
	{
		super();
		this.x = 0;
		this.y = 0;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private function onAddedToStage(_:Event):Void
	{
		construct();
	}

	private function constructTiles():Void
	{
		var layer = map.layers.get("graphics");
		var bmpdata = new BitmapData(map.width*map.tileWidth, map.height*map.tileHeight);
		tiles = [];
		for (i in 0...layer.tileGIDs.length)
		{
			tiles[i] = [];
			for (j in 0...layer.tileGIDs[i].length)
			{
				var tileset = map.getGidOwner(layer.tileGIDs[i][j]);
				if (tileset != null)
				{
					var id = tileset.fromGid(layer.tileGIDs[i][j]);
					bmpdata.copyPixels(tileset.image, tileset.getRect(id), new Point(j*map.tileWidth,i*map.tileHeight));
				}
			}
		}
		addChild(new Bitmap(bmpdata));
	}

	private function construct():Void
	{
		map = new TmxMap( Assets.getText("data/map/world1.tmx") );
		var bmp = new BitmapData(16, 16);
		bmp.copyPixels(map.getTileSet("Tileset").image, new Rectangle(17, 17, 16, 16), new Point(0,0));
		tileset = new Bitmap(bmp);//

		constructTiles();
	}

	public static function main():Void
	{
		trace("Hello World ! ");
		Lib.current.addChild(new Mario());
	}
}
