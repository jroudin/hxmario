package com.example.hxmario;

import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.Assets;
import nme.Lib;
import nme.display.StageAlign;
import nme.display.StageScaleMode;

class Mario extends Sprite
{
	var block:Bitmap;

	public function new()
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private function onAddedToStage(_:Event):Void
	{
		construct();
	}

	private function construct():Void
	{
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		block = new Bitmap(Assets.getBitmapData ("data/img/block.png"));
		center();
		addChild(block);
	}

	private function center():Void
	{
		block.x = (stage.stageWidth - block.width) / 2;
		block.y = (stage.stageHeight - block.height) / 2;
	}

	public static function main():Void
	{
		trace("Hello World ! ");
		Lib.current.addChild(new Mario());
	}
}
